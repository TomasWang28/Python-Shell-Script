#!/bin/bash

#for((i=1;i<=4;i++))
#do 
# {
#    echo success && sleep 2
#}&
#done
start=$(date "+%s")
for i in {1..254}
do
    {
    . /etc/init.d/functions
    ip=192.168.33.$i
    ping -c 1 -w 1 >/dev/null 2>&1
    if [ $? = 0 ];then
    action "$ip" /bin/true
    else
    action "$ip" /bin/false
    fi
    }&
done
wait
end=$(date "+%s")
echo "TIME : $[$end-$start]"