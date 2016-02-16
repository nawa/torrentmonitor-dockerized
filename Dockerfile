FROM phusion/baseimage:latest

RUN apt-get update
RUN apt-get install -y wget unzip nginx sqlite3
RUN apt-get install -y php5-common php5-cli php5-fpm php5-curl php5-sqlite
ADD nginx-default   /etc/nginx/sites-available/default
ADD php.ini   /etc/php5/cli/php.ini
RUN echo "daemon off;" >> /etc/nginx/nginx.conf

RUN wget -q http://korphome.ru/torrent_monitor/tm-latest.zip -O /tmp/tm-latest.zip
RUN unzip /tmp/tm-latest.zip -d /tmp \
	&& rm /tmp/tm-latest.zip \
	&& mv /tmp/TorrentMonitor-master /usr/share/nginx/html/torrentmonitor

ADD config.php   /usr/share/nginx/html/torrentmonitor/config.php
RUN mkdir /usr/share/nginx/html/torrentmonitor/db
RUN cat /usr/share/nginx/html/torrentmonitor/db_schema/sqlite.sql | sqlite3 /usr/share/nginx/html/torrentmonitor/db_schema/tm.sqlite

RUN echo "0 * * * *  php -q /usr/share/nginx/html/torrentmonitor/engine.php >> /var/log/torrentmonitor_error.log 2>&1" >> /etc/cron.d/torrentmonitor

RUN mkdir -p /etc/my_init.d
RUN echo '#!/bin/sh\n\
if [ ! -f /usr/share/nginx/html/torrentmonitor/db/tm.sqlite ];\n\
then\n\
	cp /usr/share/nginx/html/torrentmonitor/db_schema/tm.sqlite /usr/share/nginx/html/torrentmonitor/db/tm.sqlite\n\
fi\n\
chown -R www-data:www-data /usr/share/nginx/html/torrentmonitor\n\
chmod -R a+rw /usr/share/nginx/html/torrentmonitor\n\
chmod -R 777 /usr/share/nginx/html/torrentmonitor/db\n\
service php5-fpm start && service nginx start'\
>> /etc/my_init.d/start_nginx.sh
RUN chmod +x /etc/my_init.d/start_nginx.sh

VOLUME ["/usr/share/nginx/html/torrentmonitor/db", "/usr/share/nginx/html/torrentmonitor/torrents"]

EXPOSE 80

CMD ["/sbin/my_init"]