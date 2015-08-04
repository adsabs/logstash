#!/bin/bash
/opt/governor/governor -c /opt/governor/govern.conf && /opt/logstash/bin/logstash -l /var/log/logstash.log -f /etc/logstash/conf.d/logstash.conf
