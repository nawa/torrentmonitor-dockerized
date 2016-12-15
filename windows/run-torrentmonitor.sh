#!/bin/bash
isRunning=$(docker inspect -f {{.State.Running}} torrentmonitor)
if [[ "$isRunning" == "false" ]]; then
	docker start torrentmonitor
else
	docker run -d -p 8080:80 --name=torrentmonitor -v /vagrant/data/torrents:/DATA/htdocs/torrents -v /vagrant/data/db:/DATA/htdocs/db nawa/torrentmonitor
fi
