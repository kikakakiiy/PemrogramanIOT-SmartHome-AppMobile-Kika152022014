<?php
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: GET, POST, OPTIONS");
header("Access-Control-Allow-Headers: Content-Type, Authorization, X-Requested-With");
header('Content-Type: text/event-stream'); // Gunakan 'text/event-stream' untuk streaming data
header("Cache-Control: no-cache");
header("Connection: keep-alive");

set_time_limit(0); // Waktu eksekusi tak terbatas
while (ob_get_level() > 0) ob_end_flush(); // Hentikan buffering

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
    'tubesprakiot/Gas' => ['qos' => 0, 'function' => 'onMessage']
];

// Membuat instance MQTT
$mqtt = new Bluerhinos\phpMQTT($server, $port, $client_id);

if ($mqtt->connect(true, NULL, $username, $password)) {
    // Subscribe ke semua topik yang didefinisikan dalam array
    $mqtt->subscribe($topics);

    // Tetap mendengarkan pesan dan streaming ke browser
    while ($mqtt->proc()) {}

    $mqtt->close();
} else {
    echo json_encode(['error' => 'Gagal terhubung ke broker MQTT.']);
    exit;
}

// Callback untuk menangani pesan masuk
function onMessage($topic, $msg) {
    global $dataFile;

    // Membaca file JSON untuk menyimpan data baru
    $data = [];
    if (file_exists($dataFile)) {
        $jsonContent = file_get_contents($dataFile);
        $data = json_decode($jsonContent, true) ?? [];
    }

    // Menambahkan data baru
    $newEntry = [
        'topic' => $topic,
        'message' => $msg,
        'timestamp' => date('Y-m-d H:i:s')
    ];
    $data[] = $newEntry;

    // Membatasi data hanya 30 entri terakhir
    if (count($data) > 30) {
        $data = array_slice($data, -30);
    }

    // Menyimpan data ke file JSON
    if (file_put_contents($dataFile, json_encode($data, JSON_PRETTY_PRINT | JSON_UNESCAPED_SLASHES), LOCK_EX) === false) {
        echo json_encode(['error' => 'Gagal menyimpan data ke file.']);
        return;
    }

    // Kirim data ke browser dalam format Server-Sent Events (SSE)
    echo "data: " . json_encode($newEntry, JSON_PRETTY_PRINT | JSON_UNESCAPED_SLASHES) . "\n\n";
    flush(); // Kirim output ke browser
    if (ob_get_level() > 0) ob_flush();
}
?>
