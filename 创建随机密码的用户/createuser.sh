#!/bin/bash
for (( i = 1; i < 6; i++ )); do
    echo $[$RANDOM%9000+1000] | md5sum |tee -a passwd.log
    useradd user0$i
    tail -1 passwd.log |passwd --stdin user0$i
done