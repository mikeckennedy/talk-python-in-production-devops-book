#! /usr/bin/bash

# --------------------- DOCKER BASES ----------------------------------
echo "Updating Docker base images"
docker pull ubuntu:latest
docker pull nginx:latest
