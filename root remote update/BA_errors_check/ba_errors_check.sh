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

if [ -f /tmp/end.txt ] ; then
rm -vf /tmp/end.txt
fi
rm -f /tmp/errors.log /tmp/ernum.log
zgrep -a 'InvalidBillValidationFail\|InvalidBillTransportProblem\|TWISTED NOTE REJECT\|COASTLINE FAIL\|SLOW MECH' /var/log/devices_server.log >>/tmp/errors.log

for devlog in 1 2 3 4 5 6 7 8 9 10
do
zgrep -a 'InvalidBillValidationFail\|InvalidBillTransportProblem\|TWISTED NOTE REJECT\|COASTLINE FAIL\|SLOW MECH' /var/log/devices_server.log.\$devlog.gz >>/tmp/errors.log
done

grep -c 'InvalidBillValidationFail\|InvalidBillTransportProblem\|TWISTED NOTE REJECT\|COASTLINE FAIL\|SLOW MECH' /tmp/errors.log >>/tmp/ernum.log

cat /tmp/ernum.log | xargs echo \$(find /opt/ -name mc3_key.txt -exec cat '{}' \;) >>/tmp/end.txt
rm -vf /tmp/errors.log /tmp/ernum.log 

EOF
${ssh_cmd} root@${ip} "cat /tmp/end.txt" >>${logfile}