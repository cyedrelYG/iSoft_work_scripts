#!/bin/bash

#restore
file=$(find /opt -name BACKSERVER)

if [ -f $file/mc3_key.txt ] ; then 
echo "Device is alredy registred as:"
echo "$(cat $file/mc3_key.txt)"
else
mkdir $file/db
cp /tmp/mc3_key.txt $file 
cp /tmp/spin.db $file/db/ 
killall -9 client.x86_64 || killall -9 login.x86_64
echo "Device restored:"
echo "$(cat $file/mc3_key.txt)"
fi 

