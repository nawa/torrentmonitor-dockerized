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
	* also you can specify environment variabls to change default behaviour of container 
		* -e CRON_TIMEOUT="*/10 * * * *" # Specify execution timeouti in crontab format. Default - every 10 minutes.
		* -e PHP_TIMEZONE="Europe/Kiev" # Set default timezone for PHP. Default - UTC.
		* -e PHP_MEMORY_LIMIT="512M" # Set php memory limit. Default - 512M.

3. Open browser on page [http://localhost:8080](http://localhost:8080)
4. Enjoy

Also you can use docker-compose.
If you have docker-compose installed - just simply clone this repository and run docker-compose up -d

###Additional
Stop/Start/Restart container:
```bash
sudo docker stop torrentmonitor
sudo docker start torrentmonitor
sudo docker restart torrentmonitor
```

##Windows
Windows version uses `vagrant` with `docker` inside because I had problems with shared folders using `docker-machine`.

###Usage

1. Download this project from [torrentmonitor-dockerized.zip](https://github.com/Nawa/torrentmonitor-dockerized/archive/master.zip) or clone it using `git clone https://github.com/Nawa/torrentmonitor-dockerized.git`
2. Install Vagrant https://www.vagrantup.com/downloads.html
3. Install VirtualBox https://www.virtualbox.org/wiki/Downloads
4. Open `cmd` and go to the downloaded directory `torrentmonitor-dockerized/windows` whicn contains Vagrantfile file

		cd torrentmonitor-dockerized/windows
5. Run

		vagrant up

	And wait when the start will be finished
6. Open browser on page [http://localhost:8080](http://localhost:8080)
7. Enjoy

###Additional
Stop/Restart/Pause/Resume vagrant:
```bash
vagrant halt
vagrant reload
vagrant suspend
vagrant resume
```

If you will have critical problems with application you can try one of next
* Recreate application inside vagrant virtual machine by using

		vagrant provision

* Destroy vagrant virtual machine and start again

		vagrant destroy
		vagrant up
