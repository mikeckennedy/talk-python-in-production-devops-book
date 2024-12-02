FROM pythonbase:latest

RUN mkdir /app


COPY src/requirements.txt /app
WORKDIR "/app"
RUN --mount=type=cache,target=/root/.cache uv pip install -r requirements.txt

COPY src/ /app

# Make sure we have the latest web servers if the bases are cached.
RUN --mount=type=cache,target=/root/.cache uv pip install --upgrade granian[pname]

# Expose the port that Granián will use
EXPOSE 8080

# Set the command to run when the container starts (Granián)
ENTRYPOINT [  \
    "/venv/bin/granian",\
    "app:app", \
    "--host","0.0.0.0", \
    "--port","8080", \
    "--interface","wsgi", \
    "--no-ws", \
    "--workers","2", \
    "--threads","4", \
    "--loop","uvloop", \
    "--log-level","info",\
    "--log", \
    "--process-name", \
    "granian [uv-docker-app]" \
    ]

