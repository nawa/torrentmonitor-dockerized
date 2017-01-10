Dockerized torrentmonitor
========
[[RU]](./README-RU.md)

Info about project - https://github.com/ElizarovEugene/TorrentMonitor

Supported torrent trackers
* anidub.com
* animelayer.ru
* casstudio.tv
* kinozal.tv
* nnm-club.ru
* rustorka.com
* rutracker.org
* rutor.org
* tfile.me
* tracker.0day.kiev.ua
* tv.mekc.info
* baibako.tv
* hamsterstudio.org
* lostfilm.tv
* newstudio.tv
* novafilm.tv

##Linux non ARM
Linux version uses `docker` directly. You wouldn't download any sources because docker image will be downloaded from docker hub automatically

###Usage
1. Install docker https://docs.docker.com/engine/installation/linux/
2. Run container from `nawa/torrentmonitor` image

		sudo docker run -d --name torrentmonitor --restart=always -p 8080:80 -v path_to_data_folder/torrents:/data/htdocs/torrents -v path_to_data_folder/db:/data/htdocs/db nawa/torrentmonitor

	* you can change server port from `8080` to your preferred port
	* you need to change volume location to database and downloaded torrents. As a result you could use persistent data between another containers
	* also you can specify environment variables to change default behaviour of container 
		* `-e CRON_TIMEOUT="0 * * * *"` Specify execution timeout in [crontab format](https://crontab.guru/examples.html). Default - every hour.
		* `-e PHP_TIMEZONE="Europe/Kiev"` Set default timezone for PHP. Default - UTC.
		* `-e PHP_MEMORY_LIMIT="512M"` Set php memory limit. Default - 512M.

3. Open browser on page [http://localhost:8080](http://localhost:8080)
4. Enjoy

Also you can use `docker-compose`.
If you have `docker-compose` installed - just simply clone this repository and run 
	
    docker-compose up -d
    
You can look how to run torrentmonitor with Transmission and TOR together https://github.com/nawa/torrentmonitor-dockerized/wiki/Torrentmonitor---Tramsmission---TOR

###Additional
Stop/Start/Restart container:
```bash
sudo docker stop torrentmonitor
sudo docker start torrentmonitor
sudo docker restart torrentmonitor
```

##Linux ARM
The same as non ARM Linux but you have to use armhf image `nawa/armhf-torrentmonitor`

	sudo docker run -d --name torrentmonitor --restart=always -p 8080:80 -v path_to_data_folder/torrents:/data/htdocs/torrents -v path_to_data_folder/db:/data/htdocs/db nawa/armhf-torrentmonitor

##Windows and MacOS
###Docker native
You can use docker native if your OS supports it
	
* Windows 10 Professional or Enterprise 64-bit with Hyper-V support
* MacOS Yosemite 10.10.3 or above

Download docker native from https://www.docker.com/products/docker and follow instructions for paragraph `Linux non ARM
`
###Virtual machine with vagrant
If your OS doesn't support docker native you can use virtual machine with vagrant. https://github.com/nawa/torrentmonitor-dockerized/wiki/Windows-and-MacOS---Virtual-machine-with-vagrant-(EN)
