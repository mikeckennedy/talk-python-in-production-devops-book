# Appendix: Code Gallery

This gallery contains all the code blocks from the book. They are replicated here into a single location so that you can browse through them more easily.

They are also available on GitHub with GitHub highlighting and formatting so you can read them on your computer directly. This is especially helpful if your e-reader is cutting of blocks of code or making it hard to read.

Visit [github.com/mikeckennedy/talk-python-in-production-devops-book/tree/main/code-gallery](https://github.com/mikeckennedy/talk-python-in-production-devops-book/tree/main/code-gallery)

## Chapter 5: Running on Rust

### Code block 05-01

```
WARNING: This is a development server. Do not use it in a production deployment. Use a production WSGI server instead.
```

### Code block 05-02

```
talkpython.quart_app:app \ 
       --host 0.0.0.0 --port 8801 \ 
       --interface asgi \ 
       --no-ws 
       --workers 3 \
       --threading-mode workers \
       --loop uvloop \
       --workers-lifetime 43200 --respawn-interval 30 \
       --process-name "granian-talkpython" \
       --log --log-level info
```

### Code block 05-03 - Docker

```dockerfile
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


--------------------------------------------------------------------------------

## Chapter 6: The unexpected benefits of self-hosting

### Code block 06-01 - Linux Shell

```bash
docker volume create umami-volume
```

### Code block 06-02 - Docker

```dockerfile
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
# In the folder with the docker-compose.yml file:
docker compose up
```

### Code block 06-04 - Docker

```dockerfile
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
docker volume create kuma-volume
```

### Code block 06-06 - Docker

```dockerfile
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


--------------------------------------------------------------------------------

## Chapter 7: Visualizing servers and other tools

### Code block 07-01 - Linux Shell

```bash
apt install btop
```

### Code block 07-02 - Linux Shell

```bash
docker pull nicolargo/glances:latest-full
docker run --rm -e TZ="${TZ}" -v /var/run/docker.sock:/var/run/docker.sock:ro -v /run/user/1000/podman/podman.sock:/run/user/1000/podman/podman.sock:ro --pid host --network host -it nicolargo/glances:latest-full
```

### Code block 07-03 - Linux Shell

```bash
# in .zshrc / .bashrc
alias update_glances="docker pull nicolargo/glances:latest-full"
alias run_glances="docker run --rm -e TZ="${TZ}" -v /var/run/docker.sock:/var/run/docker.sock:ro -v /run/user/1000/podman/podman.sock:/run/user/1000/podman/podman.sock:ro --pid host --network host -it nicolargo/glances:latest-full"

alias glances="update_glances && run_glances"
```

### Code block 07-04 - Linux Shell

```bash
uv tool install dockerclustermon
```

### Code block 07-05 - Linux Shell

```bash
pipx install dockerclustermon
```

### Code block 07-06 - Linux Shell

```bash
dockerstatus servername
```

### Code block 07-07 - Linux Shell

```bash
docker exec -it nginx bash
```

### Code block 07-08 - Linux Shell

```bash
docker exec -it talkpython zsh
(venv) ➜  /app
```

### Code block 07-09 - Linux Shell

```bash
export ZSH="/root/.oh-my-zsh"
ZSH_THEME="robbyrussell"
plugins=()
source $ZSH/oh-my-zsh.sh

source /venv/bin/activate
```

### Code block 07-10 - Docker

```dockerfile
# Uses "robbyrussell" theme (original Oh My Zsh theme), with no plugins
RUN sh -c "$(wget -O- https://github.com/deluan/zsh-in-docker/releases/download/v1.2.0/zsh-in-docker.sh)" -- -t robbyrussell
```

### Code block 07-11 - Docker

```dockerfile
services:
  talkpython:
    image: talkpython
    # ...
    volumes:
      # Env variable TALKPYTHON_LOGS maps to a local folder.
      - "${TALKPYTHON_LOGS}:/logs"
```

### Code block 07-12 - Linux Shell

```bash
tail -n 500 -f /cluster/logs/talkpython/request-log.log
```


--------------------------------------------------------------------------------

## Chapter 8: Docker performance tips

### Code block 08-01 - Docker

```dockerfile
FROM ubuntu:latest

RUN mkdir /app
COPY ./files /app

RUN apt update
RUN apt upgrade -y

ENTRYPOINT [ ... your startup command here ... ]
```

### Code block 08-02 - Docker

```dockerfile
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
FROM ubuntu:latest

# Move ahead
RUN apt update
RUN apt upgrade -y

# Magically install Python
# We'll talk about how to do this well in a moment
# Or just use the Python official image if you rather
# Though that is unnecessary these days IMO.


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
# ############ FOCUS HERE ##############
...

# Break out the copy of the requirements file and 
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
# ############ FOCUS HERE ##############
...

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
FROM ubuntu:latest

# ...

# Set some paths making it eaiser to run uv and python
ENV PATH=/venv/bin:$PATH
ENV PATH="/root/.local/bin/:$PATH"

# ############ FOCUS HERE ##############

# Install uv
RUN curl -LsSf https://astral.sh/uv/install.sh | sh 

# Create the venv and download the correct version of Python
RUN uv venv --python 3.13 /app/venv

COPY ./src/requirements.txt /app
# Use uv now rather than pip
RUN uv pip install -r requirements.txt

# ######### UNTIL HERE #################

COPY ./src/ /app

...
```

### Code block 08-07 - Docker

```dockerfile
FROM ubuntu:latest

# ...

# Use uv now rather than pip
RUN --mount=type=cache,target=/root/.cache uv pip install -r requirements.txt

...
```

### Code block 08-08 - Docker

```dockerfile
# .dockerignore - place next to Dockerfile
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


--------------------------------------------------------------------------------

## Chapter 9: NGINX, containers, and let's encrypt

### Code block 09-01

```
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

    location /.well-known/acme-challenge/ { alias /var/www/certbot; }

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
```

### Code block 09-02

```
services:

  NGINX:
    image: NGINX:latest
    container_name: NGINX
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
dc run --rm certbot certonly --webroot --webroot-path /var/www/certbot/ -d talkpython.fm
```

### Code block 09-04 - NGINX

```nginx
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

    location /.well-known/acme-challenge/ { alias /var/www/certbot; }

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
docker compose run --rm certbot renew --webroot --webroot-path /var/www/certbot/
```

### Code block 09-06 - Linux Shell

```bash
Saving debug log to /var/log/letsencrypt/letsencrypt.log

- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
Processing /etc/letsencrypt/renewal/talkpython.fm.conf
- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
Certificate not yet due for renewal

The following certificates are not due for renewal yet:
  /etc/letsencrypt/live/talkpython.fm/fullchain.pem expires on 2025-01-31 (skipped)
  # ... many more redacted, also not renewed. :)
```


--------------------------------------------------------------------------------

## Chapter 10: CDNs

### Code block 10-01 - HTML

```html
https://cdn-podcast.talkpython.fm/static/css/site.css?cache_id=9b9f84
```

### Code block 10-02 - HTML

```html
/static/css/site.css?cache_id=9b9f84
```

### Code block 10-03 - HTML

```html
https://download-cdn.talkpython.fm/podcasts/talkpython/487-building-rust-extensions-for-python.mp3
```


--------------------------------------------------------------------------------

## Chapter 13: Changing web frameworks

### Code block 13-01 - Python

```python
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

    # Redirector needs to be last in line.
    app.register_blueprint(redirector_blueprint)
```

### Code block 13-02 - Python

```python
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
@episodes_blueprint.get('/<int:show_id>')
async def show_by_number(show_id: int):
    vm = ShowEpisodeViewMode(show_id, -1)
    await vm.load_async()
    if vm.episode is None:
        quart.abort(404)

    return webutils.redirect_to(vm.episode.details_action_url, permanent=True)
```


--------------------------------------------------------------------------------

