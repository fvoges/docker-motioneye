
FROM ubuntu:16.04
LABEL maintainer "Federico Voges <fvoges@gmail.com>"

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update && apt-get upgrade -y && apt-get dist-upgrade -y && apt-get autoclean && apt-get autoremove

RUN apt-get -q -y --no-install-recommends install locales
RUN locale-gen en_GB.UTF-8
ENV LANGUAGE en_GB.UTF-8
ENV LC_ALL en_GB.UTF-8
ENV LANG en_GB.UTF-8
ENV LC_TYPE en_GB.UTF-8
ENV TZ Europe/London

RUN apt-get -q -y --no-install-recommends install \
    automake \
    autoconf \
    build-essential \
    ffmpeg \
    git \
    libav-tools \
    libavcodec-dev \
    libavformat-dev \
    libavutil-dev \
    libcurl4-openssl-dev \
    libjpeg-dev \
    libssl-dev \
    libswscale-dev \
    pkgconf \
    python-dev \
    python-pip \
    python-setuptools \
    subversion \
    v4l-utils

RUN apt-get -q -y --no-install-recommends install \
    autoconf \
    automake \
    build-essential \
    git \
    libavcodec-dev \
    libavdevice-dev \
    libavformat-dev \
    libavutil-dev \
    libjpeg-turbo8 \
    libjpeg-turbo8-dev \
    libswscale-dev \
    libtool \
    libzip-dev \
    libwebp-dev \
    pkgconf \
    x264


# Pip
RUN pip install tornado jinja2 pillow pycurl

RUN cd /tmp && git clone --branch 4.0 https://github.com/Motion-Project/motion.git motion-project
RUN cd /tmp/motion-project && \
    autoreconf -fiv && \
    ./configure --prefix=/usr --without-pgsql --without-sqlite3 --without-mysql --with-ffmpeg=/usr && \
    make && \
    touch README \
    make install && \
    cp motion /usr/local/bin/motion && cd / && \
    rm -rf /tmp/motion-project

RUN pip install motioneye

#RUN apt-get remove -y \
#    automake \
#    autoconf \
#    build-essential \
#    git \
#    libavcodec-dev \
#    libavformat-dev \
#    libavutil-dev \
#    libcurl4-openssl-dev \
#    libjpeg-dev \
#    libssl-dev \
#    libswscale-dev \
#    pkgconf \
#    python-dev \
#    python-pip \
#    python-setuptools \
#    subversion && \
#    apt-get autoclean -y && apt-get autoremove -y
RUN  apt-get clean && apt-get autoclean -y && apt-get autoremove -y

# R/W needed for motioneye to update configurations
VOLUME /etc/motioneye

# PIDs
VOLUME /var/run/motion

# Video & images
VOLUME /var/lib/motioneye

CMD test -e /etc/motioneye/motioneye.conf || \
    cp /usr/local/share/motioneye/extra/motioneye.conf.sample /etc/motioneye/motioneye.conf ; \
    /usr/local/bin/meyectl startserver -c /etc/motioneye/motioneye.conf

EXPOSE 8081 8765

