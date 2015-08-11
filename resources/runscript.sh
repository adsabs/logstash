#!/bin/bash

wget -qO - http://geolite.maxmind.com/download/geoip/database/GeoLiteCity.dat.gz | gzip -d > GeoLiteCity.dat && mv GeoLiteCity.dat /etc/logstash/conf.d/GeoLiteCity.dat
