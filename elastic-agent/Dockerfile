ARG ELK_VERSION

FROM amd64/ubuntu:20.04

RUN apt-get update && \
    apt-get -y install sudo && \
    apt-get -y install python3-pip python3

RUN pip3 install requests
RUN pip3 install PyYaml
RUN pip3 install elastic-agent-setup==0.0.11

ADD install.py /install.py
RUN chmod +x /install.py

CMD ["/install.py"]
ENTRYPOINT ["python3"]
