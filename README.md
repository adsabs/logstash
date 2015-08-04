# logstash

Docker images for logstash

Configuration files are expected to sit on a Consul service, which is retrieved via the [Governor](https://github.com/adsabs/governor) package. The Consul service DNS and port are baked into the image for now as environment variables.

SSL certificates are based on DNS names and do not contain relevant IPs.

To create new certs use make_certs.sh

Basic usage:
  1. `docker build -t adsabs/logstash .`
  1. `docker run -d --hostname logstash --name logstash -p 6767:6767 --restart=always --log-driver syslog adsabs/logstash`
