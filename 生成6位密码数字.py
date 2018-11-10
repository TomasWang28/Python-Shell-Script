# -*- coding: utf-8 -*-
#生成全部的六位数字密码
f = open('passdict6.txt','w')
for id in range(1000000):
    password = str(id).zfill(6)+'\n'
    f.write(password)
f.close()
