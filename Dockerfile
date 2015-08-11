# Dockerizing Logstash:
# Dockerfile for building logstash on an ubuntu machine
# Logstash will listen for Logstash-forwarder on port:

# OS to use
FROM phusion/baseimage

# Provisioning
## Install dependencies
RUN apt-get update && apt-get install -y wget git openjdk-7-jre

## Install logstash, fixed at 1.4.2 - SSL problems for > 1.4.2
RUN wget -qO- https://download.elasticsearch.org/logstash/logstash/logstash-1.4.2.tar.gz | tar xvz -C /opt/ && mv /opt/logstash-1.4.2 /opt/logstash

## Install Governor binary
RUN mkdir -p /opt/governor
RUN git clone git://github.com/adsabs/governor.git /opt/governor/
RUN git -C /opt/governor pull && git -C /opt/governor reset --hard fb9273bb20fa4748d05901ad075de5b137246d2e
ENV CONSUL_HOST consul.adsabs
ENV CONSUL_PORT 8500

# Configuration files
## logstash config
RUN mkdir -p /etc/logstash/conf.d/
COPY resources/logstash-forwarder.key /etc/pki/tls/private/logstash-forwarder/
COPY resources/logstash-forwarder.crt /etc/pki/tls/certs/logstash-forwarder/
COPY resources/govern.conf /opt/governor/
COPY resources/logstash.sh /etc/service/logstash/run

# Add GeoLiteDb cronjob
## 
COPY resources/runscript.sh /runscript.sh
RUN /runscript.sh
COPY resources/cronjob.sh /cronjob.sh
RUN crontab /cronjob.sh

# Define the entry point for docker<->logstash
## Logstash-forwarder
EXPOSE 6767

# How the docker container is interacted with
##
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
CMD ["/sbin/my_init"]
