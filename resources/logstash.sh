#!/bin/bash
/opt/governor/governor -c /opt/governor/govern.conf && /opt/logstash-1.4.2/bin/logstash -l /var/log/logstash.log -f /etc/logstash/conf.d/logstash.conf
