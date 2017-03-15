FROM anapsix/alpine-java:8_server-jre
MAINTAINER Alan Jenkins <alan.james.jenkins@gmail.com>

ENV MCMEM=4000

ADD get_pack.py /usr/bin/get_pack
ADD start_mc.sh /usr/bin/start_mc
RUN apk --no-cache add gcc && \
    apk --no-cache add python && \
    apk --no-cache add git && \
    apk --no-cache add musl-dev && \
    apk --no-cache add ca-certificates wget && \
    update-ca-certificates && \
    cd /tmp/ && git clone https://github.com/Tiiffi/mcrcon.git && cd /tmp/mcrcon/ && gcc -std=gnu11 -pedantic -Wall -Wextra -O2 -s -o mcrcon mcrcon.c && cp mcrcon /usr/bin/mcrcon && rm -Rf /tmp/mcrcon && \ 
    mkdir -p /srv/minecraft && cd /srv/minecraft/ && /usr/bin/get_pack skyfactory3 && rm /srv/minecraft/minecraft.zip && rm /usr/bin/get_pack && mkdir /srv/minecraft/world && echo 'eula=true' > /srv/minecraft/eula.txt && cd /srv/minecraft/ && sh ./FTBInstall.sh && \
    chmod +x /usr/bin/start_mc && addgroup -g 995 minecraft && adduser -h /srv/minecraft -S -u 996 -G minecraft minecraft && chown -R minecraft:minecraft /srv/minecraft && \
    apk del --purge git gcc musl-dev && apk del ca-certificates wget python

VOLUME /srv/minecraft/world
VOLUME /srv/minecraft/config.override
VOLUME /srv/minecraft/mods.override
VOLUME /srv/minecraft/crash-reports
VOLUME /srv/minecraft/backups

USER minecraft
CMD cd /srv/minecraft && /usr/bin/start_mc
