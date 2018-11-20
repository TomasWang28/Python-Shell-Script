#!/usr/bin/bash

show_netstat(){
    HOSTLISTS=$(grep "redis" /etc/hosts|awk '{print $2}')
    underline="-------------------------SPLIT-------------------------"
    for host in $HOSTLISTS
        do 
        ssh $host "/usr/bin/netstat -tnlp|grep -E '6379|26379'";/usr/bin/echo $underline
    done
}

start_redis(){
    HOSTLISTS=$(grep "redis" /etc/hosts|awk '{print $2}')
    for host in $HOSTLISTS
        do 
        ssh $host "/opt/redis-4.0.1/bin/redis-server /opt/redis-4.0.1/bin/redis.conf";
        if [ $? == 0 ]
            then
            echo "${host}redis服务启动成功！"
        fi
        done
}

start_sentinel(){
    HOSTLISTS=$(grep "redis" /etc/hosts|awk '{print $2}')
    for host in $HOSTLISTS
        do 
        ssh $host "/opt/redis-4.0.1/bin/redis-sentinel /opt/redis-4.0.1/bin/sentinel.conf";
        if [ $? == 0 ]
            then
            echo "${host}redis-sentinel启动成功！"
        fi
        done
}


case "$1" in
show_netstat)
    show_netstat
;;
start_redis)
    start_redis
;;
start_sentinel)
    start_sentinel
;;
*)
esac
