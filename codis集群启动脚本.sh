#!/bin/bash
CODIS_CONF="/usr/local/redis-data/data/config"
CODIS_LOG="/usr/local/redis-data/data/logs"


start(){

for each in zookeeper-node1 zookeeper-node2 zookeeper-node3
do
    {
    ssh $each "/usr/local/codis/codis-admin --remove-lock --product=codis-test1 --zookeeper=192.168.65.129:2181"
    ssh $each "/usr/local/codis/codis-server $CODIS_CONF/redis_6379.conf" 
    ssh $each "/usr/local/codis/codis-server $CODIS_CONF/redis_6380.conf" 
    ssh $each "/usr/local/zookeeper/bin/zkServer.sh start" 
    ssh $each "/usr/local/codis/redis-sentinel $CODIS_CONF/sentinel.conf" 
    }&
done

for each in zookeeper-node1 zookeeper-node3
do
    {
    ssh $each "/usr/local/codis/codis-proxy --ncpu=2 --config=$CODIS_CONF/proxy.conf --log=$CODIS_LOG/proxy.log &"
    }&
done


for each in zookeeper-node2
do
    { 
    ssh $each "/usr/local/codis/codis-dashboard --ncpu=1 --config=$CODIS_CONF/dashboard.conf --log=$CODIS_LOG/codis_dashboard.log --log-level=WARN &" 
    ssh $each "/usr/local/codis/codis-fe --ncpu=1 --log=$CODIS_LOG/fe.log --log-level=WARN --dashboard-list=$CODIS_CONF/codis.json --listen=0.0.0.0:8090 &" 
    }&
done        

}

status(){
    for each in zookeeper-node1 zookeeper-node2 zookeeper-node3
    do
        ssh $each "echo -----------------------split:$each----------------------- "
        ssh $each "netstat -tnlp|grep -E ':6379|:6380|:26379|:11080|:19000|:18080|:8090'"
    done
}

stop(){
   for each in zookeeper-node1 zookeeper-node2 zookeeper-node3
do
    {
    ssh $each "/usr/local/zookeeper/bin/zkServer.sh stop" &>/dev/null 
    ssh $each "pkill -15 codis-server" 
    ssh $each "pkill -15 redis-sentinel" 
    ssh $each "pkill -15 codis-proxy" 
    ssh $each "pkill -15 codis-dashboard" 
    ssh $each "pkill -15 codis-fe" 
    }&   
done 
}

case $1 in
    START|start)
    start
    ;;
    STOP|stop)
    stop
    ;;
    STATUS|status)
    status
    ;;
    *)
    echo "USE START/start/STATUS/status/STOP/stop"
esac