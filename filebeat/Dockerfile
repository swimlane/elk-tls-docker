ARG ELK_VERSION

FROM docker.elastic.co/beats/filebeat:${ELK_VERSION}

CMD  filebeat export template > filebeat.template.json \
    cat filebeat.template.json | curl -u 'elastic:some_password' -XPUT 'https://elasticsearch:9200/_template/filebeat-7.12.0' -d @- --insecure