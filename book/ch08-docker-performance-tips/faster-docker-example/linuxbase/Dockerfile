FROM ubuntu:latest

ENV LANG=en_US.UTF-8
ENV LANGUAGE=en_US:en
ENV LC_ALL=en_US.UTF-8
ENV TZ="America/Los_Angeles"
ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update
RUN apt-get upgrade -y
# RUN apt-get dist-upgrade

RUN apt-get -y install locales git curl wget
RUN locale-gen en_US.UTF-8

RUN apt-get install -y gcc
RUN apt-get install -y clang
RUN apt-get install -y build-essential
RUN apt-get install -y openssl

