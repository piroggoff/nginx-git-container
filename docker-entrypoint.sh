#!/bin/bash
set -e

# Подргрузка переменных окружения для конфига git


# Запускаем fcgiwrap
spawn-fcgi -s /var/run/fcgiwrap.socket -u www-data -g www-data /usr/sbin/fcgiwrap &

# Ждем создания сокета
sleep 2

# Проверяем конфиг nginx
nginx -t

# Запускаем nginx
nginx -g "daemon off;"