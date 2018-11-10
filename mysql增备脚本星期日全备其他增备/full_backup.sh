#!/bin/bash  

local_ip="$(/sbin/ifconfig ens33|grep 'inet'|awk 'NR==1{print $2}')" 

email='18222273318@163.com' 

user='root' 

passwd=${MYSQLPASSWD}

my_config='/etc/my.cnf' 

log=$(date +%Y-%m-%d-%H-%M).log  

str=$(date +%Y-%m-%d-%H-%M).tar.gz  

backup_dir='/backup/mysql/xtrabackup' 


source='18222273318@163.com'

target='18222273318@163.com'

title='xtrabackup information'  

MailUser='18222273318' 

MailPassword=${MYMAILPASSWD}

content1='Server_name:'$(hostname)' Server_ip:'$local_ip' '$(date +"%y-%m-%d %H:%M:%S")' mysql full backup Success!'

content2='Server_name:'$(hostname)' Server_ip:'$local_ip' '$(date +"%y-%m-%d %H:%M:%S")' mysql full backup Faild!'


echo "Start to backup at $(date +%Y-%m-%d-%H-%M)"

if [ ! -d "$backup_dir" ];then  

    mkdir -p $backup_dir  

fi  

#innobackupex --defaults-file=$my_config --user=$user --password=$passwd  --database=$database --stream=tar $backup_dir 2>$backup_dir/$log | gzip 1>$backup_dir/$str  

innobackupex --defaults-file=$my_config --user=$user --password=$passwd   $backup_dir  

if [ $? -eq 0 ];then  

    echo "Backup is finish! at $(date +%Y%m%d%H%M)"  

    echo "Server_name:$(hostname) Server_ip:$local_ip $(date +"%y-%m-%d %H:%M:%S") mysql full backup Success!"

    /usr/local/bin/sendEmail -f $source -t $target  -s smtp.163.com -u $title -xu $MailUser -xp $MailPassword -m $content1

    exit 0  

else  

    echo "Backup is Fail! at $(date +%Y%m%d%H%M)"  

    echo "Server_name:$(hostname) Server_ip:$local_ip $(date +"%y-%m-%d %H:%M:%S") mysql full backup Fail!"

    /usr/local/bin/sendEmail -f $source -t $target  -s smtp.163.com -u $title -xu $MailUser -xp $MailPassword -m $content2   

    exit 1  

fi  

echo "Backup Process Done"  