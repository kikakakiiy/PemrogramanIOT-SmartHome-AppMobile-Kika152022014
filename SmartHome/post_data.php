<?php
header('Access-Control-Allow-Origin: *');
header('Access-Control-Allow-Methods: POST, OPTIONS');
header('Access-Control-Allow-Headers: Content-Type, Accept');
header('Content-Type: application/json');

// Handle preflight OPTIONS request
if ($_SERVER['REQUEST_METHOD'] === 'OPTIONS') {
    http_response_code(204);
    exit();
}

require('libs/phpMQTT.php');

// MQTT Configuration
$config = [
    'server' => 'test.mosquitto.org',
    'port' => 1883,
    'username' => '', // Update if needed
    'password' => '', // Update if needed
    'client_id' => 'php_mqtt_publisher_' . uniqid(),
    'keepalive' => 60,
    'timeout' => 10,
];

// Validate incoming request
function validateRequest() {
    if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
        throw new Exception('Invalid request method');
    }

    $input = file_get_contents('php://input');
    $data = json_decode($input, true);

    if (json_last_error() !== JSON_ERROR_NONE) {
        throw new Exception('Invalid JSON format');
    }

    if (empty($data['topic']) || empty($data['message'])) {
        throw new Exception('Missing required fields: topic and message');
    }

    return $data;
}

// Publish message to MQTT broker
function publishMessage($topic, $message) {
    global $config;

    try {
        $mqtt = new Bluerhinos\phpMQTT(
            $config['server'],
            $config['port'],
            $config['client_id']
        );

        // Connect to MQTT broker
        if (!$mqtt->connect(true, NULL, $config['username'], $config['password'])) {
            throw new Exception('Failed to connect to MQTT broker');
        }

        // Publish message
        $mqtt->publish($topic, $message, 0);
        $mqtt->close();

        return [
            'success' => true,
            'message' => 'Message published successfully',
            'timestamp' => date('c'),
            'data' => [
                'topic' => $topic,
                'message' => $message
            ]
        ];
    } catch (Exception $e) {
        throw new Exception('MQTT Error: ' . $e->getMessage());
    }
}

// Main execution
try {
    // Only process POST requests
    if ($_SERVER['REQUEST_METHOD'] === 'POST') {
        $data = validateRequest();
        
        // Validate message format
        if (!in_array($data['message'], ['ON', 'OFF'])) {
            throw new Exception('Invalid message format. Must be ON or OFF');
        }

        $result = publishMessage($data['topic'], $data['message']);
        echo json_encode($result);
    } else {
        throw new Exception('Invalid request method');
    }
} catch (Exception $e) {
    http_response_code(400);
    echo json_encode([
        'success' => false,
        'message' => $e->getMessage(),
        'timestamp' => date('c')
    ]);
}