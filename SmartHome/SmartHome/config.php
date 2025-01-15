<?php
// config.php
$host = 'localhost';
$user = 'root';
$password = '';
$dbname = 'smarthome';

// Koneksi ke MySQL
$koneksi = mysqli_connect($host, $user, $password, $dbname);

if (!$koneksi) {
    die("Connection failed: " . mysqli_connect_error());
}
?>