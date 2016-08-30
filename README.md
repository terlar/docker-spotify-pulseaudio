# Dockerized Spotify

Run Spotify inside an isolated [Docker](http://www.docker.io) container. This is achieved by sharing a socket for X11 and PulseAudio.

## Instructions

1. Clone this repository and change to the directory:

  ```sh
  git clone https://github.com/terlar/docker-spotify-pulseaudio.git && cd docker-spotify-pulseaudio
  ```

2. Build the container:

  ```sh
  sudo docker build -t spotify .
  ```

3. Run the provided spotify script:

  ```sh
  scripts/spotify
  ```

4. Use Spotify.

## Troubleshooting

Q: After running scripts/spotify I get:

  ```
  (spotify:29): Gtk-WARNING **: cannot open display: unix:0
  ```

A: You need to allow connections to the X server:

  ```sh
  xhost +
  ```
