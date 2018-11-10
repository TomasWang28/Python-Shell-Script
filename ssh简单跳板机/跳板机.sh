#!/bin/bash
#监控文件是否改变
inotifywait -m ~/.ssh/id_rsa.pub -e modify && rm -rf ~/ssh_pub*
#确认id_rsa.pub是否存在,不存在就生成一个
[ ! -f ~/.ssh/id_rsa.pub ] && ssh-keygen -P "" -f ~/.ssh/id_rsa 

#定义函数
pub_push(){
        if [ ! -f ./ssh_pub$1.log ]
        then
            /usr/bin/expect <<-EOF
            spawn ssh-copy-id root@$1
            expect {
            "yes/no" { send "yes\r";exp_continue }
            "password:" { send "qqwer950428\r" }
            }
            expect eof
EOF
            echo "在date建立推送$1远程连接公钥。"|tee ./ssh_pub$1.log
        fi

}
#定义ip列表
ip_list[0]=2.2.2.3
ip_list[1]=2.2.2.4
ip_list[2]=2.2.2.5


#菜单打印
trap '' 1 2 3 9
while true;do
cat <<-END
欢迎使用Jumper-server,请选择你要操作的主机:
1.DB1-Master
2.DB2-Slave
3.Web1
4.Web2
5.exit
END
#让用户选择相应的操作
read -p "请输入你要操作的主机: " host
case $host in
    1)
    pub_push ${ip_list[0]}
    ssh root@${ip_list[0]}
    ;;
    2)
    pub_push ${ip_list[0]}
    ssh root@${ip_list[0]}
    ;;
    3)
    pub_push ${ip_list[0]}
    ssh root@${ip_list[0]}
    ;;
    5)
    exit
    ;;
    *)
    clear
    echo "输入错误,请重新输入..."
    ;;
esac
done

