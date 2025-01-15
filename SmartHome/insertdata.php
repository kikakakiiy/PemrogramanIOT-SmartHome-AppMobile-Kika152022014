<?php
// Konfigurasi database
$servername = "localhost"; // Ganti dengan hostname server database Anda
$username = "root"; // Ganti dengan username database Anda
$password = ""; // Ganti dengan password database Anda
$dbname = "smarthomeiot"; // Ganti dengan nama database Anda

// Membuat koneksi ke database
$conn = new mysqli($servername, $username, $password, $dbname);

// Cek koneksi
if ($conn->connect_error) {
    die("Koneksi gagal: " . $conn->connect_error);
}

// Mendapatkan data dari request
$temperature = isset($_POST['temperature']) ? $_POST['temperature'] : null;
$humidity = isset($_POST['humidity']) ? $_POST['humidity'] : null;
$fan = isset($_POST['fan']) ? $_POST['fan'] : null;
$gas = isset($_POST['gas']) ? $_POST['gas'] : null;
$lampu = isset($_POST['lampu']) ? $_POST['lampu'] : null;
$pintu = isset($_POST['pintu']) ? $_POST['pintu'] : null;
$raindrops = isset($_POST['raindrops']) ? $_POST['raindrops'] : null;
$gasvalue = isset($_POST['gasvalue']) ? $_POST['gasvalue'] : null;
$datetime = date('Y-m-d H:i:s'); // Waktu saat data diterima

// Validasi data
if ($temperature !== null && $humidity !== null && $fan !== null && $gas !== null && $lampu !== null && $pintu !== null && $raindrops !== null && $gasvalue !== null) {
    // Query untuk memasukkan data ke tabel
    $sql = "INSERT INTO sensor_data (Temperature, Humidity, Fan, Gas, Lampu, Pintu, Raindrops, GasValue, Datetime)
            VALUES ('$temperature', '$humidity', '$fan', '$gas', '$lampu', '$pintu', '$raindrops', '$gasvalue', '$datetime')";
    
    // Eksekusi query
    if ($conn->query($sql) === TRUE) {
        echo "Data berhasil dimasukkan!";
    } else {
        echo "Error: " . $sql . "<br>" . $conn->error;
    }
} else {
    echo "Data tidak lengkap!";
}

// Menutup koneksi
$conn->close();
?>
