#!/bin/bash

if [ $# -ne 3 ] ; then
    echo "Usage: $0 <acclist> <ver> <vernew>"
    echo "Example: $0 ./acc.txt 10607 10629"
    exit 1
fi

acclist=$1
script="/home/support/update_checker/script.sh"
ver=$2
vernew=$3

echo "---------------------------------------------------------------------" >>./final_result.txt
echo "Счета_с_${ver}_версии_на_${vernew}_версию" >>./final_result.txt
echo "---------------------------------------------------------------------" >>./final_result.txt

cat ${acclist} | awk '{print $1}' | xargs -n1 echo "${script} ${ver} ${vernew}" | parallel