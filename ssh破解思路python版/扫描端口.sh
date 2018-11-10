#!/bin/bash
start=$(date "+%s")
for i in {1..254}
do
    {
    ip=192.168.33.$i
    nc -v $ip 22 >/dev/null 2>&1
    if [ $? = 0 ];then
    echo $ip 22号端口可以连通! |tee -a ./ip_on.log
    #else
    #echo $ip 不可以ping通! |tee -a ./ip_off.log
    fi
    }& #每一次的for循环生成子进程,不必等待上一次执行结果,节省时间。
done
wait
end=$(date "+%s")
echo "TIME : $[$end-$start]"
#mail -s "ping的结果" root@localhost <<./ip_on.log ./ip_off.log
#mail -s "ping的结果" mail01@localhost <<./ip_on.log ./ip_off.log