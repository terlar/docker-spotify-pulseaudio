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

# Create user "docker" and set the password to "docker".
RUN \
  useradd -m -d /home/docker docker && \
  echo "docker:docker" | chpasswd && \
  mkdir /home/docker/.ssh && \
  chown -R docker:docker /home/docker && \
  chown -R docker:docker /home/docker/.ssh

# Set up the launch wrapper.
RUN \
  echo 'export PULSE_SERVER="tcp:localhost:64713"' >> /usr/local/bin/spotify-pulseaudio && \
  echo 'spotify' >> /usr/local/bin/spotify-pulseaudio && \
  chmod 755 /usr/local/bin/spotify-pulseaudio

# Start SSH.
ENTRYPOINT ["/usr/sbin/sshd", "-D"]

# Expose port.
EXPOSE 22
