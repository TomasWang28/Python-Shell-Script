#!/bin/bash
#tomcat服务操作
# chkconfig: 35 68 78
export JAVA_HOME=/usr/local/java/jdk-10.0.1
BASEDIR="/usr/local/tomcat/bin"
#引入系统函数库
. /etc/rc.d/init.d/functions
#启动
start () {
  $BASEDIR/startup.sh
}
#关闭
stop () {
  $BASEDIR/shutdown.sh
}
#重启
restart () {
  stop
  start
}
#查看状态
tomcat_status () {
  status tomcat 
}
case "$1" in
  start)
      start
      ;;
  stop)
      stop
      ;;
  restart)
      restart
      ;;
  status)
      tomcat_status
      ;;
  *)
      echo "$EXE {start|stop|restart|status}"
esac
