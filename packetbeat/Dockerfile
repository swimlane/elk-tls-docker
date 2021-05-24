ARG ELK_VERSION

FROM docker.elastic.co/beats/packetbeat:${ELK_VERSION}

USER root
RUN yum-config-manager --save --setopt=base.skip_if_unavailable=true
RUN yum install ca-certificates
RUN update-ca-trust force-enable

USER packetbeat
CMD  update-ca-trust extract \
    packetbeat setup -e --index-management --dashboards -E "output.logstash.enabled=false" -E "output.elasticsearch.hosts=['https://elasticsearch:9200']" -E "output.elasticsearch.ssl.certificate_authorities=["${CONFIG_DIR}/ca.crt"]" -E "output.elasticsearch.ssl.certificates=${CONFIG_DIR}/packetbeat.crt" -E "output.elasticsearch.ssl.key=${CONFIG_DIR}/packetbeat.key"
