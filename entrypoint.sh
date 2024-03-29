#!/usr/bin/env sh
[ "$USERNAME" ] && [ "$PASSWORD" ] && printf '%s|%s\n' "$USERNAME" "$PASSWORD" >>/app/conf/users.conf && :

if [ ! "$NO_SCAN" ]; then
	printf '[]\n' >/app/titledb/files.json
	python /app/nut.py --scan
	/nut-scan-daemon.sh &
fi

exec "$@"
