FROM debian:jessie
# FROM blitznote/debootstrap-amd64
# FROM alpine:3.4
MAINTAINER Justifiably <justifiably@ymail.com>

RUN apt-get update && \
#    apt-get install -yq ia32-libs && \
    apt-get install libc6-i386 && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

ENV GOSU_VERSION 1.9
RUN set -x \
    && apt-get update && apt-get install -y --no-install-recommends ca-certificates wget && rm -rf /var/lib/apt/lists/* \
    && wget -O /usr/local/bin/gosu "https://github.com/tianon/gosu/releases/download/$GOSU_VERSION/gosu-$(dpkg --print-architecture)" \
    && wget -O /usr/local/bin/gosu.asc "https://github.com/tianon/gosu/releases/download/$GOSU_VERSION/gosu-$(dpkg --print-architecture).asc" \
    && export GNUPGHOME="$(mktemp -d)" \
    && gpg --keyserver ha.pool.sks-keyservers.net --recv-keys B42F6819007F00F88E364FD4036A9C25BF357DD4 \
    && gpg --batch --verify /usr/local/bin/gosu.asc /usr/local/bin/gosu \
    && rm -r "$GNUPGHOME" /usr/local/bin/gosu.asc \
    && chmod +x /usr/local/bin/gosu \
    && gosu nobody true \
    && apt-get purge -y --auto-remove ca-certificates wget

# Better: get https://github.com/ncopa/su-exec

# WORKDIR /opt
# RUN wget http://www.spicefly.com/files/MusicMixer_x86_1.8.tgz
# RUN tar -xpf MusicMixer_x86_1.8.tgz && rm -f MusicMixer_x86_1.8.tgz
# RUN cd /opt/MusicIP/MusicMagicMixer/server && \
# RUN unzip index-1.1.zip

ADD MusicMixer_x86_1.8.tgz /opt
ADD index.html /opt/MusicIP/MusicMagicMixer/server
RUN useradd -m -g users --uid 1057 musicip

EXPOSE 10002

CMD gosu musicip /opt/MusicIP/MusicMagicMixer/MusicMagicServer -verbose start
