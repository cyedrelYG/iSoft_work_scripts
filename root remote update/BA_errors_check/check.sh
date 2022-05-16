#!/bin/bash -ex
echo "Run $0 $1 $2"


ip=${1}

### Run code 
#${scp_cmd} /home/support/ygscripts/scripts/app.asar root@${ip}:/root
grep ${ip} /root/remote_update/updates/ba_errors/pwr_all.txt >>sp.txt
cat /root/remote_update/updates/ba_errors/sp.txt | awk '{print $1,$2,$3,$4}' | xargs echo $(cat /root/remote_update/updates/ba_errors/ba_errors_check_* | grep $1) >>/root/remote_update/updates/ba_errors/end.txt
rm -vf /root/remote_update/updates/ba_errors/sp.txt
#| awk '{print $2,$3}'