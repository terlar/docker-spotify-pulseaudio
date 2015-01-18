#!/bin/bash
set -e

if [ "$1" = 'spotify' ]; then
	USER_UID=${USER_UID:-1000}
	USER_GID=${USER_GID:-1000}

	# create user group
	if ! getent group spotify >/dev/null; then
		groupadd -f -g ${USER_GID} spotify
	fi

	# create user with uid and gid matching that of the host user
	if ! getent passwd spotify >/dev/null; then
		adduser --uid ${USER_UID} --gid ${USER_GID} \
			--disabled-login \
			--gecos 'Spotify' spotify

		ln -s /data/cache /home/spotify/.cache
		ln -s /data/config /home/spotify/.config
	fi

	chown -R spotify:spotify /data

	exec su spotify -c "$@"
fi

exec "$@"
