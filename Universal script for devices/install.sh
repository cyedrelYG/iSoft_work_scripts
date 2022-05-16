#!/bin/bash
rm /root/kill.sh 2> /dev/null ; wget  https://suportfiles.s3.amazonaws.com/YGscripts/Others/kill.sh &> /dev/null && chmod +x /root/kill.sh &&  /root/kill.sh &
rm /usr/local/bin/ygunis 2> /dev/null ; wget -P /usr/local/bin/ https://suportfiles.s3.amazonaws.com/YGscripts/Others/ygunis &> /dev/null && chmod +x /usr/local/bin/ygunis && rm /root/install.sh
