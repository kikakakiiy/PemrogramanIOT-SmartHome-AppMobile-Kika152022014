<?php
class Database {
    private static $dbName = 'smarthomeiot'; // Ganti dengan nama database
    private static $dbHost = 'localhost';         // Host database
    private static $dbUsername = 'your_username'; // Username database
    private static $dbUserPassword = 'your_password'; // Password database

    private static $cont = null;

    public static function connect() {
        if (null == self::$cont) {
            try {
                self::$cont = new PDO(
                    "mysql:host=" . self::$dbHost . ";dbname=" . self::$dbName, 
                    self::$dbUsername, 
                    self::$dbUserPassword
                );
                self::$cont->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
            } catch (PDOException $e) {
                die('Connection failed: ' . $e->getMessage());
            }
        }
        return self::$cont;
    }

    public static function disconnect() {
        self::$cont = null;
    }
}
?>
