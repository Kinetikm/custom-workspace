FROM ubuntu:20.04
ENV TZ=Europe/Moscow

ADD ./ /init_folder

RUN \
    apt-get update && \
    apt-get install -y locales && \
    sed -i -e 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen && \
    locale-gen && \
    dpkg-reconfigure --frontend=noninteractive locales && \
    update-locale LANG=en_US.UTF-8 && \
    apt-get install -y --no-install-recommends curl ca-certificates python3-pip

ENV LC_ALL="en_US.UTF-8" \
    LANG="en_US.UTF-8" \
    LANGUAGE="en_US:en"

RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

RUN bash /init_folder/tools/code-server/install.sh && \
    code-server --install-extension /init_folder/extentions/ms-python.python-2021.10.1336267007.vsix && \
    mv /init_folder/run.sh / && \
    rm -r /init_folder && apt-get autoremove && apt-get clean && apt-get install git -y && \
    pip install tensorboard
CMD ["cd / && bash run.sh"]
