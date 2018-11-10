0 0 * * 0 /scripts/mysqlbak/full_backup.sh>> /var/log/mysqlbak/full_backup.log 2>&1  
0 0 * * 1-6 /scripts/mysqlbak/incremental_bakup.sh>>/scripts/mysqlbak/incremental_bakup.log 2>&1  
