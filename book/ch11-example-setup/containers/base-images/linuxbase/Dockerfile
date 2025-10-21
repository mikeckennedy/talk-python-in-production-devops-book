FROM ubuntu:latest

ENV LANG=en_US.UTF-8
ENV LANGUAGE=en_US:en
ENV LC_ALL=en_US.UTF-8
ENV TZ="America/Los_Angeles"
ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update
RUN apt-get upgrade -y

RUN echo "Heads up - this section takes a little while but only builds once on the machine until Linux updates."

RUN apt-get -y install curl
RUN apt-get -y install wget
RUN apt-get -y install locales
RUN locale-gen en_US.UTF-8

RUN apt-get -y install git
RUN apt-get install -y gcc
RUN apt-get install -y clang
# RUN apt-get install -y build-essential
RUN apt-get install -y openssl

# Install Oh My ZSH: Uses "robbyrussell" theme (original Oh My Zsh theme), with no plugins
RUN apt-get install -y zsh
RUN sh -c "$(wget -O- https://github.com/deluan/zsh-in-docker/releases/download/v1.2.1/zsh-in-docker.sh)" -- \
    -t robbyrussell \
