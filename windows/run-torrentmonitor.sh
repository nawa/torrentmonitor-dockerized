#!/bin/bash
isRunning=$(docker inspect -f {{.State.Running}} torrentmonitor)
if [[ "$isRunning" == "false" ]]; then
	docker start torrentmonitor
else
	docker run -d -p 8080:80 --name=torrentmonitor -v /vagrant/data/torrents:/usr/share/nginx/html/torrentmonitor/torrents -v /vagrant/data/db:/usr/share/nginx/html/torrentmonitor/db nawa/torrentmonitor
fi