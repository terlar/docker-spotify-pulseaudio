FROM ubuntu:latest
MAINTAINER Terje Larsen

# Install Spotify and PulseAudio.
RUN echo "deb http://repository.spotify.com stable non-free" >> /etc/apt/sources.list \
	&& echo "deb-src http://repository.spotify.com stable non-free" >> /etc/apt/sources.list \
	&& apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 94558F59 \
	&& apt-get update \
	&& apt-get install -y --no-install-recommends \
		pulseaudio \
		libpangoxft-1.0-0 \
		spotify-client \
	&& rm -rf /var/lib/apt/lists/*

# Spotify data.
VOLUME ["/data/cache", "/data/config"]
WORKDIR /data
RUN mkdir -p /data/cache \
	&& mkdir -p /data/config

# PulseAudio server.
ENV PULSE_SERVER=/run/pulse/native

COPY docker-entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]

CMD ["spotify"]
