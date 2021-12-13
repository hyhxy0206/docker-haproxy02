#!/bin/sh

cat > /usr/local/haproxy/conf/haproxy.cfg <<EOF
#--------------全局配置----------------
global
    log 127.0.0.1 local0  info
    #log loghost local0 info
    maxconn 20480
#chroot /usr/local/haproxy
    pidfile /var/run/haproxy.pid
    #maxconn 4000
    user haproxy
    group haproxy
    daemon
#---------------------------------------------------------------------
#common defaults that all the 'listen' and 'backend' sections will
#use if not designated in their block
#---------------------------------------------------------------------
defaults
    mode http
    log global
    option dontlognull
    option httpclose
    option httplog
    #option forwardfor
    option redispatch
    balance roundrobin
    timeout connect 10s
    timeout client 10s
    timeout server 10s
    timeout check 10s
    maxconn 60000
    retries 3
#--------------统计页面配置------------------
listen admin_stats
    bind 0.0.0.0:8189
    stats enable
    mode http
    log global
    stats uri /haproxy_stats
    stats realm Haproxy\ Statistics
    stats auth admin:admin
    #stats hide-version
    stats admin if TRUE
    stats refresh 30s
#---------------web设置-----------------------
listen webcluster
    bind 0.0.0.0:80
    mode http
    #option httpchk GET /index.html
    log global
    maxconn 3000
    balance roundrobin
    cookie SESSION_COOKIE insert indirect nocache
EOF
count=1
for rs_ip in $(cat /tmp/RSs.txt);do
cat >> /usr/local/haproxy/conf/haproxy.cfg <<EOF
    server web$count $rs_ip:80 check inter 2000 fall 5
EOF
let count++
done

haproxy -f /usr/local/haproxy/conf/haproxy.cfg -db
