#!/bin/bash
set -e

# Запускаем fcgiwrap
spawn-fcgi -s /var/run/fcgiwrap.socket -u www-data -g www-data /usr/sbin/fcgiwrap &

# Ждем создания сокета
sleep 2

# Запускаем nginx
exec nginx -g "daemon off;"