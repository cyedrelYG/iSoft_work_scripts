#!/bin/bash

 #loginbk.sh

 cd /opt/ && rm -r lima_* 2>/dev/null
 cd $(find /opt -name BACKSERVER)
 cat $(ls -atl | grep colle | grep "^-" | head -1 | awk '{print $9}') | grep -a version_and_terminal | awk '{print $2}' >>/tmp/login.txt
 #cat $(find /opt -name BACKSERVER)/collection.hwd2.print | grep -a version_and_terminal | awk '{print $2}' >>/tmp/login.txt
 cp $(find /opt -name BACKSERVER)/db/spin.db /tmp/ 
 cp $(find /opt -name BACKSERVER)/mc3_key.txt /tmp/
 cd /tmp/ 
 tar -czvf $(cat /tmp/login.txt)backup`date +c%H_%M_%d%b%Y`.tar.gz spin.db mc3_key.txt
 rm -v /tmp/mc3_key.txt /tmp/spin.db
 


# cat $(find /opt -name BACKSERVER)/$(ls -atl | grep colle | grep "^-" | head -1 | awk '{print $9}') | grep -a version_and_terminal | awk '{print $2}'