<?php
header('Access-Control-Allow-Origin: *');
header('Access-Control-Allow-Methods: GET, POST, OPTIONS');
header('Access-Control-Allow-Headers: Content-Type');
header('Content-Type: application/json');

require('libs/phpMQTT.php');

// Konfigurasi MQTT
$server = 'test.mosquitto.org';
$port = 1883;
$username = '';
$password = '';
$client_id = 'php_mqtt_publisher_' . uniqid();

function publishMessage($topic, $message) {
    global $server, $port, $client_id, $username, $password;
    
    $mqtt = new Bluerhinos\phpMQTT($server, $port, $client_id);
    
    if ($mqtt->connect(true, NULL, $username, $password)) {
        $mqtt->publish($topic, $message, 0);
        $mqtt->close();
        return ['success' => true, 'message' => 'Successfully published'];
    }
    
    return ['success' => false, 'message' => 'Failed to connect to MQTT broker'];
}

// Handle incoming HTTP requests
if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $data = json_decode(file_get_contents('php://input'), true);
    
    if (isset($data['topic']) && isset($data['message'])) {
        $result = publishMessage($data['topic'], $data['message']);
        echo json_encode($result);
    } else {
        echo json_encode(['success' => false, 'message' => 'Invalid request data']);
    }
}
?>