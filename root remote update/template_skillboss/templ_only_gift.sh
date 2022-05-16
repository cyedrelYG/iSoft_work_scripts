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
${scp_cmd} ${workdir}/gift_template.hwd2.txt root@${ip}:/root

${ssh_cmd} root@${ip} "bash -s" <<EOF
lima=/opt/lima
sftw=/opt/sftw
root=/root

if [ -f /tmp/end.txt ] ; then
rm -vf /tmp/end.txt
fi

if [ -d \$lima ] ; then
mv -v \$lima/build/BACKSERVER/gift_template.hwd2.txt \$lima/build/BACKSERVER/gift_template.hwd2.txt_\$(date +%Y%m%d)
mv -v \$root/gift_template.hwd2.txt \$lima/build/BACKSERVER/
elif [ -d \$sftw ] ; then
mv -v \$sftw/build/BACKSERVER/gift_template.hwd2.txt \$sftw/build/BACKSERVER/gift_template.hwd2.txt_\$(date +%Y%m%d)
mv -v \$root/gift_template.hwd2.txt \$sftw/build/BACKSERVER/
else
cat \$(find /opt/ -name mc3_key.txt) >>/tmp/end.txt
echo "I am не ЛИМА" 
fi
cat \$(find /opt/ -name mc3_key.txt) >>/tmp/end.txt
EOF
${ssh_cmd} root@${ip} "cat /tmp/end.txt" >>${logfile}