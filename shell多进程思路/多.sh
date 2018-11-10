#!/bin/bash
start=$(date "+%s")
for((i=1;i<=4;i++))
do 
{
    echo success && sleep 2
}&
done
wait
end=$(date "+%s")
echo "TIME : $[$end-$start]"