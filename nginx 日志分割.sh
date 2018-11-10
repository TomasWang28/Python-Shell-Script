所谓自动分割Nginx日志文件，就是指Rotate Nginx log files，即让Nginx每天（或每个星期，可自定义控制）生成一个日志文件，而不是将Nginx所有的运行日志都放置在一个文件中，这样每个日志文件都相对较小，定位问题也更容易。

实现自动分割Nginx日志的方法可以参考：http://www.cnblogs.com/wjoyxt/p/4757093.html

现在以一个Nginx实例为例，可以写一个脚本来实现自动分割Nginx日志

1、编写自动分割Nginx日志脚本

    #!/bin/bash
    #Rotate the Nginx logs to prevent a single logfile from consuming too much disk space. 
    LOGS_PATH=/usr/local/nginx/logs
    YESTERDAY=$(date -d "yesterday" +%Y-%m-%d)
    mv ${LOGS_PATH}/access.log ${LOGS_PATH}/access_${YESTERDAY}.log
    mv ${LOGS_PATH}/error.log ${LOGS_PATH}/error_${YESTERDAY}.log
    ## 向 Nginx 主进程发送 USR1 信号。USR1 信号是重新打开日志文件
    kill -USR1 $(cat /usr/local/nginx/logs/nginx.pid)

：wq保存，并命名为nginxLogRotate.sh，保存到目录/usr/local/nginx/logs

2、设置Linux定时任务

vi  /etc/crontab

在打开的文件底部添加如下内容

0 0 * * * root /usr/local/nginx/logs/nginxLogRotate.sh

：wq保存，表示配置一个定时任务，定时每天00:00以root身份执行脚本/usr/local/nginx/logs/nginxLogRotate.sh，实现定时自动分割Nginx日志（包括访问日志和错误日志）

至此，就实现了自动分割Nginx日志，Nginx每天都会生成一个新的日志文件。
