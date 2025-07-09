# 1) Базовый образ: берем последний Debian/Ubuntu
FROM debian:stable-slim

# 2) Обновляем и устанавливаем нужные пакеты:
#    - nginx          — сам веб‑сервер
#    - git             — если нужен git-http-backend
#    - fcgiwrap        — обработчик FastCGI для Git HTTP
#    - spawn-fcgi     — утилита для запуска fcgiwrap
#    - ca-certificates — для HTTPS запросов (при необходимости)
ENV DEBIAN_FRONTEND=noninteractive
COPY packages.txt /tmp/packages.txt

RUN apt-get update && \
    apt-get install -y $(cat /tmp/packages.txt) && \
    apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/packages.txt

# 3) Копируем все конфиги Nginx из папки sites-available
COPY conf-files/sites-enabled/*.conf /etc/nginx/sites-enabled/
COPY conf-files/nginx.conf /etc/nginx/
COPY git/ /var/www/git/
COPY static/ /var/www/static/

# 4) Включаем все сайты и отключаем дефолтный
RUN rm -f /etc/nginx/sites-enabled/default 2>/dev/null

# 5) Создаём директорию для bare‑репозиториев (точка монтирования) 
# При монтировании volume в Windows права будут определяться как root,
# поэтому в данном случае будет применено копирование как conf файлов, так и git-репозиториев.
RUN mkdir -p /var/www/git && \
    mkdir -p /var/run && \
    chown -R www-data:www-data /var/www/git && \
    chown -R www-data:www-data /var/run
# 6) Копируем и настраиваем запуск fcgiwrap через spawn-fcgi
#    Запуск будет из entrypoint’а
COPY docker-entrypoint.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/docker-entrypoint.sh

# 7) Открываем порт 80
EXPOSE 80

# 8) Точка входа
ENTRYPOINT ["/usr/local/bin/docker-entrypoint.sh"]
