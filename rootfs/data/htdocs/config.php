<?php
include_once dirname(__FILE__).'/class/Config.class.php';
Config::extended('/data/htdocs/db/config.xml');

Config::write('db.type', 'sqlite');
Config::write('db.basename', '/data/htdocs/db/tm.sqlite');
?>
