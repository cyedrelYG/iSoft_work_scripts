#!/bin/bash

ssh_args="-q -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no -o ConnectTimeout=5"
ssh_cmd="sshpass -p market1 ssh ${ssh_args}"
scp_cmd="sshpass -p market1 scp ${ssh_args}"
rs_cmd="sshpass -p market1 rsync"
ip=${1}

echo "1 -BACKUP"
echo "2 -RESTORE"
read Keypress
case "$Keypress" in
   [1-1]   ) 
    ${rs_cmd} -e "ssh -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no -o ConnectTimeout=5" -arvc --progress /home/support/ygscripts/scripts/loginbk.sh root@${ip}:/tmp/ 1>/dev/null
    ${ssh_cmd} root@${ip} "chmod +x /tmp/loginbk.sh && /tmp/loginbk.sh && cat /tmp/login.txt" 
    ${ssh_cmd} root@${ip} "cat /tmp/login.txt" &>/home/support/ygscripts/scripts/login.txt

    if [[ "$(cat /home/support/ygscripts/scripts/login.txt)" > 0 ]] ; then
    
        ${rs_cmd} -e "ssh -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no -o ConnectTimeout=5" -arvc --progress root@${ip}:/tmp/*backup* /home/support/ygscripts/backups/ && echo "BACKUP DONE:"
        ${ssh_cmd} root@${ip} "rm -f /tmp/loginbk.sh /tmp/*backup* && cat /tmp/login.txt && rm /tmp/login.txt && find /opt -name BACKSERVER -exec cat '{}'/mc3_key.txt \;"
        
    elif [[ "$(cat /home/support/ygscripts/scripts/login.txt)" < 0 ]] ; then
        echo "MC3 KEY:"
        ${ssh_cmd} root@${ip} "find /opt -name BACKSERVER -exec cat '{}'/mc3_key.txt \;"
        echo "ENTER DEVICE NUMBER:"
        read Keypress
        ${ssh_cmd} root@${ip} "mv /tmp/*backup* /tmp/${Keypress}backup`date +%H_%M_%d%b%Y`.tar.gz"
        ${rs_cmd} -e "ssh -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no -o ConnectTimeout=5" -arvc --progress root@${ip}:/tmp/*backup* /home/support/ygscripts/backups/ && echo "BACKUP DONE:"
        echo "$Keypress"
        ${ssh_cmd} root@${ip} "rm -f /tmp/loginbk.sh /tmp/*backup* /tmp/login.txt && find /opt -name BACKSERVER -exec cat '{}'/mc3_key.txt \;"
        
    fi
    rm -f /home/support/ygscripts/scripts/login.txt;;
  
   [2-2]   ) 

   echo "file: $(ls -lah /home/support/ygscripts/backups/ | grep $2 | awk '{print $9}')"
   echo "CONTINUE (Yes or No)?"
   read Keypress
   case "$Keypress" in
	  [y-y]   ) 
      ${rs_cmd} -e "ssh -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no -o ConnectTimeout=5" -arvc --progress  /home/support/ygscripts/backups/$2backup* /home/support/ygscripts/scripts/restore.sh root@${ip}:/tmp/
      ${ssh_cmd} root@${ip} "cd /tmp/ && tar -xf $2backup*.tar.gz && chmod +x restore.sh && /tmp/restore.sh"
      ${ssh_cmd} root@${ip} "rm -f /tmp/mc3_key.txt /tmp/spin.db /tmp/restore.sh /tmp/$2backup* ";;
    
     [n-n]   )
      echo "RESTORE CANCELED";;
   esac;;

esac