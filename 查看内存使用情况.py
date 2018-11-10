#!/usr/bin/env python
# _*_ coding:utf-8 _*_
# 第一版

import re
with open("/proc/meminfo","r") as f:
    lines = f.readlines()
    first_line = lines[0]
    next_line = lines[6]

total_mem1= int(re.sub("\D", "",first_line))
used_mem1= int(re.sub("\D", "",next_line))

mem_usage1 = used_mem1 / total_mem1 * 100
print("当前内存使用率为: %.4f%%" % mem_usage1)


# 第二版

import os
total_mem2= int(os.popen("cat /proc/meminfo |awk 'NR==1{print$2}'").read())
used_mem2= int(os.popen("cat /proc/meminfo |awk 'NR==7{print$2}'").read())
mem_usage2= used_mem2 / total_mem2 * 100
print("当前内存使用率为: %.4f%%" % mem_usage2)


# 第三版
total_mem3= float(os.popen("free |awk 'NR==2{print$3/$2*100}'").read())
print("当前内存使用率为: %.4f%%" % total_mem3)

# 第四版
import psutil
print("当前内存使用率为: %.4f%%" % psutil.virtual_memory().percent)