# 1) Base image: use the latest Debian/Ubuntu
FROM debian:stable-slim

# 2) Update and install required packages:

ENV DEBIAN_FRONTEND=noninteractive
COPY packages.txt /tmp/packages.txt

RUN apt-get update && \
    apt-get install -y $(cat /tmp/packages.txt) && \
    apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/packages.txt

# 3) Copy Nginx configs and static
COPY conf-files/nginx.conf /etc/nginx/
COPY conf-files/git.conf.template /etc/nginx/templates/
COPY static/ /var/www/static/

# 4) Create directory for bare repositories (mount point)
#    On Windows, volume permissions default to root,
#    On Linux, it is neccesary to make connected volumes chown www-data:www-data
RUN rm -f /etc/nginx/sites-enabled/default && \
    mkdir -p /var/www/git && \
    mkdir -p /var/run && \
    chown -R www-data:www-data /var/www/ && \
    chown -R www-data:www-data /var/run

# 5) Copy and set up fcgiwrap launch via spawn-fcgi
#    Will be started from entrypoint
COPY docker-entrypoint.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/docker-entrypoint.sh

# 6) Expose port 80
EXPOSE 80

# 7) Entrypoint
ENTRYPOINT ["/usr/local/bin/docker-entrypoint.sh"]
