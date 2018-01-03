FROM ubuntu:16.04
MAINTAINER Terje Larsen

# Install Spotify and PulseAudio.
WORKDIR /usr/src
RUN apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 0DF731E45CE24F27EEEB1450EFDC8610341D9410 \
	&& echo deb http://repository.spotify.com stable non-free > /etc/apt/sources.list.d/spotify.list \
	&& apt-get update \
	&& apt-get install -y \
		spotify-client xdg-utils libxss1 \
		pulseaudio \
		fonts-noto \
	&& apt-get clean \
	&& echo enable-shm=no >> /etc/pulse/client.conf

# Spotify data.
VOLUME ["/data/cache", "/data/config"]
WORKDIR /data
RUN mkdir -p /data/cache \
	&& mkdir -p /data/config

# PulseAudio server.
ENV PULSE_SERVER /run/pulse/native

COPY docker-entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]

CMD ["spotify"]
