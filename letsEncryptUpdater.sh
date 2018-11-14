#! /bin/sh

if [ -n "$(find /etc/letsencrypt/live -follow -name '*.pem' -mtime -1)" ]
then
	/usr/sbin/nginx -t && /usr/sbin/nginx -s reload
fi
