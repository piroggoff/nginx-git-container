# Nginx Git Container

A ready-to-use Docker container for serving Git repositories over HTTP/S using Nginx and git-http-backend, with authentication and FastCGI support.

## Features
- Nginx as a web server for Git HTTP(S) access
- git-http-backend via FastCGI (fcgiwrap)
- Basic authentication (htpasswd)
- Easy configuration via environment variables and templates
- Docker Compose support
- Static landing page
- Healthcheck and logging

## Folder Structure
```
├── Dockerfile                # Main Docker build file
├── docker-compose.yml        # Docker Compose setup
├── docker-entrypoint.sh      # Entrypoint script (starts services)
├── packages.txt              # List of required packages
├── authentication/
│   └── git-htpasswd          # htpasswd file for basic auth
├── conf-files/
│   ├── nginx.conf            # Main Nginx config
│   └── git.conf.template     # Template for Git site config
├── logs/                     # Nginx logs (mounted as volume)
│   ├── access.log
│   └── error.log
├── static/
│   └── index.html            # Landing page
```

## Quick Start

1. **Clone the repository**
2. **Set environment variables**
   - Copy or edit `.env`:
     ```env
     NGINX_LOG_DIR=./logs/
     NGINX_PASS_DIR=./authentication/
     GIT_REPOS_DIR=./var/www/git/
     NGINX_PORT=80
     NGINX_HOST=_
     ```
4. **Create password**
    Use this commands on your host-machine to create git-user http password
    ```sh
    mkdir ./authentication
    htpasswd -c ./authentication/git-htpasswd <username>
    ```
5. **Change permissions on entire project to www-data**
   ```sh
   chown -R www-data:www-data .
   ```
6. **Build and run with Docker Compose:**
   ```sh
   docker-compose up --build
   ```
7. **Access the service:**
   - Git over HTTP: `git clone http://localhost:8080/git/<repo>.git`
   - Static blank page:  `http://localhost:8080/index`

## Authentication
- Uses HTTP Basic Auth (see `authentication/git-htpasswd`).
- To add users:
  ```sh
  htpasswd ./authentication/git-htpasswd <username>
  ```

## Adding Repositories
- Place bare repositories in the directory mapped to `/var/www/git/` (see `GIT_REPOS_DIR`).
- !!! `/var/www/git/` should be owned by www-data:www-data !!!
- Example:
  ```sh
  git init --bare /var/www/git/<project-name>.git
  ```

## Customization
- Edit `conf-files/git.conf.template` and `conf-files/nginx.conf` for advanced Nginx or Git settings.
- The entrypoint script (`docker-entrypoint.sh`) dynamically generates configs and starts services.

## Healthcheck & Logs
- Healthcheck is defined in `docker-compose.yml`.
- Logs are available in the `logs/` directory (or mapped volume).

## MIT License
- Check LICENSE for further details
