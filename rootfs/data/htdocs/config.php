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
Config::write('db.type', 'sqlite');
Config::write('db.basename', '/data/htdocs/db/tm.sqlite');
?>
