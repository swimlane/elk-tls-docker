ARG ELK_VERSION

FROM docker.elastic.co/beats/metricbeat:${ELK_VERSION}

USER root
RUN yum-config-manager --save --setopt=base.skip_if_unavailable=true
RUN yum install ca-certificates
RUN update-ca-trust force-enable

USER metricbeat
CMD  update-ca-trust extract \
    metricbeat setup -e --index-management --dashboards -E "output.logstash.enabled=false" -E "output.elasticsearch.hosts=['https://elasticsearch:9200']" -E "output.elasticsearch.ssl.certificate_authorities=["/etc/pki/ca-trust/source/anchors/ca.crt"]" -E "output.elasticsearch.ssl.certificates=${CONFIG_DIR}/metricbeat.crt" -E "output.elasticsearch.ssl.key=${CONFIG_DIR}/metricbeat.key"
