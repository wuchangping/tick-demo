#!/bin/sh

rm -rf ./data
rm -rf ./meta
rm -rf ./wal

#docker rm `docker ps -a -q` -f

docker run -d -p 8083:8083 -p 8086:8086 -e ADMIN_USER="root" -e INFLUXDB_INIT_PWD="root" -e PRE_CREATE_DB="telegraf" -v $PWD:/var/lib/influxdb  --name influxdb influxdb:latest

docker run -d -p 8125:8125/udp  -v $(pwd)/telegraf.conf:/etc/telegraf/telegraf.conf -v /var/run:/var/run --name telegraf telegraf:latest

#docker run -d  -v $(pwd)/telegraf.conf:/etc/telegraf/telegraf.conf -v /var/run:/var/run --name telegraf telegraf:latest


#docker run -d -p 8083:8083 -p 8086:8086 -e ADMIN_USER="root" -e INFLUXDB_INIT_PWD="root" -e PRE_CREATE_DB="telegraf" --name influxdb influxdb:latest
#docker run -d -p 8083:8083 -p 8086:8086 -v $PWD:/var/lib/influxdb influxdb
#docker run -d -v /root/metrics/telegraf.conf:/etc/telegraf/telegraf.conf -v /var/run:/var/run --name telegraf telegraf:latest
#docker run --net=container:influxdb telegraf 
#docker run -p 8888:8888 chronograf
#docker run -d -p 8888:8888 -e INFLUXDB_NAME=telegraf --name chronograf  chronograf:latest



docker run -d -p 8888:8888 -e INFLUXDB_HOST=172.17.0.1  -e INFLUXDB_PORT=8086 -e INFLUXDB_NAME=telegraf -e INFLUXDB_USER=root -e INFLUXDB_PASS=root --name chronograf  chronograf:latest
