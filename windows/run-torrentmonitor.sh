#!/bin/bash
isRunning=$(docker inspect -f {{.State.Running}} torrentmonitor)
if [[ "$isRunning" == "false" ]]; then
	docker start torrentmonitor
else
	docker run -d -p 8080:80 --name=torrentmonitor -v /vagrant/data/torrents:/data/htdocs/torrents -v /vagrant/data/db:/data/htdocs/db nawa/torrentmonitor
fi
