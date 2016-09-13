FROM debian:jessie
MAINTAINER Terje Larsen

# Install Spotify and PulseAudio.
WORKDIR /usr/src
RUN echo "deb http://repository.spotify.com stable non-free" >> /etc/apt/sources.list \
	&& echo "deb-src http://repository.spotify.com stable non-free" >> /etc/apt/sources.list \
	&& apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 94558F59 D2C19886 \
	&& apt-get update \
	&& apt-get install -y \
		libgl1-mesa-glx \
		ttf-wqy-zenhei \
	&& apt-get install -y --no-install-recommends \
		pulseaudio \
		libasound2 \
		libc6 \
		libqt4-dbus \
		libqtcore4 \
		libqtgui4 \
		libqt4-network \
		libstdc++6 \
		libxss1 \
		usbutils \
		libssl1.0.0 \
		libnspr4-0d \
		libgconf2-4 \
		libgtk2.0-0 \
		libnss3-1d \
		libglib2.0-0 \
		xdg-utils \
		dbus-x11 \
		libudev1 \
		spotify-client \
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
