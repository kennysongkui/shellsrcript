#!/bin/bash 

for i in `cat ip_list.txt`
do
ssh root@$i > /dev/null 2>&1 << eeooff
#ssh root@$i  << eeooff
wget -N http://10.128.161.98/ubuntu/long/pet.sh
bash -x pet.sh
exit
eeooff
done
