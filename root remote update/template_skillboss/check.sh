#!/bin/bash -ex
echo "Run $0 $1 $2"


ip=${1}

### Run code 
#${scp_cmd} /home/support/ygscripts/scripts/app.asar root@${ip}:/root
grep ${ip} //root/remote_update/updates/priinter_check/44147.txt >>sp.txt
cat /root/remote_update/updates/priinter_check/sp.txt | awk '{print $2,$3,$4,$5}' | xargs echo $(cat /root/remote_update/updates/priinter_check/printer_check_* | grep $1) >>/root/remote_update/updates/priinter_check/end.txt
rm -vf /root/remote_update/updates/priinter_check/sp.txt
#| awk '{print $2,$3}'