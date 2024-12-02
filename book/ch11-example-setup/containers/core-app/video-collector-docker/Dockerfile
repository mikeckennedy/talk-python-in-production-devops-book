FROM python-example-base:latest

WORKDIR "/app"

COPY ./src/htmx-python-course/code/ch7_infinite_scroll/ch7_final_video_collector/requirements.txt /app
RUN --mount=type=cache,target=/root/.cache uv pip install -r requirements.txt

COPY src/htmx-python-course/code/ch7_infinite_scroll/ch7_final_video_collector /app

# Make sure we have the latest web server if the bases are cached.
RUN --mount=type=cache,target=/root/.cache uv pip install --upgrade granian[pname]

# Expose the port that Granián will use
EXPOSE 5000

# Set the command to run when the container starts (Granián)
ENTRYPOINT [  \
    "/venv/bin/granian",\
    "app:app", \
    "--host","0.0.0.0", \
    "--port","5000", \
    "--interface","wsgi", \
    "--no-ws", \
    "--workers","2", \
    "--threads","4", \
    "--loop","uvloop", \
    "--log-level","info",\
    "--log", \
    "--process-name", \
    "granian [video-collector]" \
    ]
