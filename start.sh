#!/bin/sh

# morbo ./script/plan_monitor daemon -l http://*:8080
# morbo ./script/plan_monitor daemon -l http://*:3001
# morbo ./script/plan_monitor prefork -m production -w 10 -c 1 -l http://*:3001

# Hypnotoad
hypnotoad ./script/plan_monitor

# One of the most popular setups these days is Hypnotoad behind an Nginx reverse proxy, which even supports WebSockets in newer versions.

# Another good reverse proxy is Apache with mod_proxy, the configuration looks quite similar to the Nginx one above. And if you need WebSocket support, newer versions come with mod_proxy_wstunnel.

# <VirtualHost *:80>
# ServerName localhost
# <Proxy *>
# Require all granted
# </Proxy>
# ProxyRequests Off
# ProxyPreserveHost On
# ProxyPass /echo ws://localhost:8080/echo
# ProxyPass / http://localhost:8080/ keepalive=On
# ProxyPassReverse / http://localhost:8080/
# RequestHeader set X-Forwarded-Proto "http"
# </VirtualHost>

# release to CPAN
