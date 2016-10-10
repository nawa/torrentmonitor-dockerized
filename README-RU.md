Dockerized torrentmonitor
========
Полная информация о проекте - https://github.com/ElizarovEugene/TorrentMonitor

Поддерживаемые трекеры
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

Целью создания докер образа для torrentmonitor было облегчить процесс установки для не очень опытных Linux пользователей, которые не хотят заморачиваться с PHP, базами и прочим. Также решаются возможные проблемы с версиями компонентов приложения. Также в какой-то степени решена проблема установки на  Windows.

Я что-то правлю в PHP во второй раз в жизни, так что если есть какие-то косяки в настройке PHP или Nginx, то пишите предложения

##Linux
Версия для Linux использует `docker` в чистом виде. Все что требуется - это поставить `docker` и выполнить команду. При этом скачается последняя версия образа с `docker hub` и запустится контейнер с работающим приложением

###Использование
1. Установите `docker` https://docs.docker.com/engine/installation/linux/
2. Запустите контейнер с приложением, используя образ `nawa/torrentmonitor`

		sudo docker run -d -p 8080:80 --name=torrentmonitor -v path_to_data_folder/torrents:/DATA/htdocs/torrents -v path_to_data_folder/db:/DATA/htdocs/db nawa/torrentmonitor

	* можно сменить порт с `8080` на более подходящий, если это надо. Порт `80` оставить как есть - это порт внутри контейнера
	* при запуске используются `volumes`. Это что-то наподобие общих директорий между контейнером и хостовой машиной. Здесь два `volume` - один для базы, другой для скачанных торрент файлов. Смысл такой, что их можно использовать для бэкапа данных или если нужно стартануть контейнер с новой версией. Надеюсь это не понадобится, т.к. torrentmonitor обновляется сам, но лучше `volumes` использовать. После запуска контейнера и использования приложения в директориях `path_to_data_folder/torrents` и `path_to_data_folder/db` появятся файлы sqlite базы и файлы скачанных торрентов соответственно. Если все таки они не нужны, то можно просто убрать параметры с `-v`
3. Открываем в браузере [http://localhost:8080](http://localhost:8080)
4. Profit

###Дополнительно
Команду `docker run` нужно выполнить единожды. В случае повторного выполнения создастся еще один контейнер - оно вам надо? Чтобы управлять существующим контейнером, используйте
```bash
sudo docker stop torrentmonitor
sudo docker start torrentmonitor
sudo docker restart torrentmonitor
```
Если совсем интересно что там внутри, то можно зайти внутрь контейнера и посмотреть что там происходит
```bash
docker exec -it torrentmonitor bash
```

Иногда выходят новые версии образа, например правится некоторый баг. Вообще принято, чтобы выходила новая версия образа, если выходит новая версия приложения, но т.к. `torrentmonitor` умеет обновляться сам, то обновлять образ в этом случае особой необходимости нет. Но все таки если это понадобилось, необходимо удалить старый контейнер и срартовать новый, обновить существующий никак нельзя
```bash
sudo docker stop torrentmonitor //останавливаем контейнер
sudo docker rm torrentmonitor	//удаляем его
sudo docker pull nawa/torrentmonitor //обновляем образ
//запускаем новый контейнер как раньше. При этом нам помогут volumes, которые сохранят данные из старого контейнера
sudo docker run -d -p 8080:80 --name=torrentmonitor -v path_to_data_folder/torrents:/usr/share/nginx/html/torrentmonitor/torrents -v path_to_data_folder/db:/usr/share/nginx/html/torrentmonitor/db nawa/torrentmonitor

```

##Windows, Mac
`docker` работает только на Linux, но запустить хочется на Windows. Это можно сделать используя [docker-machine](https://docs.docker.com/engine/installation/windows/), но сделать это не получилось, т.к. не смог побороть проблему с пробросом общих директорий. Поэтому будем использовать `Vagrant` - это менеджер управления виртуальными машинами. Схема будет такая - с помощью `Vagrant` мы стартанем виртуальную машину c Linux, а уже на ней запустим `docker`-контейнер с `torrentmonitor`. При этом в общей директории будут находится файл базы `sqlite` и скачанные торрент-файлы - для бэкапа

###Использование

1. Загрузить этот проект с описанием конфигурации `Vagrant` [torrentmonitor-dockerized.zip](https://github.com/Nawa/torrentmonitor-dockerized/archive/master.zip) и распаковать его куда вам удобно. Можно клонировать проект с помощью `git`, если вам это о чем то говорит `git clone https://github.com/Nawa/torrentmonitor-dockerized.git`
2. Установить `Vagrant` https://www.vagrantup.com/downloads.html
3. Установить `VirtualBox` https://www.virtualbox.org/wiki/Downloads. Именно на нем будет запускаться виртуальная машина, а `Vagrant` лишь управлять ей
4. Открываем командную строку и переходим в директорию, куда распаковывали проект `torrentmonitor-dockerized/windows`. Она должна содержать `Vagrantfile`

		cd torrentmonitor-dockerized/windows
5. Запускаем виртуалку

		vagrant up

	Ждем пока все закончится, это может занять до 10 мин при первом запуске. После того, как стартанет виртуалка, автоматически стартанет необходимый `docker`-контейнер внутри
6. Открываем в браузере [http://localhost:8080](http://localhost:8080)
7. Надеюсь, радуемся

###Дополнительно
Полученную виртуальную машину можно остановить и стартовать заново.
```bash
vagrant halt		//остановить
vagrant reload		//перезагрузить
vagrant suspend		//поставить на паузу. При это освободится оперативка
vagrant resume		//продолжить после паузы
vagrant ssh			//зайти внутрь виртуалки и посмотреть что там
```

Параметры запускаемого сервера и виртуальной машины можно настроить, поредактировав `Vagrantfile`, а затем сделать `reload`. Например можно сменить порт с `8080`, а можно попробовать уменьшить количество выделяемой оперативной памяти.

При использовании приложения файл базы сохранится в директории `torrentmonitor-dockerized/windows/data/db`, а скачанные торренты в `torrentmonitor-dockerized/windows/data/torrents`. Эти пути можно сменить, также поредактировав `Vagrantfile`
```
config.vm.synced_folder "./" .... //заменить "./" например на "D:/torrentmonitor"
```



Если у вас что-то сломается, то можно попробовать ~~выключить/включить~~ сделать две вещи:
* Проинициализировать машину заново. При этом внутри создастся новый контейнер

		vagrant provision

* Если не прошлый пункт не помог, то перезоздаем вообще заново

		vagrant destroy
		vagrant up




##Для связи
Если есть замечания, предложения, то пишите тикеты в github - [https://github.com/Nawa/torrentmonitor-dockerized/issues/new](https://github.com/Nawa/torrentmonitor-dockerized/issues/new) или в ветку на форуме [http://korphome.ru/TorrentMonitor/viewtopic.php?f=7&p=938](http://korphome.ru/TorrentMonitor/viewtopic.php?f=7&p=938)