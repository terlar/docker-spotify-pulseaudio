# Dockerized Spotify

Run Spotify inside an isolated [Docker](http://www.docker.io) container. This is achieved by X11-forwarding and PulseAudio.

## Instructions

1. Install [PulseAudio Preferences](http://freedesktop.org/software/pulseaudio/paprefs/).

2. Launch PulseAudio Preferences, go to the **"Network Server"** tab, and check the **"Enable network access to local sound devices"** and **"Don't require authentication"** checkboxes.

3. Restart PulseAudio.

4. [Install Docker](http://docs.docker.io/en/latest/installation/) if you haven't already

5. Clone this repository and change to the directory:

  ```sh
  git clone https://github.com/terlar/docker-spotify-pulseaudio.git && cd docker-spotify-pulseaudio
  ```

6. Build the container

  ```sh
  sudo docker build -t spotify .
  ```

7. Create an entry in your .ssh/config file for easy access. It should look like this:

  ```sh
  Host docker-spotify
    User docker
    Port 22122
    HostName 127.0.0.1
    RemoteForward 64713 localhost:4713
    ForwardAgent yes
    ForwardX11 yes
    ForwardX11Trusted yes
  ```

8. Run the container and forward the appropriate port

  ```sh
  docker run --name spotify --rm -p 22122:22 spotify
  ```

9. Connect via SSH and launch Spotify using the provided PulseAudio wrapper script.

  ```sh
  ssh docker-spotify spotify-pulseaudio
  ```

10. Use Spotify.
