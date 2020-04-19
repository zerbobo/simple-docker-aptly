FROM ubuntu:16.04

LABEL maintainer="zerbobo" \
    description="An easy way to run aptly in Docker as desired."

ADD configs /tmp/configs 
ADD scripts /tmp/scripts

RUN cp /tmp/configs/sources.list /etc/apt/sources.list \
    && echo "\ndeb http://repo.aptly.info/ squeeze main" >> /etc/apt/sources.list \
    && apt-key adv --keyserver pool.sks-keyservers.net --recv-keys ED75B5A4483DA07C

## you can use below line to add proxy to apt, so that aptly source can be dealt successfully (Nice to GFW)
#RUN export http_proxy=http://<proxy> && apt-get -q update \
RUN apt-get -q update \
    && apt-get -y install \
        aptly=1.4.0 \
        bzip2 \
        xz-utils \
        gnupg \
        gpgv \
        nginx \
        curl \
        graphviz \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* \
    && rm /etc/nginx/sites-enabled/* \
    && cp /tmp/configs/nginx.conf /etc/nginx/conf.d/default.conf \
    && cp /tmp/configs/aptly.conf /etc/aptly.conf \
    && mkdir -p /opt/aptly \
    && cp -r /tmp/scripts /opt/aptly/scripts

EXPOSE 80

VOLUME [ "/var/aptly" ]

ENTRYPOINT ["/opt/aptly/scripts/run.sh"]
