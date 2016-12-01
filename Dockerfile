FROM alpine:latest

WORKDIR /install

RUN apk update && apk upgrade && \
	apk add wget unzip nginx sqlite php5-common php5-cli php5-fpm php5-curl php5-sqlite3  php5-pdo_sqlite php5-iconv php5-json php5-ctype php5-zip && \
	wget -q http://korphome.ru/torrent_monitor/tm-latest.zip -O ./tm-latest.zip && \
	unzip ./tm-latest.zip && \
			mkdir -p /DATA/htdocs && \
			mv ./TorrentMonitor-master/* /DATA/htdocs && \
	(crontab -l ; echo "0 * * * *  php -q /DATA/htdocs/engine.php >> /DATA/logs/nginx/torrentmonitor_cron_error.log #2>&1") | crontab - && \
	mkdir /DATA/htdocs/db && mkdir /run/nginx &&\
	cat /DATA/htdocs/db_schema/sqlite.sql | sqlite3 /DATA/htdocs/db_schema/tm.sqlite && \
	apk del wget unzip sqlite && \
	rm -rf /var/cache/apk/* /install

COPY files/php.ini                      /etc/php5/php.ini
COPY files/php.ini                      /etc/php5/cli/php.ini
COPY files/php-fpm.conf                 /etc/php5/
COPY files/nginx.conf                   /etc/nginx/
COPY files/run.sh                       /torrentmonitor/
COPY files/clean-iconv-ignores.sh 		/torrentmonitor/
COPY files/torrentmonitor-config.php    /DATA/htdocs/config.php

RUN chmod +x /torrentmonitor/run.sh /torrentmonitor/clean-iconv-ignores.sh

WORKDIR /

VOLUME ["/DATA/htdocs/db", "/DATA/htdocs/torrents"]

EXPOSE 80

CMD ["/torrentmonitor/run.sh"]