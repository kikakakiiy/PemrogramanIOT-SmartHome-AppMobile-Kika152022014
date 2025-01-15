<?php
header('Access-Control-Allow-Origin: *'); // Mengizinkan semua domain
header('Access-Control-Allow-Methods: GET, POST, OPTIONS'); // Metode HTTP yang diizinkan
header('Access-Control-Allow-Headers: Content-Type'); // Header yang diizinkan
header('Content-Type: application/json'); // Mengatur header respons sebagai JSON
set_time_limit(0); // Menetapkan waktu eksekusi tidak terbatas

require('libs/phpMQTT.php');

// Konfigurasi MQTT
$server = 'test.mosquitto.org';
$port = 1883;
$username = ''; // Username MQTT jika ada
$password = ''; // Password MQTT jika ada
$client_id = 'php_mqtt_subscriber_' . uniqid(); // ID unik untuk klien

// File JSON untuk menyimpan data
$dataFile = 'mqtt_data.json';

// Daftar topik yang ingin disubscribe
$topics = [
    'tubesprakiot/Temperature' => ['qos' => 0, 'function' => 'onMessage'], 
    'tubesprakiot/Humidity' => ['qos' => 0, 'function' => 'onMessage'], 
    'tubesprakiot/Rain' => ['qos' => 0, 'function' => 'onMessage'],  
    'tubesprakiot/Fan' => ['qos' => 0, 'function' => 'onMessage'],  
    'tubesprakiot/Gas' => ['qos' => 0, 'function' => 'onMessage'], 
    'tubesprakiot/Lamp' => ['qos' => 0, 'function' => 'onMessage']
];

// Membuat instance MQTT
$mqtt = new Bluerhinos\phpMQTT($server, $port, $client_id);

if ($mqtt->connect(true, NULL, $username, $password)) {
    echo "Berhasil terhubung ke broker MQTT.\n";

    // Subscribe ke semua topik yang didefinisikan dalam array
    $mqtt->subscribe($topics);

    // Tetap mendengarkan pesan
    while ($mqtt->proc()) {}

    $mqtt->close();
} else {
    echo "Gagal terhubung ke broker MQTT.\n";
}

// Callback untuk menangani pesan masuk
function onMessage($topic, $msg) {
    global $dataFile;

    // Menampilkan topik dan pesan yang diterima
    echo "Pesan diterima dari topik {$topic}: {$msg}\n";

    // Membaca file JSON untuk menyimpan data baru
    $data = [];
    if (file_exists($dataFile)) {
        $data = json_decode(file_get_contents($dataFile), true);
    }

    // Menambahkan data baru
    $data[] = [
        'topic' => $topic,
        'message' => $msg,
        'timestamp' => date('Y-m-d H:i:s')
    ];

    // Menyimpan data ke file JSON
    file_put_contents($dataFile, json_encode($data, JSON_PRETTY_PRINT | JSON_UNESCAPED_SLASHES), LOCK_EX);


    // Logika tambahan berdasarkan topik
    if ($topic == 'tubesprakiot/Temperature') {
        echo "Data suhu: " . $msg . "°C\n";
    } elseif ($topic == 'tubesprakiot/Humidity') {
        echo "Data kelembaban: " . $msg . "%\n";
    }
}
?>