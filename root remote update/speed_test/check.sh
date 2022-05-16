#!/bin/bash -ex
echo "Run $0 $1 $2"


ip=${1}

### Run code 
#${scp_cmd} /home/support/ygscripts/scripts/app.asar root@${ip}:/root
grep ${ip} /root/remote_update/updates/ttest/pamain.txt >>sp.txt
cat /root/remote_update/updates/ttest/sp.txt | awk '{print $2,$3}' | xargs echo $(cat /root/remote_update/updates/ttest/speed_test_* | grep $1) >>/root/remote_update/updates/ttest/end.txt
rm -vf /root/remote_update/updates/ttest/sp.txt
#| awk '{print $2,$3}'