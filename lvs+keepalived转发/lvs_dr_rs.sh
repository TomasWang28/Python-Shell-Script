#! /bin/bash

vip=192.168.65.38

ifconfig lo:0 $vip broadcast $vip netmask 255.255.255.255 up

route add -host $vip lo:0

echo "1" >/proc/sys/net/ipv4/conf/lo/arp_ignore

echo "2" >/proc/sys/net/ipv4/conf/lo/arp_announce

echo "1" >/proc/sys/net/ipv4/conf/all/arp_ignore

echo "2" >/proc/sys/net/ipv4/conf/all/arp_announce