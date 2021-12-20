[![Latest Image](https://img.shields.io/docker/v/alfonder/torrentmonitor?color=lightgreen&label=latest)](https://hub.docker.com/r/alfonder/torrentmonitor)
[![Image](https://img.shields.io/docker/image-size/alfonder/torrentmonitor?sort=semver)](https://hub.docker.com/r/alfonder/torrentmonitor)
[![License](https://img.shields.io/github/license/alfonder/torrentmonitor-dockerized)](https://github.com/alfonder/torrentmonitor-dockerized)

Dockerized torrentmonitor
========
[[RU]](./README-RU.md)

Info about project - https://github.com/ElizarovEugene/TorrentMonitor

Supported torrent trackers
- anidub.com
- animelayer.ru
- casstudio.tv
- **kinozal.tv**
- nnm-club.ru
- pornolab.net
- rustorka.com
- **rutracker.org**
- rutor.org
- tfile.me
- tracker.0day.kiev.ua
- tv.mekc.info
- baibako.tv 
- hamsterstudio.org
- **lostfilm.tv**
- newstudio.tv
- novafilm.tv

### Credits
Many thanks to [nawa](https://github.com/nawa) who had started 'torrentmonitor-dockerized' project back several years ago. His great job made me fork this project when he stopped support it.

## How to Use

### Basic Usage
1. Install docker https://docs.docker.com/engine/install/
2. Depending on your system type you need to run `docker` command with `sudo` or add the user to "docker" group
3. Get the container image from DockerHub: 

		docker pull alfonder/torrentmonitor:latest

	Alternative way: get the image from GitHub Registry:

		docker pull ghcr.io/alfonder/torrentmonitor:latest

4. Run container:

		docker container run -d \
			--name torrentmonitor \
			--restart unless-stopped \
			-p 8080:80 \
			-v <path_to_torrents_folder>:/data/htdocs/torrents \
			-v <path_to_db_folder>:/data/htdocs/db \
			alfonder/torrentmonitor
	You should change database and downloaded torrents location to your paths. As a result you will reach persistence, so you will not lose your data on delete/re-create containers

5. Open browser on page [http://localhost:8080](http://localhost:8080)
6. Configure the web application and enjoy

### Advanced Usage
- you can change server port from `8080` to your preferred port (`-p` option)
- also you can specify environment variables to change default behaviour of container 
	- `CRON_TIMEOUT="0 */3 * * *"` Specify execution timeout in [crontab format](https://crontab.guru/examples.html). Default - every hour.
	- `CRON_COMMAND="/bin/sh /tmp/update.sh"` Specify custom command to update torrents, e.g. for extended logging. Default: `"php -q /data/htdocs/engine.php"`
	- `PHP_TIMEZONE="Europe/Moscow"` Set default timezone for PHP. Default - UTC.
	- `PHP_MEMORY_LIMIT="512M"` Set php memory limit. Default - 512M.
- if you want guest system to have host's timezone, add `localtime` binding as in the example below.

#### Example:

	docker container run -d \
			--name torrentmonitor \
			--restart unless-stopped \
			-p 8080:80 \
			-v <path_to_torrents_folder>:/data/htdocs/torrents \
			-v <path_to_db_folder>:/data/htdocs/db \
			-v /etc/localtime:/etc/localtime:ro \
			-e PHP_TIMEZONE="Europe/Moscow" \
			-e CRON_TIMEOUT="15 8-23 * * *" \
			-e CRON_COMMAND="/bin/sh /tmp/update.sh" \
			alfonder/torrentmonitor

### Compose
If you prefer using `docker-compose`, create a yaml script file [docker-compose.yml](docker-compose.yml):
```yaml
version: '3'

services:
  torrentmonitor:
    container_name: ${SERVICENAME}
    image: alfonder/torrentmonitor:${TM_TAG}
    restart: unless-stopped
    ports:
      - ${LISTEN_PORT}:80
    volumes:
      - ${DATA_DIR}/torrents:/data/htdocs/torrents
      - ${DATA_DIR}/db:/data/htdocs/db
      - ${DATA_DIR}/logs:/data/htdocs/logs
      - /etc/localtime:/etc/localtime:ro
    environment:
      - PHP_TIMEZONE=${TIMEZONE}
      - CRON_TIMEOUT=${SCHEDULE}
```
and env config file [.env](.env) with your values:
```shell
# Specific image tag
TM_TAG=latest

# Container name to use via CLI
SERVICENAME=torrentmonitor

# Port for web-interface
LISTEN_PORT=8081

# Directory for container's persistent data
DATA_DIR=/media/volume1/data/torrentmonitor

# Service start schedule in Cron format
SCHEDULE="*/30 8-22 * * *"

# TImezone for web-interface
TIMEZONE="Europe/Moscow"
```
then run: 

	docker-compose up -d

### Torrentmonitor + TOR + Transmission
You can do ninja craft to run torrentmonitor with Transmission and TOR together. Use `docker-compose` with [script](examples/docker-compose.yml)

### Additional
The most useful commands - Stop/Start/Restart container:
```bash
docker container stop torrentmonitor
docker container start torrentmonitor
docker container restart torrentmonitor
```

### Version Info
To get the current running container version, you should run command:
```
docker container inspect -f '{{ index .Config.Labels "ru.korphome.version" }}' torrentmonitor
```
## Platform Support
There are images for almost all platform types, supported by Docker:
- x86-64
- x86
- arm64
- arm32
- ppc64le

Next platforms could be added upon request:
- s390x
- mips

If you use a platform that is not supported yet, file an issue. I'll add it ASAP.

## OS Support
### Linux
Linux version uses `docker` directly. You don't have to download any sources or select right platform. Corresponding docker image will be downloaded from DockerHub (or GitHub Registry) automatically.

### Windows and MacOS
You can use Docker Desktop natively for supported OS versions. Minimal requirement:
	
- Windows 10 Professional or Enterprise 64-bit with Hyper-V support
- MacOS Yosemite 10.10.3 or above

Download docker native from https://www.docker.com/products/docker-desktop
