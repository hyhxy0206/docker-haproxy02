#!/bin/sh

sed -i 's/dl-cdn.alpinelinux.org/mirrors.aliyun.com/' /etc/apk/repositories
apk update

adduser -S -H -s /sbin/nologin haproxy
addgroup haproxy

apk add --no-cache -U make gcc pcre-dev bzip2-dev openssl-dev elogind-dev libc-dev dahdi-tools dahdi-tools-dev libexecinfo libexecinfo-dev ncurses-dev zlib-dev zlib


 cd /tmp/
 tar xf haproxy-${version}.tar.gz
 cd haproxy-${version}
 make clean && \
 make TARGET=linux-musli \
 USE_OPENSSL=1 \
 USE_ZLIB=1 \
 USE_PCRE=1 && \
 make install PREFIX=/usr/local/haproxy && \
cp haproxy /usr/sbin/

echo 'net.ipv4.ip_nonlocal_bind = 1' >>  /etc/sysctl.conf
echo 'net.ipv4.ip_forward = 1' >> /etc/sysctl.conf

mkdir -p /usr/local/haproxy/conf
apk del gcc make 
rm -rf /tmp/* /var/cache/*

