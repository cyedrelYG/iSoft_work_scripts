#!/bin/bash -ex
echo "Run $0 $1 $2"

if [ $# -ne 2 ] ; then
    echo "Usage: $0 <ip> <key>"
    exit 1
fi

ip=${1}
key=${2}
workdir=$(dirname $(readlink -e ${0}))
logfile=${workdir}/$(basename ${0} .sh)_$(date +%Y%m%d).log

if [ "${key}" = "key" ] ; then
    echo "No key found! Skip"
    exit 0
fi
key=$(echo ${key} | sed 's|key||g')

touch ${logfile}
if grep -q "${key}" ${logfile} ; then
   echo "Already done! Skip"
   exit 0
fi

ssh_args="-q -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no -o ConnectTimeout=30"
ssh_cmd="sshpass -p market1 ssh ${ssh_args}"
scp_cmd="sshpass -p market1 scp ${ssh_args}"

### Run code

${ssh_cmd} root@${ip} "bash -s" <<EOF

disk=\$(mount | grep "on / type" | awk '{print \$1}' | cut -c1-8)
part=\$(mount | grep "on / type" | awk '{print \$1}' | cut -c9)

size=\$(df -m | grep -e "^\${disk}\${part}.*% /\$" | awk '{print \$2}')

if [ 80000 -gt \${size} ] ; then
        partprobe \${disk}
        resize2fs \${disk}\${part}
fi

exit 0

EOF

