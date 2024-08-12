#!/bin/bash -ex
echo "Run $0 $1 $2 $3"


acc=${3}
ver=${1}
vernew=${2}
current_date=$(date +"%Y-%m-%d")
### Run code 

grep ${acc} /home/support/update_checker/branch.list | grep "${ver}\|${vernew}">result.txt
sed -i 's/\r$//' ./result.txt
sed -i 's/ *lin *//g' ./result.txt
sed -i 's/ *unk *//g' ./result.txt
sed -i "/${vernew}/ s/$/ DONE/" ./result.txt 
sed -i "/${ver}/ s/$/ NOT_UPDATED/" ./result.txt 
sed -i "/$current_date/! s/$/ OFFLINE/" ./result.txt
sed -i "/$current_date/ s/$/ WAS_ONLINE_TODAY/" ./result.txt

if grep -q 'NOT_UPDATED' result.txt && grep -q 'DONE' result.txt; then
    echo "$(cat ./result.txt | head -n1 | awk '{print $2}') ЧАСТИЧНО" >greped.txt
    echo "$(grep NOT_UPDATED ./result.txt | awk '{print "-",$1,$3,$6,$7}')" >>greped.txt
elif grep -q 'NOT_UPDATED' result.txt && ! grep -q 'DONE' result.txt; then
    if grep -q 'OFFLINE' result.txt && ! grep -q 'ONLINE' result.txt; then
    echo "$(cat ./result.txt | head -n1 | awk '{print $2}') ОФФЛАЙН" >greped.txt
    echo "$(grep NOT_UPDATED ./result.txt | awk '{print "-",$1,$3,$6,$7}')" >>greped.txt
    else 
    echo "$(cat ./result.txt | head -n1 | awk '{print $2}') НЕ_ОБНОВЛЕН" >greped.txt
    echo "$(grep NOT_UPDATED ./result.txt | awk '{print "-",$1,$3,$6,$7}')" >>greped.txt
    fi
elif grep -q 'DONE' result.txt && ! grep -q 'NOT_UPDATED' result.txt; then
    echo "$(cat ./result.txt | head -n1 | awk '{print $2}') ОБНОВЛЕН" >greped.txt
else
    echo "$(cat ./result.txt | head -n1 | awk '{print $2}') я хз"
fi

cat ./greped.txt >>./final_result.txt
rm result.txt greped.txt