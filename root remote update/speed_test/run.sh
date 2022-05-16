#!/bin/bash
echo "Usage: $0 <keys> <script>"

vpn=$1
script=$2

cat ${vpn} | awk '{print $1}' | xargs -n1 echo ${script} | parallel 