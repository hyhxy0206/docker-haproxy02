FROM alpine
LABEL MAINTAINER='xxx 1@2.com'

ENV version 2.4.9
ENV PATH /usr/local/harpoxy/sbin:$PATH

COPY files /tmp/
COPY entrypoint.sh /

RUN /tmp/install.sh

WORKDIR /usr/local/haproxy
EXPOSE 8189 80

ENTRYPOINT ["/entrypoint.sh"]

