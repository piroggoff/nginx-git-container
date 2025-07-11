#!/bin/bash
set -e

# Load environment variables for git config
envsubst '$NGINX_PORT $NGINX_HOST' < /etc/nginx/templates/git.conf.template > /etc/nginx/sites-enabled/git.conf

# Start fcgiwrap
spawn-fcgi -s /var/run/fcgiwrap.socket -u www-data -g www-data /usr/sbin/fcgiwrap &

# Wait for socket creation
sleep 2

# Test nginx config
nginx -t

# Start nginx
nginx -g "daemon off;"