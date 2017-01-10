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

##Linux не ARM
Версия для Linux использует `docker` в чистом виде. Все что требуется - это поставить `docker` и выполнить команду. При этом скачается последняя версия образа с `docker hub` и запустится контейнер с работающим приложением

###Использование
1. Установите `docker` https://docs.docker.com/engine/installation/linux/
2. Запустите контейнер с приложением, используя образ `nawa/torrentmonitor`

		sudo docker run -d -p 8080:80 --name=torrentmonitor -v path_to_data_folder/torrents:/DATA/htdocs/torrents -v path_to_data_folder/db:/DATA/htdocs/db nawa/torrentmonitor

	* можно сменить порт с `8080` на более подходящий, если это надо. Порт `80` оставить как есть - это порт внутри контейнера
	* при запуске используются `volumes`. Это что-то наподобие общих директорий между контейнером и хостовой машиной. Здесь два `volume` - один для базы, другой для скачанных торрент файлов. Смысл такой, что их можно использовать для бэкапа данных или если нужно стартануть контейнер с новой версией. Надеюсь это не понадобится, т.к. torrentmonitor обновляется сам, но лучше `volumes` использовать. После запуска контейнера и использования приложения в директориях `path_to_data_folder/torrents` и `path_to_data_folder/db` появятся файлы sqlite базы и файлы скачанных торрентов соответственно. Если все таки они не нужны, то можно просто убрать параметры с `-v`
	* Также можно указать переменные окружения чтобы изменить значения по умолчанию
		*  `-e CRON_TIMEOUT="0 * * * *"` Указать таймаут проверки обновлений торрентов в [кронтаб формате](https://crontab.guru/examples.html). По умолчанию - раз в час
		* `-e PHP_TIMEZONE="Europe/Kiev"` Установить таймзону по умолчанию для PHP. По умолчанию - UTC.
		* `-e PHP_MEMORY_LIMIT="512M"` Установить лимит памяти для PHP. По умолчанию - 512M.

3. Открываем в браузере [http://localhost:8080](http://localhost:8080)
4. Profit

Также можно использовать `docker-compose`.
Если у вас есть установленный `docker-compose` - просто склонируйте этот репозиторий и выполните команду 
	
    docker-compose up -d

Можно посмотреть как запустить torrentmonitor вместе с Transmission и TOR https://github.com/nawa/torrentmonitor-dockerized/wiki/Torrentmonitor---Tramsmission---TOR

###Дополнительно
Команду `docker run` нужно выполнить единожды. В случае повторного выполнения создастся еще один контейнер - оно вам надо? Чтобы управлять существующим контейнером, используйте
```bash
sudo docker stop torrentmonitor
sudo docker start torrentmonitor
sudo docker restart torrentmonitor
```
Если совсем интересно что там внутри, то можно зайти внутрь контейнера и посмотреть что там происходит
```bash
docker exec -it torrentmonitor sh
```

Иногда выходят новые версии образа, например правится некоторый баг. Вообще принято, чтобы выходила новая версия образа, если выходит новая версия приложения, но т.к. `torrentmonitor` умеет обновляться сам, то обновлять образ в этом случае особой необходимости нет. Но все таки если это понадобилось, необходимо удалить старый контейнер и стартовать новый, обновить существующий никак нельзя
```bash
sudo docker stop torrentmonitor //останавливаем контейнер
sudo docker rm torrentmonitor	//удаляем его
sudo docker pull nawa/torrentmonitor //обновляем образ
//запускаем новый контейнер как раньше. При этом нам помогут volumes, которые сохранят данные из старого контейнера
sudo docker run -d -p 8080:80 --name=torrentmonitor -v path_to_data_folder/torrents:/data/htdocs/torrents -v path_to_data_folder/db:/data/htdocs/db nawa/torrentmonitor
```

##Linux ARM
Тоже самое что и обычный Linux, но нужно использовать образ `nawa/armhf-torrentmonitor`

	sudo docker run -d -p 8080:80 --name=torrentmonitor -v path_to_data_folder/torrents:/DATA/htdocs/torrents -v path_to_data_folder/db:/DATA/htdocs/db nawa/armhf-torrentmonitor

##Windows и MacOS
###Docker native
Вы можете использовать нативную версию докера если ваша ОС ее поддерживает
	
* Windows 10 Professional or Enterprise 64-bit с поддержкой Hyper-V
* MacOS Yosemite 10.10.3 и выше

Загрузите docker с https://www.docker.com/products/docker и следуйте инструкциям из части `Linux не ARM`

###Виртуалка с использованием vagrant
Если `docker native` не поддерживается на вашей ОС, то можно поднять с `docker` в виртуальной машине, используя `vagrant` https://github.com/nawa/torrentmonitor-dockerized/wiki/Windows-and-MacOS-Virtual-machine-with-vagrant-(RU)

##Для связи
Если есть замечания, предложения, то пишите тикеты в github - [https://github.com/Nawa/torrentmonitor-dockerized/issues/new](https://github.com/Nawa/torrentmonitor-dockerized/issues/new) или в ветку на форуме [http://korphome.ru/TorrentMonitor/viewtopic.php?f=7&p=938](http://korphome.ru/TorrentMonitor/viewtopic.php?f=7&p=938)
