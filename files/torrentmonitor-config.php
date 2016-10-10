<?php
class Config
{
    static $confArray;

    public static function read($name)
    {
        return self::$confArray[$name];
    }

    public static function write($name, $value)
    {
        self::$confArray[$name] = $value;
    }
}

#Для SQLite:
Config::write('db.type', 'sqlite');
Config::write('db.basename', '/DATA/htdocs/db/tm.sqlite'); #Указывайте _абсолютный_ путь до файла БД (расширение рекомендуется использовать .sqlite)
?>