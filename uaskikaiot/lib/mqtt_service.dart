// import 'package:mqtt_client/mqtt_client.dart';
// import 'package:mqtt_client/mqtt_server_client.dart';

// class MqttService {
//   late MqttServerClient _client;
//   String broker = 'test.mosquitto.org'; // Alamat broker MQTT
//   String clientId = 'flutter_client'; // Client ID unik
//   int port = 1883; // Port default MQTT
//   Function(String)? onMessageReceived; // Callback untuk pesan yang diterima

//   Future<void> connect(String topic) async {
//     _client = MqttServerClient.withPort(broker, clientId, port);
//     _client.logging(on: true);
//     _client.keepAlivePeriod = 20;

//     // Event handlers
//     _client.onConnected = () {
//       print('Connected to MQTT broker');
//     };
//     _client.onDisconnected = () {
//       print('Disconnected from MQTT broker');
//     };
//     _client.onSubscribed = (String topic) {
//       print('Subscribed to topic: $topic');
//     };

//     try {
//       print('Connecting to broker $broker on port $port...');
//       await _client.connect();
//       if (_client.connectionStatus?.state == MqttConnectionState.connected) {
//         print('Successfully connected to MQTT broker');
//         _client.subscribe(topic, MqttQos.atMostOnce);

//         // Tambahkan listener untuk pesan yang diterima
//         _client.updates
//             ?.listen((List<MqttReceivedMessage<MqttMessage?>>? messages) {
//           final MqttPublishMessage message =
//               messages![0].payload as MqttPublishMessage;
//           final payload =
//               MqttPublishPayload.bytesToStringAsString(message.payload.message);

//           print('Pesan diterima di topik $topic: $payload');
//           // Panggil callback jika diatur
//           if (onMessageReceived != null) {
//             onMessageReceived!(payload);
//           }
//         });
//       } else {
//         print('Connection failed: ${_client.connectionStatus?.state}');
//       }
//     } catch (e) {
//       print('Error while connecting to broker: $e');
//       disconnect();
//     }
//   }

//   // Getter untuk mengekspos status koneksi
//   bool get isConnected {
//     return _client.connectionStatus?.state == MqttConnectionState.connected;
//   }

//   void publish(String topic, String message) {
//     if (_client.connectionStatus?.state == MqttConnectionState.connected) {
//       final builder = MqttClientPayloadBuilder();
//       builder.addString(message);
//       _client.publishMessage(topic, MqttQos.atMostOnce, builder.payload!);
//       print('Pesan dipublish ke topik: $topic dengan payload: $message');
//     } else {
//       print('Gagal mengirim pesan: MQTT belum terhubung');
//       throw Exception('Klien belum terhubung ke broker MQTT');
//     }
//   }

//   void disconnect() {
//     _client.disconnect();
//     print('Disconnected from MQTT broker');
//   }
// }