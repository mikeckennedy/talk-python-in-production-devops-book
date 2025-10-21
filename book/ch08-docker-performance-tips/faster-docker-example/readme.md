# Faster Docker Example - Python Web Application

This is a sample application demonstrating Docker performance optimization techniques using multi-stage builds with optimized base images. The application is a simple Flask web app served with Granian and uses `uv` for fast Python package management.

## Prerequisites

To build and run this application, you will need:

- **Docker** - [Install Docker](https://docs.docker.com/get-docker/)
- **Docker Compose** - [Install Docker Compose](https://docs.docker.com/compose/install/)

## Building the Application

The application uses a multi-stage build process with three layers:

1. `linuxbase-faster` - Optimized Linux base image
2. `pythonbase-faster` - Python runtime with `uv` package manager
3. `uv-docker-app` - The Flask web application

To build all images, run the following command from the folder containing the `compose.yaml` file:

```bash
docker compose build linuxbase-faster && docker compose build pythonbase-faster && docker compose build uv-docker-app
```

Note that with Docker Compose v1, you could simply run `docker compose build` and they would run in order. With v2, Docker Compose is optimized to build in parallel but unfortunately lacks any mechanism to indicate a dependency order.

## Running the Application

Once the images are built, start the web application with:

```bash
docker compose up
```

## Accessing the Web Application

After startup, click the URL displayed in the app startup logs to view the web app. The application will be available at:

```
http://127.0.0.1:8080
```

You should see a "Hello, World" message demonstrating the application is running successfully.

## Stopping the Application

To stop the running containers, press `Ctrl+C` in the terminal where `docker compose up` is running, or run:

```bash
docker compose down
```

## Application Details

- **Web Framework**: Flask
- **WSGI Server**: Granian (high-performance async server)
- **Package Manager**: uv (ultra-fast Python package installer)
- **Port**: 8080 (mapped to localhost only)
