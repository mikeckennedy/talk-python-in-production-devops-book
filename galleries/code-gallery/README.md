# Code Gallery

This gallery contains all the code blocks from the book organized by chapter. Each code block is listed with its language and can be easily copied and used. Note that the first few chapters don't have any code and thus do not appear here.

## Table of Contents

* [Chapter 5: Running on Rust](#chapter-5-running-on-rust)
* [Chapter 6: The Unexpected Benefits of Self-Hosting](#chapter-6-the-unexpected-benefits-of-self-hosting)
* [Chapter 7: Visualizing Servers and Other Tools](#chapter-7-visualizing-servers-and-other-tools)
* [Chapter 8: Docker Performance Tips](#chapter-8-docker-performance-tips)
* [Chapter 9: NGINX, Containers, and Let's Encrypt](#chapter-9-nginx-containers-and-lets-encrypt)
* [Chapter 10: CDNs](#chapter-10-cdns)
* [Chapter 11: Example Server Setup](#chapter-11-example-server-setup)
* [Chapter 12: Static Sites and Hugo](#chapter-12-static-sites-and-hugo)
* [Chapter 13: Picking a Python Web Framework](#chapter-13-picking-a-python-web-framework)

## Chapter 5: Running on Rust

### Code block 05-01 - Linux Shell

```bash
# Flask when executing app.run()

WARNING: This is a development server. Do not use it in a production deployment. Use a production WSGI server instead.
```

### Code block 05-02 - Linux Shell

```bash
# Command to run talkpython.fm in a production app server.

granian talkpython.quart_app:app \ 
       --host 0.0.0.0 --port 8801 \ 
       --interface asgi \ 
       --no-ws 
       --workers 3 \
       --runtime-mode st \
       --loop uvloop \
       --workers-lifetime 43200 --respawn-interval 30 \
       --process-name "granian-talkpython" \
       --log --log-level info
```

### Code block 05-03 - Docker

```dockerfile
# Command to run talkpython.fm in 
# a Docker container.

ENTRYPOINT [  \
  "/venv/bin/granian",\
  "talkpython.quart_app:app", \
  "--host","0.0.0.0", \
  "--port","8801", \
  "--interface","asgi", \
  "--no-ws", \
  "--workers","3", \
  "--threading-mode", "workers", \
  "--loop","uvloop", \
  "--log-level","info",\
  "--log", \
  "--workers-lifetime", "10800", \
  "--respawn-interval", "30", \
  "--process-name", "granian-talkpython" \
]
```


## Chapter 6: The Unexpected Benefits of Self-Hosting

### Code block 06-01 - Linux Shell

```bash
# Create a persistent volume outside lifetime of containers.
docker volume create umami-volume
```

### Code block 06-02 - Docker Compose

```yaml
# Modified compose.yaml file to use external data volume.

umami_db:
    # ...
    volumes:
      - umami-volume:/var/lib/postgresql/data

volumes:
  umami-volume:
    name: umami-volume
    external: true
```

### Code block 06-03 - Linux Shell

```bash
# In the Umami folder with the docker-compose.yml file:
docker compose up
```

### Code block 06-04 - Docker Compose

```yaml
# Compose file defining Uptime Kuma config.

services:
  uptime-kuma:
    image: louislam/uptime-kuma:1
    volumes:
      - ./data:/app/data
    ports:
      - 3001:3001
    restart: unless-stopped
```

### Code block 06-05 - Linux Shell

```bash
# Recommended external data for Uptime Kuma.
docker volume create kuma-volume
```

### Code block 06-06 - Docker Compose

```yaml
# Uptime Kuma Docker Compose config with external volume.

services:
  uptime-kuma:
    image: louislam/uptime-kuma:1
    # Add this to make your life easier too
    container_name: uptime-kuma 
    volumes:
      - kuma-volume:/app/data
    ports:
      - 3001:3001
    restart: unless-stopped

volumes:
  kuma-volume:
    external: true
```


## Chapter 7: Visualizing Servers and Other Tools

### Code block 07-01 - Linux Shell

```bash
apt install btop
```

### Code block 07-02 - Linux Shell

```bash
# Download and install Glances utility using Docker isolation.

docker pull nicolargo/glances:latest-full

docker run --rm -e TZ="${TZ}" -v /var/run/docker.sock:/var/run/docker.sock:ro -v /run/user/1000/podman/podman.sock:/run/user/1000/podman/podman.sock:ro --pid host --network host -it nicolargo/glances:latest-full
```

### Code block 07-03 - Linux Shell

```bash
# Alias for Glances to make it super easy to run.

# Add these three aliases in your .zshrc / .bashrc 
# file on the host server:

alias update_glances="docker pull nicolargo/glances:latest-full"

alias run_glances="docker run --rm -e TZ="${TZ}" -v /var/run/docker.sock:/var/run/docker.sock:ro -v /run/user/1000/podman/podman.sock:/run/user/1000/podman/podman.sock:ro --pid host --network host -it nicolargo/glances:latest-full"

alias glances="update_glances && run_glances"
```

### Code block 07-04 - Linux Shell

```bash
# Installing Docker Cluster Monitor via uv.

uv tool install dockerclustermon
```

### Code block 07-05 - Linux Shell

```bash
# Installing Docker Cluster Monitor via uv.

pipx install dockerclustermon
```

### Code block 07-06 - Linux Shell

```bash
# Monitor Docker cluster at server SERVERNAME

dockerstatus SERVERNAME
```

### Code block 07-07 - Linux Shell

```bash
# Log into NGINX's running Docker container (starting Bash).

docker exec -it nginx bash
```

### Code block 07-08 - Linux Shell

```bash
# Log into running app server in Docker container (starting OhMyZSH).

docker exec -it talkpython zsh
(venv) ➜  /app
```

### Code block 07-09 - Linux Shell

```bash
# .zshrc file: Set up OhMyZSH and 
# activate Python's venv on login.

export ZSH="/root/.oh-my-zsh"
ZSH_THEME="robbyrussell"
plugins=()
source $ZSH/oh-my-zsh.sh

source /venv/bin/activate
```

### Code block 07-10 - Docker

```dockerfile
# Docker command to install ZSH and set up OhMyZSH.

# Uses "robbyrussell" theme (original Oh My Zsh theme), with no plugins
RUN sh -c "$(wget -O- https://github.com/deluan/zsh-in-docker/releases/download/v1.2.0/zsh-in-docker.sh)" -- -t robbyrussell
```

### Code block 07-11 - Linux Shell

```bash
# Basic tail command, show prior 100 and follow new entries.
tail -n 100 -f /logs/app.log
```

### Code block 07-12 - Docker Compose

```yaml
# Docker Compose config to make logs persistent on host and "tailable."

services:
  talkpython:
    image: talkpython
    # ...
    volumes:
      # Env variable TALKPYTHON_LOGS maps to a local folder.
      - "${TALKPYTHON_LOGS}:/logs"
```

### Code block 07-13 - Linux Shell

```bash
# Tail the log and follow it for Talk Python's app server.

tail -n 500 -f /cluster/logs/talkpython/request-log.log
```


## Chapter 8: Docker Performance Tips

### Code block 08-01 - Docker

```dockerfile
# Simple Dockerfile example to illustrate layers in Docker build.

FROM ubuntu:latest

RUN mkdir /app
COPY ./files /app

RUN apt update
RUN apt upgrade -y

ENTRYPOINT [ ... your startup command here ... ]
```

### Code block 08-02 - Docker

```dockerfile
# Reorder independent commands for faster rebuilds.

FROM ubuntu:latest

# Move ahead
RUN apt update
RUN apt upgrade -y

# Move later
RUN mkdir /app
COPY ./files /app

ENTRYPOINT [ ... your startup command here ... ]
```

### Code block 08-03 - Docker

```dockerfile
# A docker file for a basic Flask application.

FROM ubuntu:latest

# Move ahead
RUN apt update
RUN apt upgrade -y

# Magically install Python
# We'll talk about how to do this next.

# ############ FOCUS HERE ##############
RUN mkdir /app
WORKDIR "/app"

COPY ./src/ /app
RUN python -m venv /app/venv
RUN /app/venv/bin/pip install -r requirements.txt
# ######### UNTIL HERE #################

ENTRYPOINT [ ... your startup command here ... ]
```

### Code block 08-04 - Docker

```dockerfile
# Splitting the requirements file copy and the source files copy.
...

# ############ FOCUS HERE ##############
# Break out the copying of the requirements file and 
# the install of the dependencies:
COPY ./src/requirements.txt /app
RUN python -m venv /app/venv
RUN /app/venv/bin/pip install -r requirements.txt

COPY ./src/ /app
# ######### UNTIL HERE #################
...
```

### Code block 08-05 - Docker

```dockerfile
# Cache the venv by moving it before copied files.
...

# ############ FOCUS HERE ##############
# Move this ahead of any of our file changes.
RUN python -m venv /app/venv

COPY ./src/requirements.txt /app
RUN /app/venv/bin/pip install -r requirements.txt

COPY ./src/ /app
# ######### UNTIL HERE #################
...
```

### Code block 08-06 - Docker

```dockerfile
# Add uv tooling and use it to install requirements.

FROM ubuntu:latest

# ...

# Set some paths making it easier to run uv and python
ENV PATH=/venv/bin:$PATH
ENV PATH="/root/.local/bin/:$PATH"

# ############ FOCUS HERE ##############

# Install uv
RUN curl -LsSf https://astral.sh/uv/install.sh | sh 

# Create the venv and download Python 3.13
RUN uv venv --python 3.13 /app/venv

COPY ./src/requirements.txt /app
# Use uv now rather than pip
RUN uv pip install -r requirements.txt

# ######### UNTIL HERE #################

COPY ./src/ /app

# ...
```

### Code block 08-07 - Docker

```dockerfile
# mount command persists uv cache across builds (even rebuilds).

FROM ubuntu:latest

# ...

# Use uv now rather than pip
RUN --mount=type=cache,target=/root/.cache uv pip install -r requirements.txt

# ...
```

### Code block 08-08 - Docker

```dockerfile
# Going faster by ignoring files.
# .dockerignore - located next to Dockerfile

.git
**/.git
**/.github
**/.fleet
**/.vscode
**/.idea
**/src/logos # Suppose in the repo but not part of the app
**/src/docs # Same as logos
# Don't let dev requirements cause rebuilds.
**/requirements-development.txt
```


## Chapter 9: NGINX, Containers, and Let's Encrypt

### Code block 09-01 - NGINX

```nginx
# A very basic talkpython.fm NGINX file.

server {
    listen 80;
    server_name talkpython.fm;
    charset utf-8;

    location /static {
        gzip on;
        gzip_comp_level 6;
        gzip_min_length 1100;
        gzip_buffers 16 256k;
        gzip_proxied any;
        gzip_types
            text/plain
            text/xml
            text/css
            application/javascript
            application/json
            application/xml
            application/rss+xml;

        alias /webapp/static/talkpython/talkpython.fm;
        expires 365d;
    }

    location /.well-known/acme-challenge/ { root /var/www/certbot; }

    location / { try_files $uri @talk_python_app; }

    location @talk_python_app {
        include uwsgi_params;
        proxy_pass http://180.0.0.101:7195;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-Protocol $scheme;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Host $host;
    }
}
```

### Code block 09-02 - Docker Compose

```yaml
# Docker Compose file for connecting NGINX and CertBot.

services:

  nginx:
    image: nginx:latest
    container_name: nginx
    restart: unless-stopped
    ports:
      - "80:80"
      - "443:443"
    volumes:
      - "${NGINX_SITES_ENABLED}:/etc/NGINX/sites-enabled"
      - "${CERTBOT_WWW}:/var/www/certbot/"
      - "${NGINX_LETS_ENCRYPT_ETC}:/etc/letsencrypt/"
    networks:
      cluster-net:
        ipv4_address: 180.0.0.55

  certbot:
      image: certbot/certbot:latest
      container_name: certbot
      volumes:
        - "${CERTBOT_WWW}:/var/www/certbot/"
        - "${NGINX_LETS_ENCRYPT_ETC}:/etc/letsencrypt/:rw"
      networks:
        webapp-network:

# Created one time on host machine setup via:
# docker network create -d bridge webapp --subnet=180.0.0.0/16
networks:
  webapp-network:
    name: webapp
    external: true
```

### Code block 09-03 - Linux Shell

```bash
# Command to run certbot within Docker Compose config.

docker compose run --rm certbot certonly --webroot --webroot-path /var/www/certbot/ -d talkpython.fm
```

### Code block 09-04 - NGINX

```nginx
# Updated NGINX config with newly created certificate files.

server {
    server_name talkpython.fm;
    charset utf-8;

    # Add this section to listen on HTTPS port, enable HTTP2, and use the certs.
    listen 443 ssl;
    http2 on;
    ssl_certificate /etc/letsencrypt/live/talkpython.fm/fullchain.pem;
    ssl_certificate_key /etc/letsencrypt/live/talkpython.fm/privkey.pem;
    include /etc/letsencrypt/options-ssl-NGINX.conf;
    ssl_dhparam /etc/letsencrypt/ssl-dhparams.pem;

    location /static {
        gzip on;
        gzip_comp_level 6;
        gzip_min_length 1100;
        gzip_buffers 16 256k;
        gzip_proxied any;
        gzip_types
            text/plain
            text/xml
            text/css
            application/javascript
            application/json
            application/xml
            application/rss+xml;

        alias /webapp/static/talkpython/talkpython.fm;
        expires 365d;
    }

    location /.well-known/acme-challenge/ { root /var/www/certbot; }

    location / {
        try_files $uri @talk_python_app;
    }

    location @talk_python_app {
        include uwsgi_params;
        proxy_pass http://180.0.0.101:7195;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-Protocol $scheme;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Host $host;
    }
}

# Add an automatic redirect from HTTP (80) to HTTPS.
server {
    if ($host = talkpython.fm) {
        return 301 https://$host$request_uri;
    }

    listen 80;
    server_name talkpython.fm;
    return 404;
}
```

### Code block 09-05 - Linux Shell

```bash
# Command to run CertBot to renew all domains.

docker compose run --rm certbot renew --webroot --webroot-path /var/www/certbot/
```

### Code block 09-06 - Linux Shell

```bash
# Output from renewing all domains.

Saving debug log to /var/log/letsencrypt/letsencrypt.log

- - - - - - - - - - - - - - - - - - - - - - - - - - - - 
Processing /etc/letsencrypt/renewal/talkpython.fm.conf
- - - - - - - - - - - - - - - - - - - - - - - - - - - - 
Certificate not yet due for renewal

The following certificates are not due for renewal yet:
  /etc/letsencrypt/live/talkpython.fm/fullchain.pem expires on 2025-01-31 (skipped)
  # ... many more redacted, also not renewed. :)
```


## Chapter 10: CDNs

### Code block 10-01 - HTML

```html
<!-- CSS URL using CDN, cdn-podcast.talkpython.fm domain. -->

https://cdn-podcast.talkpython.fm/static/css/site.css?cache_id=9b9f84
```

### Code block 10-02 - HTML

```html
<!-- CSS URL served from our server directly. -->

/static/css/site.css?cache_id=9b9f84
```

### Code block 10-03 - HTML

```html
<!-- Audio file using large file download CDN. -->

https://download-cdn.talkpython.fm/podcasts/talkpython/487-building-rust-extensions-for-python.mp3
```


## Chapter 11: Example Server Setup

### Code block 11-01 - Hosts file

```bash
# Entry in /etc/hosts or C:\Windows\System32\drivers\etc\hosts
20.21.22.23   		pyprod-host
```

### Code block 11-02 - Linux Shell

```bash
# Connect to pyprod-host using SSH (needs hosts entry).
ssh root@pyprod-host
```

### Code block 11-03 - Linux Shell

```bash
# Welcome screen at pyprod-host.

Welcome to Ubuntu 24.04.1 LTS (GNU/Linux 6.8.0-49-generic x86_64)

 * Documentation:  https://help.ubuntu.com
 * Management:     https://landscape.canonical.com
 * Support:        https://ubuntu.com/pro

 System information

  System load:  0.02               Processes:             138
  Usage of /:   24.8% of 37.23GB   Users logged in:       0
  Memory usage: 28%                IPv4 address for eth0: 20.21.22.23
  Swap usage:   0%

 * Strictly confined Kubernetes makes edge and 
   IoT secure. Learn how MicroK8s just raised 
   the bar for easy, resilient and secure K8s 
   cluster deployment.

   https://ubuntu.com/engage/secure-kubernetes-at-the-edge

Expanded Security Maintenance for Applications is not enabled.

180 updates can be applied immediately.

Enable ESM Apps to receive additional future security updates.
See https://ubuntu.com/esm or run: sudo pro status
```

### Code block 11-04 - Linux Shell

```bash
# Entry in ~/.ssh/config to simplify SSH for macOS/Linux.

Host pyprod-host
    HostName pyprod-host
    User root
    IdentityFile ~/.ssh/<private_key_file>
```

### Code block 11-05 - Linux Shell

```bash
# Install pending updates on your brand new server.

$ apt update
$ apt upgrade # Can pass -y to avoid prompting
$ reboot
```

### Code block 11-06 - Linux Shell

```bash
# File (fragment 1): book/ch11-example-setup/setup-host-server.sh

############################################################
# Setup the server itself including ohmyzsh
apt-get update
apt-get upgrade -y

# Install ZSH and ohmyzsh
apt-get install zsh -y
sh -c "$(curl -fsSL https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"

# Btop is an amazing tool for monitoring server behaviors
apt install btop -y

# We'll need these to operate the server
apt install ca-certificates -y
apt install curl wget -y
apt install git -y

# And listing directories as trees is very helpful
apt install tree -y

# Logging into github over and over is a hassle.
# This will remember it until you reboot or it times out.
git config --global credential.helper cache
git config --global credential.helper 'cache --timeout=720000'

# TODO: Enter your name and email for git in the placeholders.
git config --global user.email "YOUR_EMAIL"
git config --global user.name "YOUR_NAME"

# Install uv for local Python-based tool management
curl -LsSf https://astral.sh/uv/install.sh | sh
# install pls via uv, a better ls:
uv tool install pls

# Typing long commands is a hassle, create aliases to make
# them very simple (glances won't run until Docker is setup).

# Add the following lines to your ~/.zshrc file at the end:
alias http='docker run -it --rm --net=host clue/httpie'
alias glances='docker run --rm --name glances -v /var/run/docker.sock:/var/run/docker.sock:ro -v /run/user/1000/podman/podman.sock:/run/user/1000/podman/podman.sock:ro --pid host --network host -it docker.io/nicolargo/glances'
alias deploy="/cluster-src/book/ch11-example-setup/scripts/deploy.sh"
alias dc="docker compose"
alias lls="/bin/ls -G"
alias ls="pls"

# Once you edit and save your .zshrc file, reload the config:
source ~/.zshrc
```

### Code block 11-07 - Linux Shell

```bash
# File (fragment 2): book/ch11-example-setup/setup-host-server.sh

############################################################
# Setup docker on the server.

# Add Docker's official GPG key:
sudo apt-get update
sudo apt-get install ca-certificates curl -y
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc

# Add the repository to Apt sources:
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update

# To install the latest version of Docker
sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin -y
```

### Code block 11-08 - Linux Shell

```bash
# Test Docker by running hello-world.
docker run hello-world
```

### Code block 11-09 - Linux Shell

```bash
############################################################
# Create the persistent docker elements (network, disks, etc)
docker network create -d bridge cluster-network --subnet=174.44.0.0/16
```

### Code block 11-10 - Linux Shell

```bash
# Example command to create an external Docker volume (disk).

# Do NOT run this command, it's just for your reference.
# We are not using external volumes in our example.
docker volume create NAME
```

### Code block 11-11 - Linux Shell

```bash
# Remember to use your fork of this repo.
git clone https://github.com/mikeckennedy/talk-python-in-production-devops-book /cluster-src/
```

### Code block 11-12 - Linux Shell

```bash
cd /cluster-src/book/ch11-example-setup/containers/core-app/video-collector-docker/src
# Remember to use your fork of this repo.
git clone https://github.com/talkpython/htmx-python-course
```

### Code block 11-13 - Docker

```dockerfile
# File: ch11-example-setup/containers/base-images/linuxbase/Dockerfile
FROM ubuntu:latest

# Set your language and time zone so the server 
# is in the same time as you or your company.
ENV LANG=en_US.UTF-8
ENV LANGUAGE=en_US:en
ENV LC_ALL=en_US.UTF-8
ENV TZ="America/Los_Angeles"

# Run many commands without confirmations.
ENV DEBIAN_FRONTEND=noninteractive

# Apply the latest patches and security fixes.
RUN apt-get update
RUN apt-get upgrade -y

# Foundational tooling.
RUN apt-get -y install curl
RUN apt-get -y install wget
RUN apt-get install -y openssl
RUN apt-get -y install locales
RUN locale-gen en_US.UTF-8

# Tools for source code and installing packages.
RUN apt-get -y install git
RUN apt-get install -y gcc
RUN apt-get install -y clang

# Install Oh My ZSH for a nicer shell experience.
# Used for commands: 
# docker exec -it CONTAINER_NAME zsh
# docker run -it CONTAINER_NAME zsh
RUN apt-get install -y zsh
RUN sh -c "$(wget -O- https://github.com/deluan/zsh-in-docker/releases/download/v1.2.1/zsh-in-docker.sh)" -- \
    -t robbyrussell \
```

### Code block 11-14 - Docker

```dockerfile
# File: ch11-example-setup/containers/base-images/pythonbase/Dockerfile
FROM linux-example-base:latest

# uv and python are not accessible from the path by default.
# So add their paths here.
ENV PATH=/venv/bin:$PATH
ENV PATH=/root/.cargo/bin:$PATH
ENV PATH="/root/.local/bin/:$PATH"

# Our app will be based in this directory
# regardless of its actual file location on our build machine.
RUN mkdir /apps

# Install Rust/Cargo for local builds of Rust-based Python packages
RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y

# Install uv
RUN curl -LsSf https://astral.sh/uv/install.sh | sh

# Set up a virtual env to use for app destined for derived containers.
# This installs Python 3.13 in addition to creating the virtual environment.
# Incredibly, it only takes two seconds. 🚀 uv!
# Update Python 3.13 to the latest Python version as that evolves over time.
RUN uv venv --python 3.13 /venv

# Activate the venv if we login via docker run/exec:
RUN echo "\nsource /venv/bin/activate\n" >> /root/.zshrc

# Install some handy utilities for debugging within the container
RUN --mount=type=cache,target=/root/.cache uv pip install httpie pls

# Verify that Python is installed and works.
# This will fail the build if something has gone wrong.
RUN /venv/bin/python --version
```

### Code block 11-15 - Linux Shell

```bash
# Docker Compose command to build the foundational Docker images.

cd /cluster-src/book/ch11-example-setup/containers/base-images/
docker compose build linux-example-base
docker compose build python-example-base
```

### Code block 11-16 - Docker

```dockerfile
# File: book/ch11-example-setup/containers/base-images/compose.yaml
services:

  # Define the Python base image, depends_on ensures 
  # linux-example-base is built first.
  python-example-base:
    build: ./pythonbase
    container_name: python-example-base
    image: python-example-base
    depends_on:
      - linux-example-base

  linux-example-base:
    build: ./linuxbase
    container_name: linux-example-base
    image: linux-example-base
```

### Code block 11-17 - Docker

```dockerfile
# File: book/ch11-example-setup/containers/core-app/video-collector-docker/Dockerfile

# Use our python foundational image.
FROM python-example-base:latest

WORKDIR "/app"

# Recall our multi-step process to speed up builds discussed in chapter 8:

# 1. Copy the app's requirements file into the containers' /app directory.
COPY ./src/htmx-python-course/code/ch7_infinite_scroll/ch7_final_video_collector/requirements.txt /app
RUN uv self update
RUN --mount=type=cache,target=/root/.cache uv pip install -r requirements.txt

# 2. Copy the app source code into the containers' /app directory.
COPY src/htmx-python-course/code/ch7_infinite_scroll/ch7_final_video_collector /app

# Make sure we have the latest app server (Granián) if the bases are cached.
# This WILL exist fom python-example-base but it may be out of date.
RUN --mount=type=cache,target=/root/.cache uv pip install --upgrade "granian[pname]"

# Set the command to run when the container starts (Granián).
ENTRYPOINT [  \
    "/venv/bin/granian",\
    "app:app", \
    "--host","0.0.0.0", \
    "--port","15000", \
    "--interface","wsgi", \
    "--no-ws", \
    "--workers","2", \
    "--runtime-mode", "mt", \
    "--runtime-threads", "4",\
    "--loop","uvloop", \
    "--log-level","info", \
    "--log", \
    "--process-name", "granian [video-collector]" \
    ]
```

### Code block 11-18 - Docker Compose

```yaml
# Docker Compose file defining Video Collector's infrastructure settings.
# File: book/ch11-example-setup/containers/core-app/compose.yaml

services:

  # This defines our web app.
  video-collector:
    # Name the image in the docker images so it's not something random.
    image: video-collector

    # Name the container so it's clear when it's running.
    container_name: video-collector

    # Restart it if it crashes.
    restart: unless-stopped

    # Control which ports are open on the container and
    # what "network" they are available on.
    # "127.0.0.1:15000" is for the host and means that
    # the container can only be reached inside the server.
    # This is another layer of security beyond our cloud firewall.
    # The value for 15000 needs to line up with the granian command.
    ports:
      - "127.0.0.1:15000:15000"

    # Map a logfile directory (from .env) to container's /log dir.
    volumes:
      - "${APP_LOGS}:/logs"

    # Specify how to build this image, here it's via:
    # ./video-collector-docker/Dockerfile
    build: video-collector-docker

    # Limit how much of our server is given over to this container.
    # Doesn't matter in this case, but it's an example for larger clusters.
    deploy:
      resources:
        limits:
          memory: 1G

    # Specify which external Docker networks to join. 
    # Setting a unique and fixed IP address allows NGINX
    # to find it more reliably (a shortcoming of NGINX).
    networks:
      cluster-network:
        ipv4_address: 174.44.0.100

# This network was created during server setup with the
# `docker network create` command.
networks:
  cluster-network:
    name: cluster-network
    external: true
```

### Code block 11-19 - Linux Shell

```bash
cd /cluster-src/book/ch11-example-setup/containers/core-app/
docker compose build
```

### Code block 11-20 - Linux Shell

```bash
# Launch the Flask app with Docker Compose
cd /cluster-src/book/ch11-example-setup/containers/core-app/
docker compose up
```

### Code block 11-21 - Linux Shell

```bash
# Launch the Flask app in Docker Compose in the background.
docker compose up -d
```

### Code block 11-22 - Linux Shell

```bash
# Control the compose apps via:
docker compose down # shut down and clean up.
docker compose restart # restart (but not rebuild) all the containers.
docker compose logs -f -n 100 # Tail the combined logs (text output) of all containers.
```

### Code block 11-23 - Linux Shell

```bash
alias http='docker run -it --rm --net=host clue/httpie'
```

### Code block 11-24 - Linux Shell

```bash
http -h localhost:15000
```

### Code block 11-25 - Linux Shell

```bash
HTTP/1.1 200 OK
content-length: 4397
content-type: text/html; charset=utf-8
server: granian
```

### Code block 11-26 - Linux Shell

```bash
book/ch11-example-setup/scripts/create-docker-compose-service.sh
```

### Code block 11-27 - Linux Shell

```bash
# Create a systemd daemon for Video Collector.
cd /cluster-src/book/ch11-example-setup/containers/core-app/
bash /cluster-src/book/ch11-example-setup/scripts/create-docker-compose-service.sh
```

### Code block 11-28 - Linux Shell

```bash
Creating systemd service... /etc/systemd/system/core-app.service
Enabling & starting core-app
```

### Code block 11-29 - Linux Shell

```bash
# Check on the new Docker Compose based service.
service core-app status
```

### Code block 11-30 - Linux Shell

```bash
# Reboot the server to verify the service is auto-starting.
reboot

# Wait 10 seconds for the server to start.
# Reconnect
ssh root@pyprod-host

# Use httpie to call the app, should get 200 OK.
http -h localhost:15000

# you can also test that the container is running:
docker ps
```

### Code block 11-31 - Docker

```dockerfile
# File: book/ch11-example-setup/containers/web-servers/compose.yaml

services:

  # Our custom configuration for NGINX.
  nginx:
    # We run the latest base image.
    image: nginx:latest

    # Specify a container name so it's easy to see in management tools.
    container_name: nginx

    # If the container crashes for some reason, restart it.
    restart: unless-stopped

    # We need to map both port 80 and 443 
    # to the top level network on the host.
    # Notice there is no 127.0.0.1 like with our Flask app.
    ports:
      - "80:80"
      - "443:443"

    # There's a lot of configuration and logging 
    # that needs to happen for NGINX. This section
    # a bunch of directories that will go into greater 
    # detail about later.
    volumes:
      - "./local-nginx.conf:/etc/nginx/nginx.conf"
      - "${NGINX_SITES_ENABLED}:/etc/nginx/sites-enabled"
      - "${NGINX_LOGS}:/var/log/nginx/"
      - "${NGINX_STATIC}:/static/"
      - "${NGINX_LETSENCRYPT_WWW}:/var/www/letsencrypt"
      - "${CERTBOT_WWW}:/var/www/certbot/"
      - "${NGINX_LETS_ENCRYPT_ETC}:/etc/letsencrypt/"

		# NGINX has a nice health check that communicates 
		# to Docker whether it's running correctly.
		healthcheck:
      test: service nginx status || exit 1
      interval: 30s
      retries: 5
      start_period: 10s
      timeout: 1s

    # we can limit the amount of server allowed by nginx as well
    deploy:
      resources:
        limits:
          memory: 1G

    # NGINX and the other containers need to share 
    # the same network so that HTTP requests can 
    # be passed through to the Python app.
    networks:
      cluster-network:

	# We discussed the use of certbot and let's encrypt in chapter 9.
	# However, we're not going into further detail here 
	# because that requires access to proper DNS and 
	# other settings that are a bit beyond the goal of this chapter.
	# This block is only here for completeness.
  certbot:
      image: certbot/certbot:latest
      container_name: certbot
      volumes:
        - "${CERTBOT_WWW}:/var/www/certbot/"
        - "${NGINX_LETS_ENCRYPT_ETC}:/etc/letsencrypt/:rw"
      networks:
        cluster-network:

# Remember that we discussed creating this external network above.
networks:
  cluster-network:
    name: cluster-network
    external: true
```

### Code block 11-32 - Linux Shell

```bash
############################################################
# Make the static folders for data exchange between the
# containers, git updates, and data exports
mkdir -p /cluster-data/
mkdir -p /cluster-data/nginx/static
mkdir -p /cluster-data/nginx/logs
mkdir -p /cluster-data/logs/video-collector

mkdir -p /cluster-data/nginx/letsencrypt-etc
mkdir -p /cluster-data/nginx/letsencrypt-www
mkdir -p /cluster-data/nginx/certbot/www
```

### Code block 11-33 - Linux Shell

```bash
# Copy dot-env-template.sh to .env and edit .env for NGINX
cd book/ch11-example-setup/containers/web-servers/
cp dot-env-template.sh .env
nano .env
```

### Code block 11-34 - Linux Shell

```bash
# Launch NGINX with Docker Compose.
cd book/ch11-example-setup/containers/web-servers/
docker compose up
```

### Code block 11-35 - Linux Shell

```bash
# Test our empty NGINX container is handling requests.
http -h localhost

# Output:
HTTP/1.1 404 Not Found
Connection: keep-alive
Content-Length: 153
Content-Type: text/html
Server: nginx/1.27.3
```

### Code block 11-36 - Linux Shell

```bash
# Create a systemd daemon for NGINX.
cd /cluster-src/book/ch11-example-setup/containers/web-servers/
bash /cluster-src/book/ch11-example-setup/scripts/create-docker-compose-service.sh
```

### Code block 11-37 - Linux Shell

```bash
# Output from systemd daemon NGINX script.
Creating systemd service... /etc/systemd/system/web-servers.service
Enabling & starting core-app
```

### Code block 11-38 - NGINX

```nginx
# File: book/ch11-example-setup/containers/web-servers/nginx-base-configs/video-collector.nginx

server {
    # The server domain is your public DNS name.
    # We're just going to change our local machine DNS and use this one.
    server_name video-collector-test.talkpython.com;
    listen 80;
    charset utf-8;
    client_max_body_size 1M;

    # Don't return the NGINX Version in case there's a vulnerability 
    # that can be searched for.
    server_tokens off;

    # NGINX will serve the static files directly, 
    # so we set them up separately from the application.
    location /static {
        gzip on;

        gzip_comp_level 6;
        gzip_min_length 1100;
        gzip_buffers 16 8k;
        gzip_proxied any;
        gzip_types
            text/plain
            text/xml
            text/css
            application/javascript
            application/json
            application/xml
            application/rss+xml;

        # Specify, relative to the internals of the Docker container, 
        # where the static files live. For example 
        # http://video-collector-test.talkpython.com/static/img/logo.jpg
        # will find the file in /static/video-collector/img/logo.jpg
        # on THIS internal Docker file system.
        alias /static/video-collector;
        expires 365d;
    }

    # Here for let's encrypt support, not used in example.
    location /.well-known/acme-challenge/ {
        root /var/www/certbot;
    }

    # This handles the rest of the requests to this web app.
    location / {
        try_files $uri @yourapplication;
    }
    # Here is where we tell NGINX to pass commands over to 
    # our production app server running on Granian.
    location @yourapplication {
        gzip on;
        gzip_comp_level 6;
        gzip_min_length 1100;
        gzip_buffers    8 256k;
        gzip_proxied any;
        gzip_types
            text/plain
            text/xml
            text/css
            application/javascript
            application/json
            application/xml
            application/rss+xml;

        # Recall that we explicitly specified this IP 
        # address in port in the Video Collector 
        # docker-compose configuration. The IP address 
        # is for the internal Docker network that we created.
        proxy_pass http://174.44.0.100:15000;

        include uwsgi_params;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-Protocol $scheme;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Host $host;
    }
}
```

### Code block 11-39 - Linux Shell

```bash
# Copy static files over to a static location visible to NGINX.
cp -r /cluster-src/book/ch11-example-setup/containers/core-app/video-collector-docker/src/htmx-python-course/code/ch7_infinite_scroll/ch7_final_video_collector/static/* /cluster-data/nginx/static/video-collector
```

### Code block 11-40 - Linux Shell

```bash
# Verify the mapped static folder contains the correct file structure.
tree /cluster-data/nginx/static/video-collector -d

# Output
/cluster-data/nginx/static/video-collector
├── css
├── fontawesome-free
│   ├── css
│   └── webfonts
├── img
│   └── categories
└── js
```

### Code block 11-41 - Linux Shell

```bash
# Reload and update NGINX's configuration files.
cd /cluster-src/book/ch11-example-setup/containers/web-servers/
docker compose exec -t nginx nginx -s reload
```

### Code block 11-42 - Hosts file

```bash
# On YOUR CLIENT machine's hosts, enter:

# Existing
20.21.22.23   		pyprod-host

# Add
20.21.22.23   		video-collector-test.talkpython.com
```


## Chapter 12: Static Sites and Hugo

### Code block 12-01 - NGINX

```nginx
# NGINX configuration file for https://mkennedy.codes (static site)
server {
    listen 80;
    # Redirect a bunch of other domains I've used back to this site.
    server_name www.mkennedy.codes mkennedy.tech www.mkennedy.tech michaelckennedy.net www.michaelckennedy.net michaelckennedy.com www.michaelckennedy.com;

    # Here is the redirect statement
    return 301 https://mkennedy.codes$request_uri;
    server_tokens off;
}

server {
    listen 80;
    # Listen for the domain of the static site.
    server_name mkennedy.codes;
    charset utf-8;
    server_tokens off;

		# THESE TWO ARE THE CRITICAL BITS
		
		# The root of this site is just a location where we
		# git cloned the files generated by Hugo to ./prod
    root /apps/static/mkennedy.codes/mkennedy-codes/prod;

    # Tell NGINX that if it sees a path that is a folder
    # not a file, use index.html as the content.
    # e.g with the URL:
    # https://mkennedy.codes/posts/blue-skies-ahead-follow-me-there/
    # render the file:
    # /apps/static/mkennedy.codes/mkennedy-codes/prod/posts/blue-skies-ahead-follow-me-there/index.html
    index index.html;

    # Use alias for the ACME/Let's Encrypt challenge directory
    location /.well-known/acme-challenge/ {
        alias /var/www/certbot/.well-known/acme-challenge/;
        try_files $uri =404;
    }

		# Add 2 minutes of caching, just locally per browser
		# on each top-level page.
    location ~* .(html)$ {
        expires 2m;
        add_header Cache-Control "private";
        add_header Cache-Control "max-age=120"; # set cache timeout to 2 min for pages
    }

		# Add 1 hours' worth of caching on images, css, etc.
    location ~* .(png|webp|ico|gif|jpg|jpeg|css|js)$ {
        expires 1h;
        add_header Cache-Control "public";
        add_header Cache-Control "max-age=3600"; # set cache timeout to 1 hour
    }

		# gzip our text content for much faster delivery.
    gzip on;

    gzip_comp_level 6;
    gzip_min_length 1100;
    gzip_buffers 16 8k;
    gzip_proxied any;
    gzip_types
    text/plain
    text/xml
    text/css
    application/javascript
    application/json
    application/xml
    application/rss+xml;
}
```

### Code block 12-02 - Linux Shell

```bash
hugopublish="cd [LOCAL_SITE_FOLDER] && pwd && git pull && hugo build --destination public-prod --cleanDestinationDir && git add **/. && git commit -m \"Added recent build contents\" && ssh [HOST_NAME] \"echo \"Updating mkennedy.codes\" && cd [SERVER_SITE_FOLDER]/prod && git pull"
```

### Code block 12-03 - NGINX

```nginx
server {
    listen 80;
    server_name talkpython.fm;
    server_tokens off;

    # ...

    # Map a subroute to /blog, see next two blocks
    # talkpython.fm/blog location (no caching for HTML content)
    location /blog {
      alias /apps/static/talkpython/talk-python-blog/prod/;
      index index.html;

      # Disable caching for the main content
      add_header Cache-Control "no-store, no-cache, must-revalidate, proxy-revalidate, max-age=0";
      expires off;
  }

  # Separate location block for static assets (CSS, JS, images) to enable caching
  location ~* /blog/(.+\.(css|js|jpg|jpeg|png|webp|gif|svg|ico|woff|woff2|ttf|otf))$ {
     # Similar to the prior example...
  }

  # Critical that this portion comes after /blog 
  # since it's effectively catching all URLs.
  location / {
     try_files $uri @talk_python_app;
  }
  location @talk_python_app { ... }
}
```

### Code block 12-04 - Python

```python
# Python code to pull sitemap entries from nested static site 
# This is used to add them back to the root website's sitemap.
BlogMapEntry = namedtuple('BlogMapEntry', ['loc', 'modified'])

def get_items_from_blog_sitemap() -> list[BlogMapEntry]:
    resp = requests.get('https://talkpython.fm/blog/sitemap.xml')
    resp.raise_for_status()

    ns = {'ns': 'http://www.sitemaps.org/schemas/sitemap/0.9'}
    root = ElementTree.fromstring(resp.text)

    excludes = ['/categories/', '/tags/']

    # Extract loc and lastmod elements
    url_info = []
    for url in root.findall('ns:url', ns):
        loc = url.find('ns:loc', ns).text
        lastmod = url.find('ns:lastmod', ns)
        lastmod_text = lastmod.text if lastmod is not None else None
        entry = BlogMapEntry(loc, lastmod_text)

        skip = False
        for exclude in excludes:
            if exclude in entry.loc:
                skip = True
                break

        if skip:
            continue

        url_info.append(entry)

    return url_info
```


## Chapter 13: Picking a Python Web Framework

### Code block 13-01 - Python

```python
# Flask blueprints that define Talk Python's global structure.

import quart
# ...

def register_blueprints(app: quart.Quart):
    # Needs to appear first.
    app.register_blueprint(episodes_blueprint)

    app.register_blueprint(home_blueprint)
    app.register_blueprint(friends_blueprint)
    app.register_blueprint(advertiser_blueprint)
    app.register_blueprint(search_blueprint)
    app.register_blueprint(stream_blueprint)
    app.register_blueprint(sitemap_blueprint)
    app.register_blueprint(policies_blueprint)
    app.register_blueprint(account_blueprint)
    app.register_blueprint(admin_blueprint)
    app.register_blueprint(error_blueprint)
    app.register_blueprint(hackers_blueprint)

    # URL shortener needs to be last in line.
    app.register_blueprint(redirector_blueprint)
```

### Code block 13-02 - Python

```python
# Example of an asynchronous Flask view using chameleon_flask

@app.get('/catalog/item/{item_id}')
@chameleon_flask.template('catalog/item.pt')
async def item(item_id: int):
    item = service.get_item_by_id(item_id)
    if not item:
        return chameleon_flask.not_found()

    return item.dict()
```

### Code block 13-03 - Python

```python
# Async data access leads to a secondary init function

@episodes_blueprint.get('/<int:show_id>')
async def show_by_number(show_id: int):
    vm = ShowEpisodeViewMode(show_id)
    await vm.load_async() # Now needed for await
    if vm.episode is None:
        quart.abort(404)

    return webutils.redirect_to(vm.episode.details_action_url, permanent=True)
```


