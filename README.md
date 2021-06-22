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

## Linux (x86)
Linux version uses `docker` directly. You wouldn't download any sources because docker image will be downloaded from Docker Hub automatically

### Usage
1. Install docker https://docs.docker.com/engine/install/
2. Depending on your system type you need to run `docker` command with `sudo` or add the user to "docker" group
3. Get the container image from DockerHub: 

		docker pull alfonder/torrentmonitor

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
If you prefer using `docker-compose`, download [yaml script](https://github.com/alfonder/torrentmonitor-dockerized/raw/master/docker-compose.yml), edit it with your values and run 

	docker-compose up -d

### Torrentmonitor + TOR + Transmission
You can do ninja craft to run torrentmonitor with Transmission and TOR together. Use `docker-compose` with [script](https://github.com/alfonder/torrentmonitor-dockerized/raw/master/docker-compose.yml)

### Additional
The most useful commands - Stop/Start/Restart container:
```bash
docker container stop torrentmonitor
docker container start torrentmonitor
docker container restart torrentmonitor
```

### Version Info
To get the current running container version, you should run command:

	docker container inspect -f '{{ index .Config.Labels "ru.korphome.version" }}' torrentmonitor

## Linux (ARM)
You can use Torrentmonitor on Raspberry Pi (or similar) Linux box. The method is the same as for x86. Corresponding image for ARM platform will be pulled automatically.

## Windows and MacOS
You can use docker native if your OS supports it
	
- Windows 10 Professional or Enterprise 64-bit with Hyper-V support
- MacOS Yosemite 10.10.3 or above

Download docker native from https://www.docker.com/products/docker
