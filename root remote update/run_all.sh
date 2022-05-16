#!/bin/bash

if [ $# -ne 2 ] ; then
    echo "Usage: $0 <keys> <script>"
    exit 1
fi

keys=$1
script=$2

echo "Start vpn"
cat ${keys}  |
    awk '{print$1}' |
    sed 's/^/"http:\/\/info.mc3.status200.io:8899\/set?key=/' |
    sed 's/$/\&value=vpn"/' |
    xargs -n 50 curl

echo "Wait 2m"
sleep 120

cat ${keys} |
    awk '{print "select ip, concat(mc3_key, \"key\") from mc3_key where mc3_key = \""$1"\";"}' |
    mysql limavpn  |
    grep -v ip |
    xargs -n2 echo ${script} |
    parallel -j 32
