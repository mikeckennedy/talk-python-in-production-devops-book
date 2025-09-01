# WARP.md

This file provides guidance to WARP (warp.dev) when working with code in this repository.

## Table of Contents

1. [Introduction & Purpose](#introduction--purpose)
2. [Repository Layout](#repository-layout)
3. [System Architecture](#system-architecture)
4. [Quick Start](#quick-start)
5. [Common Commands](#common-commands)
6. [Environment & Configuration](#environment--configuration)
7. [Development Workflow](#development-workflow)
8. [Helper Scripts Reference](#helper-scripts-reference)
9. [Testing & Linting Guidelines](#testing--linting-guidelines)
10. [Contributing & Support](#contributing--support)

## Introduction & Purpose

This is the companion repository for **"Talk Python in Production"** by Michael Kennedy - a cloud-agnostic guide to building, scaling, and managing Python infrastructure using a stack-native approach. The repository demonstrates the book's core philosophy:

- **Single powerful server** rather than many small instances
- **Docker containerization** with proper layering and caching
- **Self-hosted services** to avoid vendor lock-in
- **NGINX reverse proxy** with Let's Encrypt SSL
- **Production-ready deployment** with systemd integration

The examples focus on running your own infrastructure on a single, well-configured VM using Docker and proven open-source tools.

## Repository Layout

```
devops-book-public/
├── book/                           # Chapter-specific resources and examples
│   ├── ch08-docker-performance-tips/   # Docker optimization examples
│   └── ch11-example-setup/             # Complete production setup guide
│       ├── containers/                 # Docker infrastructure
│       │   ├── base-images/            # Foundational Docker images
│       │   ├── core-app/               # Video Collector demo app
│       │   └── web-servers/            # NGINX + Certbot setup
│       ├── scripts/                    # Deployment and automation scripts
│       └── setup-host-server.sh       # Initial server configuration
├── galleries/                      # Reference materials from the book
│   ├── code-gallery/               # All code snippets by chapter
│   ├── figure-gallery/             # High-resolution book figures
│   └── links-gallery/              # External links and resources
├── images/                         # Repository assets
├── README.md                       # Main repository overview
└── ruff.toml                       # Python linting configuration
```

## System Architecture

The repository demonstrates a three-tier containerized architecture:

```
┌─────────────────────────────────────────────────┐
│ External Traffic (Port 80/443)                 │
└─────────────────┬───────────────────────────────┘
                  │
┌─────────────────▼───────────────────────────────┐
│ NGINX Reverse Proxy Container                   │
│ • SSL termination (Let's Encrypt)              │
│ • Static file serving                          │
│ • Request routing                              │
└─────────────────┬───────────────────────────────┘
                  │ cluster-network (174.44.0.0/16)
┌─────────────────▼───────────────────────────────┐
│ Python Application Container (174.44.0.100)    │
│ • Granian ASGI server (production-ready)       │
│ • Flask/Quart web application                  │
│ • uv for fast dependency management            │
└─────────────────┬───────────────────────────────┘
                  │
┌─────────────────▼───────────────────────────────┐
│ Base Images (Layered)                          │
│ • linux-example-base: Ubuntu + tools           │
│ • python-example-base: Python 3.13 + uv       │
└─────────────────────────────────────────────────┘
```

**Key Components:**
- **External Docker Network**: `cluster-network` (174.44.0.0/16) for inter-container communication
- **Static IP Assignment**: Application container gets fixed IP for NGINX routing
- **Volume Mounts**: Shared logs, static files, and SSL certificates
- **Systemd Integration**: Containers run as system services for automatic restart

## Quick Start

### Prerequisites
- Ubuntu 22.04/24.04 LTS
- Docker 24+ with Compose plugin
- git, curl, wget
- uv (installed via setup script)

### Local Development (Minimal)
```bash
# Clone repository and demo app
git clone https://github.com/mikeckennedy/devops-book-public /cluster-src
cd /cluster-src/book/ch11-example-setup/containers/core-app/video-collector-docker/src
git clone https://github.com/talkpython/htmx-python-course

# Build and run just the application
cd /cluster-src/book/ch11-example-setup/containers/base-images
docker compose build
cd ../core-app
docker compose build
docker compose up -d

# Test application
curl -I http://localhost:15000
```

### Production Setup
**⚠️ WARNING**: Never run `setup-host-server.sh` directly! Execute it section by section, customizing for your environment.

```bash
# Review and run setup script piece by piece
less /cluster-src/book/ch11-example-setup/setup-host-server.sh

# Key steps:
# 1. Update system packages
# 2. Install ZSH, Docker, utilities
# 3. Create Docker network: docker network create -d bridge cluster-network --subnet=174.44.0.0/16
# 4. Clone repositories and configure paths
# 5. Set up systemd services for automatic startup
```

## Common Commands

| Command | Purpose |
|---------|---------|
| **Building** | |
| `docker compose build` | Build images in current directory |
| `docker compose build --no-cache` | Force rebuild without cached layers |
| **Container Management** | |
| `docker compose up -d` | Start containers in background |
| `docker compose down` | Stop and remove containers |
| `docker compose restart` | Restart all services |
| `docker ps` | List running containers |
| **Logging & Debugging** | |
| `docker compose logs -f -n 100` | Follow last 100 log lines |
| `docker exec -it video-collector zsh` | Shell into app container |
| `docker exec -it nginx bash` | Shell into NGINX container |
| `tail -f /cluster-data/logs/video-collector/*.log` | Follow app logs |
| **Deployment** | |
| `deploy` | Full update and rebuild (alias) |
| `dc up --build` | Rebuild and restart (dc = docker compose alias) |
| **SSL Management** | |
| `docker compose run --rm certbot certonly --webroot --webroot-path /var/www/certbot/ -d example.com` | Request SSL certificate |
| `docker compose run --rm certbot renew --webroot --webroot-path /var/www/certbot/` | Renew certificates |
| **System Services** | |
| `systemctl status core-app` | Check application service status |
| `systemctl status web-servers` | Check NGINX service status |
| `systemctl restart core-app` | Restart application service |

## Environment & Configuration

### Required Environment Variables

Copy template and customize:
```bash
cp book/ch11-example-setup/containers/web-servers/dot-env-template.sh .env
```

Key variables to configure:
```bash
# Core paths (create these directories first)
APP_LOGS=/cluster-data/logs/video-collector
NGINX_SITES_ENABLED=/cluster-data/nginx/sites-enabled
NGINX_LOGS=/cluster-data/nginx/logs
NGINX_STATIC=/cluster-data/nginx/static

# SSL certificates (Let's Encrypt)
NGINX_LETS_ENCRYPT_ETC=/cluster-data/nginx/letsencrypt-etc
CERTBOT_WWW=/cluster-data/nginx/certbot/www

# Domain configuration
# Update video-collector.nginx with your actual domain
```

### Network Setup
```bash
# Create external Docker network (run once)
docker network create -d bridge cluster-network --subnet=174.44.0.0/16

# Verify network exists
docker network ls | grep cluster-network
```

**⚠️ Security Note**: Never commit `.env` files to version control. Add `.env` to your `.gitignore`.

## Development Workflow

### Code Changes
1. **Application Code**: Edit files in `book/ch11-example-setup/containers/core-app/video-collector-docker/src/`
2. **Rebuild Core App**: `cd book/ch11-example-setup/containers/core-app && docker compose build`
3. **Restart**: `docker compose up -d`

### NGINX Configuration
1. **Edit Config**: Modify files in `/cluster-data/nginx/sites-enabled/`
2. **Reload NGINX**: `docker compose exec nginx nginx -s reload`
3. **No rebuild required** for configuration changes

### Full Deployment Pipeline
```bash
# Use the deploy alias (defined in .zshrc)
deploy

# Or run manually:
book/ch11-example-setup/scripts/update-source.sh
book/ch11-example-setup/scripts/update-images.sh
book/ch11-example-setup/scripts/build_containers.sh
```

### Hot Development (Local)
For rapid iteration, mount your code as a volume:
```yaml
# Add to core-app/compose.yaml temporarily
volumes:
  - "${APP_LOGS}:/logs"
  - "./video-collector-docker/src:/app"  # Mount source for hot reload
```

### Production Deployment
- **Systemd Services**: Containers automatically start on boot
- **Service Management**: Use `systemctl` commands for production control
- **Log Persistence**: Logs are stored in `/cluster-data/logs/` on the host

## Helper Scripts Reference

### Setup Scripts
| Script | Purpose | ⚠️ Notes |
|--------|---------|----------|
| `setup-host-server.sh` | Initial server configuration | **Never run directly!** Execute sections manually |
| `create-docker-compose-service.sh` | Create systemd service for compose project | Run from compose directory |

### Deployment Scripts  
| Script | Purpose | Context |
|--------|---------|---------|
| `deploy.sh` | Complete update and rebuild pipeline | Production deployment |
| `build_containers.sh` | Build all container images in sequence | Called by deploy.sh |
| `update-images.sh` | Pull latest base images | Called by deploy.sh |
| `update-source.sh` | Git pull latest source code | Called by deploy.sh |

### Useful Aliases (added to `.zshrc`)
```bash
alias http='docker run -it --rm --net=host clue/httpie'
alias glances='docker run --rm --name glances -v /var/run/docker.sock:/var/run/docker.sock:ro --pid host --network host -it docker.io/nicolargo/glances'
alias deploy="/cluster-src/book/ch11-example-setup/scripts/deploy.sh"
alias dc="docker compose"
alias ls="pls"  # Better ls alternative via uv
```

## Testing & Linting Guidelines

### Python Code Quality
Configured in `ruff.toml`:
```toml
line-length = 120
format.quote-style = "single"
lint.select = ["E", "F"]  # Pyflakes errors and warnings
target-version = "py311"
```

### Running Linting
```bash
# Install ruff (if not already available)
uv tool install ruff

# Check code quality
ruff check .

# Auto-format code
ruff format .

# Check specific files
ruff check book/ch08-docker-performance-tips/faster-docker-example/webapp/src/
```

### Testing
- **Application Testing**: Use the demo Video Collector app to test the full stack
- **HTTP Testing**: Use the `http` alias (HTTPie in Docker) for API testing
- **Container Health**: Use Docker healthchecks where configured

### Pre-commit Hook (Optional)
```bash
# .git/hooks/pre-commit
#!/bin/bash
ruff check . --exit-non-zero-on-fix
ruff format . --check
```

## Contributing & Support

### Getting Help
- **Book Questions**: [Talk Python in Production](https://talkpython.fm/books/python-in-production)
- **Repository Issues**: Use GitHub Issues for bugs and feature requests
- **General Discussion**: Use GitHub Discussions
- **Training**: [Talk Python Training Courses](https://training.talkpython.fm/courses/all)

### Contributing
1. **Fork the Repository**: Create your own fork for testing changes
2. **Branch Strategy**: Use descriptive branch names (`feature/nginx-config`, `fix/docker-build`)
3. **Code Style**: Follow existing patterns and ruff configuration
4. **Testing**: Test your changes with the example application
5. **Documentation**: Update relevant sections of this WARP.md file

### Adding New Examples
1. **Chapter Structure**: Follow the existing pattern in `book/chXX-*/`
2. **Docker Best Practices**: Use multi-stage builds and layer caching
3. **Documentation**: Add code snippets to `galleries/code-gallery/README.md`
4. **Configuration**: Include template files for any required setup

### Pull Request Guidelines
- **Clear Description**: Explain what problem you're solving
- **Testing**: Include instructions for testing your changes
- **Documentation**: Update WARP.md if you change workflows or add features
- **Backwards Compatibility**: Consider existing users of the examples

---

**Maintenance Note**: This WARP.md should be updated whenever Dockerfiles, scripts, or workflows change. The goal is to keep this as the single source of truth for working with this repository effectively.
