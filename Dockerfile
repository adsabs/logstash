# Dockerizing Logstash:
# Dockerfile for building logstash on an ubuntu machine
# Logstash will listen for Logstash-forwarder on port:

# OS to use
FROM phusion/baseimage

# Provisioning
## Get the elasticsearch PGP key
RUN apt-key adv --keyserver hkp://pgp.mit.edu --recv D88E42B4

## Add Logstash to the apt-get source list
RUN echo 'deb http://packages.elasticsearch.org/logstash/1.4/debian stable main' > /etc/apt/sources.list.d/logstash.list

## Update the apt-get source list
RUN apt-get update

## Install dependencies
RUN apt-get install -y logstash git

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

# Define the entry point for docker<->logstash
## Logstash-forwarder
EXPOSE 6767

# How the docker container is interacted with
##
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
CMD ["/sbin/my_init"]
