# rpi-influxdb
Docker Container for Raspberry Pi with InfluxDB 1.1.1

# Using this Image
## InfluxDB container with persistent storage
```
# create /var/lib/influxdb as persistent volume storage
docker run -d -v /var/lib/influxdb --name influxdb-storage busybox:latest

# start influxdb
docker run \
    -d \
    -p 8083:8083 \
    -p 8086:8086 \
    --volumes-from influxdb-storage \
    jsdidierlaurent/rpi-influxdb
```

## InfluxDB in docker swarm with docker-compose
```
version: '3'

services:
  influx:
    image: jsdidierlaurent/rpi-influxdb
    volumes:
      - influx-db:/var/lib/influxdb
    deploy:
      replicas: 1
      placement:
        constraints:
          - node.role == manager

volumes:
  influx-db:
    driver: local
```