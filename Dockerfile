FROM alpine:latest

# define PHP and libiconv version
ENV PHP_VERSION 5.6.17
ENV LIBICONV_VERSION 1.14

# define workdir to home
WORKDIR /install

RUN apk update && apk upgrade && \

	apk add \
			# install build tools
			grep build-base tar re2c make file \
			# PHP dependencies
			libxpm libxml2 \
			libxpm-dev libxml2-dev curl-dev \
			# required software
			curl nginx unzip sqlite && \

	# download sources
	curl -SL http://cz1.php.net/get/php-${PHP_VERSION}.tar.gz/from/this/mirror | tar -xz -C ./ && \
	curl -SL http://ftp.gnu.org/pub/gnu/libiconv/libiconv-${LIBICONV_VERSION}.tar.gz | tar -xz -C ./ && \
	cd ./libiconv-${LIBICONV_VERSION}/srclib && \
	curl https://raw.githubusercontent.com/mxe/mxe/7e231efd245996b886b501dad780761205ecf376/src/libiconv-1-fixes.patch | patch stdio.in.h && \
	cd - && \

	# remove origin iconv
	rm /usr/bin/iconv && \

	# install libiconv from source
	./libiconv-${LIBICONV_VERSION}/configure --prefix=/usr/local && \
	make && make install && \

	# install php from source
	./php-${PHP_VERSION}/configure --prefix=/usr \
		--with-pic \
		--with-layout=GNU \
		--enable-inline-optimization \
		--disable-phpdbg \
		--enable-cli \
		--disable-cgi \
		--enable-fpm \
		--enable-mbstring \
		--disable-zip \
		--with-curl \
		--with-iconv \
		--with-iconv-dir=/usr/local \
		--enable-pdo \
		--with-pdo-sqlite \
		--disable-intl \
		--disable-debug \
		--disable-rpath \
		--disable-static \
		--disable-pcntl \
		--disable-ftp \
		--disable-shared \
		--disable-soap \
		--with-config-file-path=/etc/php \
		--with-config-file-scan-dir=/etc/php/conf.d \
		--sysconfdir=/etc/php \
		--without-pear \
		--enable-sockets && \

	make && make install && \

	wget -q http://korphome.ru/torrent_monitor/tm-latest.zip -O ./tm-latest.zip && \
	unzip ./tm-latest.zip && \
			mkdir -p /DATA/htdocs && \
			mv ./TorrentMonitor-master/* /DATA/htdocs && \

	(crontab -l ; echo "0 * * * *  php -q /DATA/htdocs/engine.php >> /DATA/logs/nginx/torrentmonitor_cron_error.log #2>&1") | crontab - && \

	mkdir /DATA/htdocs/db && mkdir /run/nginx &&\
	cat /DATA/htdocs/db_schema/sqlite.sql | sqlite3 /DATA/htdocs/db_schema/tm.sqlite && \

	apk del    grep build-base tar re2c make file unzip sqlite \
			   libxpm-dev libxml2-dev curl-dev && \

	# clear apk cache
	rm -rf /var/cache/apk/* && \

	# remove sources
	rm -rf /install

# replace origin iconv
ENV LD_PRELOAD /usr/local/lib/preloadable_libiconv.so

# copy configs
COPY files/php.ini                      /etc/php/php.ini
COPY files/nginx.conf                   /etc/nginx/
COPY files/php-fpm.conf                 /etc/php/
COPY files/run.sh                       /torrentmonitor/
COPY files/php.ini                      /etc/php5/cli/php.ini
COPY files/torrentmonitor-config.php    /DATA/htdocs/config.php
RUN chmod +x /torrentmonitor/run.sh

WORKDIR /

VOLUME ["/DATA/htdocs/db", "/DATA/htdocs/torrents"]

EXPOSE 80

CMD ["/torrentmonitor/run.sh"]