#!/bin/sh
#source一下functions和network!
. /etc/rc.d/init.d/functions
. /etc/sysconfig/network
#检查网路是否联通。
[ "$NETWORKING" = "no" ] && exit 0
nginx="/usr/local/nginx/sbin/nginx"
#basename返回一个字符串参数的基本文件名称
prog=$(basename $nginx)
NGINX_CONF_FILE="/usr/local/nginx/conf/nginx.conf"
#判断有没有/etc/sysconfig/nginx
[ -f /etc/sysconfig/nginx ] && . /etc/sysconfig/nginx
#lockfile(不明白这是啥东东)
lockfile=/var/lock/subsys/nginx
make_dirs() {
   # 看了半天原来就是查找有没有nginx的用户然后创建一个
   user=`$nginx -V 2>&1 | grep "configure arguments:" | sed 's/[^*]*--user=\([^ ]*\).*/\1/g' -`
   if [ -z "`grep $user /etc/passwd`" ]; then
       useradd -M -s /bin/nologin $user
   fi
   #这行到的意思就是找.*-temp-path后的路径是否存在，没有的话创建一个。
   options=`$nginx -V 2>&1 | grep 'configure arguments:'`
   for opt in $options; do
       if [ `echo $opt | grep '.*-temp-path'` ]; then
           value=`echo $opt | cut -d "=" -f 2`
           if [ ! -d "$value" ]; then
               mkdir -p $value && chown -R $user $value
           fi
       fi
   done
}
start() {
    #没有执行权限则退出
    [ -x $nginx ] || exit 5
    #没有配置文件则退出
    [ -f $NGINX_CONF_FILE ] || exit 6
    #执行make_dirs的函数
    make_dirs
    #输出开始进程名字
    echo -n $"Starting $prog: "
    #指定nginx配置文件作为daemon进程
    daemon $nginx -c $NGINX_CONF_FILE
    #返回结果
    retval=$?
    echo
    #进程开始后创建$lockfile文件
    [ $retval -eq 0 ] && touch $lockfile
    return $retval
}
stop() {
    #屏幕输出结束进程
    echo -n $"Stopping $prog: "
    #优雅退出程序
    killproc $prog -QUIT
    #查看返回值
    retval=$?
    echo
    #进程开始后创建$lockfile文件
    [ $retval -eq 0 ] && rm -f $lockfile
    return $retval
}
restart() {
    #测试配置文件是否符合要求并返回退出值
    configtest || return $?
    #执行stop函数
    stop
    #等待退出后休息1秒
    sleep 1
    #执行start函数
    start
}
reload() {
    #测试配置文件是否符合要求并返回退出值
    configtest || return $?
    #不换行输出reload进程名
    echo -n $"Reloading $prog: "
    #如果想要更改配置而不需停止并重新启动服务，使用killproc -HUP。
    #在对配置文件作必要的更改后，发出该命令以动态更新服务配置。
    killproc $nginx -HUP
    #保存退出值
    RETVAL=$?
    echo
}
#强制重启= =这不就是重启嘛
force_reload() {
    restart
}
configtest() {
    #测试配置文件是否符合要求
  $nginx -t -c $NGINX_CONF_FILE
}
rh_status() {
    # status命令来自/etc/rc.d/init.d/functions这个脚本里的函数
    # 用来查看进程占用的pid的值
    status $prog
}
rh_status_q() {
    #不输出rh_status的值
    rh_status >/dev/null 2>&1
}
case "$1" in
    #开始进程不输出rh_status的值
    #正常退出值
    start)
        rh_status_q && exit 0
        $1
        ;;
    #停止进程
    stop)
        rh_status_q || exit 0
        $1
        ;;
    #重启或测试配置
    restart|configtest)
        $1
        ;;
    #重载配置
    reload)
        rh_status_q || exit 7
        $1
        ;;
    #同重启
    force-reload)
        force_reload
        ;;
    #查看进程状态
    status)
        rh_status
        ;;
    #执行rh_status_q或exit 0
    condrestart|try-restart)
        rh_status_q || exit 0
            ;;
    *)
    #输出配置参数
        echo $"Usage: $0 {start|stop|status|restart|condrestart|try-restart|reload|force-reload|configtest}"
        exit 2
esac