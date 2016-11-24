#!/bin/sh

if [ ! -f /DATA/htdocs/db/tm.sqlite ];
then
	cp /DATA/htdocs/db_schema/tm.sqlite /DATA/htdocs/db/tm.sqlite
fi

#Alpine iconv doesn't support "//IGNORE"
/torrentmonitor/clean-iconv-ignores.sh

crond

chown -R nginx:www-data /DATA/htdocs
chmod -R a+rw /DATA/htdocs
chmod -R 777 /DATA/htdocs/db

# start php-fpm
mkdir -p /DATA/logs/php-fpm
php-fpm

# start nginx
mkdir -p /DATA/logs/nginx
mkdir -p /tmp/nginx
chown nginx /tmp/nginx
nginx