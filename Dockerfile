FROM ubuntu:18.04
MAINTAINER Siddharth Kanungo <admin@primerlabs.io>

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update -q \
    && apt-get install -qy build-essential wget libfontconfig1 \
    && rm -rf /var/lib/apt/lists/*

# Install TexLive with scheme-basic
RUN wget http://mirror.ctan.org/systems/texlive/tlnet/install-tl-unx.tar.gz; \
	mkdir /install-tl-unx; \
	tar -xvf install-tl-unx.tar.gz -C /install-tl-unx --strip-components=1; \
    echo "selected_scheme scheme-full" >> /install-tl-unx/texlive.profile; \
	/install-tl-unx/install-tl -profile /install-tl-unx/texlive.profile; \
    rm -r /install-tl-unx; \
	rm install-tl-unx.tar.gz



ENV PATH="/usr/local/texlive/2020/bin/x86_64-linux:${PATH}"

ENV HOME /data
WORKDIR /data

# Install latex packages
RUN tlmgr install latexmk

RUN apt-get update && \
        apt-get install -y software-properties-common vim && \
        add-apt-repository ppa:deadsnakes/ppa
RUN apt-get update -y

RUN apt-get install -y build-essential python3.8 python3.8-dev python3-pip python3.8-venv && \
        apt-get install -y git

RUN ln -s /usr/bin/pip3 /usr/bin/pip
RUN ln -s /usr/bin/python3.8 /usr/bin/python

# update pip
RUN python3.8 -m pip install pip --upgrade && \
        python3.8 -m pip install wheel

# Add Nginx
RUN apt-get update &&  apt-get install -y --no-install-recommends \
        libatlas-base-dev gfortran nginx supervisor
RUN pip install uwsgi

# Nginx add end

RUN apt-get update && \
  apt-get -y install \
   apt-utils \
   curl \
   fontconfig \
   git \
   gnuplot \
   libfontconfig1 \
   make \
   perl \
   sudo \
   vim \
   wget \
   xzdec

RUN apt-get update -q && apt-get install -qy \
    python-pygments gnuplot \
    make git \
    && rm -rf /var/lib/apt/lists/*


WORKDIR /data
VOLUME ["/data"]