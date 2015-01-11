FROM ubuntu:latest

MAINTAINER Terje Larsen

# Install Spotify, OpenSSH and PulseAudio.
RUN \
  echo "deb http://repository.spotify.com stable non-free" >> /etc/apt/sources.list && \
  echo "deb-src http://repository.spotify.com stable non-free" >> /etc/apt/sources.list && \
  apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 94558F59 && \
  apt-get update && \
  apt-get install -y pulseaudio openssh-server && \
  apt-get install -fy libpangoxft-1.0-0 spotify-client && \
  rm -rf /var/lib/apt/lists/*

# Configure OpenSSH.
RUN \
  mkdir -p /var/run/sshd && \
  echo X11Forwarding yes >> /etc/ssh/ssh_config

# Create spotify user.
RUN \
  groupadd -r spotify && \
  useradd -r -m -g spotify spotify && \
  echo "spotify:spotify" | chpasswd

# Set up the launch wrapper.
RUN \
  echo 'export PULSE_SERVER="tcp:localhost:64713"' >> /usr/local/bin/spotify-pulseaudio && \
  echo 'spotify' >> /usr/local/bin/spotify-pulseaudio && \
  chmod 755 /usr/local/bin/spotify-pulseaudio

# Spotify data.
RUN \
  mkdir -p /data/spotify && \
  chown -R spotify:spotify /data/spotify && \
  mkdir -p /home/spotify/.config && \
  ln -s /data/spotify /home/spotify/.config/spotify

# Start SSH.
ENTRYPOINT ["/usr/sbin/sshd", "-D"]

# Expose port.
EXPOSE 22
