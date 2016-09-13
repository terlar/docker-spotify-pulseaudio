FROM debian:jessie
MAINTAINER Terje Larsen

# Install Spotify and PulseAudio.
WORKDIR /usr/src
RUN echo "deb http://repository.spotify.com stable non-free" >> /etc/apt/sources.list \
	&& echo "deb-src http://repository.spotify.com stable non-free" >> /etc/apt/sources.list \
	&& apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 94558F59 D2C19886 \
	&& apt-get update \
	&& apt-get install -y --no-install-recommends \
		xdg-utils \
		ttf-wqy-zenhei \
		xdg-utils \
		pulseaudio \
		curl \
		libpangoxft-1.0-0 \
		libxss1 \
		spotify-client \
	&& curl -Lo libgcrypt11.deb http://ftp.de.debian.org/debian/pool/main/libg/libgcrypt11/libgcrypt11_1.5.0-5+deb7u4_amd64.deb \
	&& curl -Lo libudev0.deb http://ftp.de.debian.org/debian/pool/main/u/udev/libudev0_175-7.2_amd64.deb \
	&& curl	-Lo libxss1.deb	http://ftp.de.debian.org/debian/pool/main/libx/libxss/libxss1_1.2.2-1_amd64.deb \
	&& apt-get purge -y --auto-remove curl \
	&& { dpkg -i libgcrypt11.deb || true; } \
	&& rm libgcrypt11.deb \
	&& { dpkg -i libudev0.deb || true; } \
        && rm libudev0.deb \
	&& { dpkg -i libxss1.deb || true; } \
	&& rm libxss1.deb \
	&& rm -rf /var/lib/apt/lists/* \
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
