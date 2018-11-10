scl  enable  rh-ruby23 bash

ssh root@redis1 '/usr/local/bin/redis-server /usr/local/redis-cluster/9001/redis.conf'
ssh root@redis2 '/usr/local/bin/redis-server /usr/local/redis-cluster/9002/redis.conf'
ssh root@redis3 '/usr/local/bin/redis-server /usr/local/redis-cluster/9003/redis.conf'
ssh root@redis1 '/usr/local/bin/redis-server /usr/local/redis-cluster/9004/redis.conf'
ssh root@redis2 '/usr/local/bin/redis-server /usr/local/redis-cluster/9005/redis.conf'
ssh root@redis3 '/usr/local/bin/redis-server /usr/local/redis-cluster/9006/redis.conf'


/usr/local/redis-cluster/bin/redis-trib.rb create --replicas 1 192.168.65.70:9001 192.168.65.71:9002 192.168.65.72:9003 192.168.65.70:9004 192.168.65.71:9005 192.168.65.72:9006