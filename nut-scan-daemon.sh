#!/usr/bin/env sh
scan_wait=${SCAN_WAIT:-30}

if [ ! "$USERNAME" ] || [ ! "$PASSWORD" ]; then
	USERNAME=
	PASSWORD=
	while IFS= read -r line || [ "$line" ]; do
		case "$line" in
		'id|password') ;;
		*\|*)
			USERNAME="${line%%|*}"
			PASSWORD="${line#*|}"
			;;
		esac
		[ "$USERNAME" ] && [ "$PASSWORD" ] && break
	done </app/conf/users.conf
fi

if [ "$USERNAME" ] && [ "$PASSWORD" ]; then
	while :; do
		sleep "$scan_wait"
		curl --silent --connect-timeout 10 --max-time 60 --user "${USERNAME}:${PASSWORD}" http://127.0.0.1:9000/api/scan >/dev/null || :
	done
fi
