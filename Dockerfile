FROM resin/rpi-raspbian:jessie
LABEL maintainer "Jean-Sébastien Didierlaurent <js.didierlaurent@gmail.com>"

# Install build dependencies 
RUN apt-get update && apt-get install -y --no-install-recommends \
    apt-utils \
    ca-certificates \
    curl \
    wget \
    git && \
    apt-get clean && \ 
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

ENV INFLUXDB_VERSION=1.1.1 \
    INFLUXDB_CHECKSUM=ec2a4f6258182246b55a806841620759

# Download and untar, unzip influxdb
RUN wget -q https://dl.influxdata.com/influxdb/releases/influxdb-${INFLUXDB_VERSION}_linux_armhf.tar.gz && \
    echo "${INFLUXDB_CHECKSUM} influxdb-${INFLUXDB_VERSION}_linux_armhf.tar.gz" | md5sum -c - && \
    tar xvfz influxdb-${INFLUXDB_VERSION}_linux_armhf.tar.gz

# Copy untared files to system's folders
RUN cp -r /influxdb-${INFLUXDB_VERSION}-1/* /

# Add influxdb user
RUN useradd influxdb

# Set ownership, permissions and copy files
RUN chown influxdb:influxdb -R /etc/influxdb && \
    chown influxdb:influxdb -R /var/log/influxdb && \
    mkdir -p /var/lib/influxdb && \
    chown influxdb:influxdb -R /var/lib/influxdb && \
    cp /usr/lib/influxdb/scripts/init.sh /etc/init.d/influxdb && \
    chmod 755 /etc/init.d/influxdb && \
    cp /usr/lib/influxdb/scripts/influxdb.service /etc/systemd/system

EXPOSE 8086

VOLUME /var/lib/influxdb

CMD [ "influxd" ]