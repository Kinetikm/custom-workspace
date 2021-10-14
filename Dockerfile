FROM ubuntu:20.04
ENV TZ=Europe/Moscow

ADD ./ /init_folder

RUN \
    apt-get update && \
    apt-get install -y locales && \
    sed -i -e 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen && \
    locale-gen && \
    dpkg-reconfigure --frontend=noninteractive locales && \
    update-locale LANG=en_US.UTF-8

ENV LC_ALL="en_US.UTF-8" \
    LANG="en_US.UTF-8" \
    LANGUAGE="en_US:en"

RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

RUN apt-get update --fix-missing && \
    apt-get install -y sudo apt-utils && \
    apt-get upgrade -y && \
    apt-get update && \
    apt-get install -y --no-install-recommends \
        curl ca-certificates npm make git wget tar autotools-dev autoconf \
        uuid-dev zlib1g-dev libjson-c-dev pkg-config

RUN wget https://dl.google.com/go/go1.16.4.linux-amd64.tar.gz
RUN tar -xvf go1.16.4.linux-amd64.tar.gz && mv go /usr/local

RUN bash /init_folder/tools/code-server/install.sh
RUN export GOROOT=/usr/local/go && \
    export PATH=$GOROOT/bin:$PATH && \
    cd /init_folder/tools/filebrowser && make build
#RUN bash /init_folder/tools/netdata/netdata-installer.sh

CMD ["bash", "/init_folder/tools/run.sh"]
