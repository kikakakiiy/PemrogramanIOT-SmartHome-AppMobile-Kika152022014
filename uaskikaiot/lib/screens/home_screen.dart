import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import '../monitoring/monitoring.dart';
import '../product/product.dart';
//import 'package:http/http.dart' as http;
//import 'dart:convert';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';
//import '../services/mqtt_service.dart';

class SensorData {
  final double temperature;
  final double humidity;
  final bool isRaining;
  final String gasStatus;
  
  
  SensorData({
    required this.temperature,
    required this.humidity,
    required this.isRaining,
    required this.gasStatus,
    
  });

  factory SensorData.fromJson(Map<String, dynamic> json) {
    return SensorData(
      temperature: double.parse(json['temperature'] ?? '0'),
      humidity: double.parse(json['humidity'] ?? '0'),
      isRaining: json['isRaining'] == 'Hujan',
      gasStatus: json['gasStatus'] ?? 'Tidak Berbahaya', // Parsing gas status
      
    );
  }

  factory SensorData.initial() {
    return SensorData(
      temperature: 0.0,
      humidity: 0.0,
      isRaining: false,
      gasStatus: 'Tidak Berbahaya',
      
    );
  }
}

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  final List<Widget> _screens = [
    HomeContentScreen(),
    MonitoringPage(),
    ProductScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (_selectedIndex != 0) {
          setState(() {
            _selectedIndex = 0;
          });
          return false;
        }
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            _selectedIndex == 0
                ? "SmartHome"
                : _selectedIndex == 1
                    ? "Monitoring"
                    : "Product",
          ),
          backgroundColor: const Color.fromARGB(255, 221, 227, 255),
          elevation: 0,
          foregroundColor: Colors.black,
          leading: _selectedIndex == 0
              ? null
              : IconButton(
                  icon: Icon(Icons.arrow_back),
                  onPressed: () {
                    setState(() {
                      _selectedIndex = 0;
                    });
                  },
                ),
        ),
        body: _screens[_selectedIndex],
        bottomNavigationBar: CurvedNavigationBar(
          backgroundColor: Colors.transparent,
          color: const Color.fromARGB(255, 206, 215, 255),
          buttonBackgroundColor: Colors.white,
          animationDuration: Duration(milliseconds: 300),
          index: _selectedIndex,
          items: <Widget>[
            Icon(Icons.home, size: 30, color: Colors.black),
            Icon(Icons.cloud, size: 30, color: Colors.black),
            Icon(Icons.settings, size: 30, color: Colors.black),
          ],
          onTap: (index) {
            setState(() {
              _selectedIndex = index;
            });
          },
        ),
      ),
    );
  }
}

class CircularDeviceControl extends StatelessWidget {
  final String title;
  final bool isOn;
  final VoidCallback onToggle;
  final Color onColor;
  final Color offColor;
  final IconData icon;
  final bool isLoading;

  const CircularDeviceControl({
    Key? key,
    required this.title,
    required this.isOn,
    required this.onToggle,
    required this.onColor,
    required this.offColor,
    required this.icon,
    this.isLoading = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isLoading ? null : onToggle,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          SizedBox(height: 10),
          Stack(
            alignment: Alignment.center,
            children: [
              Container(
                height: 100,
                width: 100,
                decoration: BoxDecoration(
                  color: isOn ? onColor : offColor,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.3),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: Icon(
                  icon,
                  size: 40,
                  color: isOn ? Colors.black : Colors.white,
                ),
              ),
              if (isLoading)
                Container(
                  height: 100,
                  width: 100,
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.3),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: CircularProgressIndicator(
                      color: Colors.white,
                    ),
                  ),
                ),
            ],
          ),
          SizedBox(height: 10),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: isOn ? Colors.green[100] : Colors.grey[300],
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              isOn ? "ON" : "OFF",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: isOn ? Colors.green[800] : Colors.grey[800],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class MqttService {
  late MqttServerClient _client;
  String broker = '';
  int port = 1883;
  String clientId = '';
  Function(String topic, String message)? onMessageReceived;

  bool get isConnected => _client.connectionStatus?.state == MqttConnectionState.connected;

  Future<void> connect() async {
    _client = MqttServerClient(broker, clientId);
    _client.port = port;
    _client.logging(on: true);
    _client.keepAlivePeriod = 60;
    _client.onConnected = _onConnected;
    _client.onDisconnected = _onDisconnected;
    _client.onSubscribed = _onSubscribed;

    final connMessage = MqttConnectMessage()
        .withClientIdentifier(clientId)
        .startClean()
        .withWillQos(MqttQos.atLeastOnce);
    
    _client.connectionMessage = connMessage;

    try {
      await _client.connect();
    } catch (e) {
      debugPrint('Exception: $e');
      _client.disconnect();
      throw Exception('MQTT connection failed');
    }

    if (_client.connectionStatus!.state == MqttConnectionState.connected) {
      debugPrint('MQTT client connected');
      _setupMessageListener();
    } else {
      _client.disconnect();
      throw Exception('MQTT connection failed - incorrect status');
    }
  }

  void _setupMessageListener() {
    _client.updates?.listen((List<MqttReceivedMessage<MqttMessage>> messages) {
      for (var message in messages) {
        final recMess = message.payload as MqttPublishMessage;
        final payload = MqttPublishPayload.bytesToStringAsString(recMess.payload.message);
        
        if (onMessageReceived != null) {
          onMessageReceived!(message.topic, payload);
        }
      }
    });
  }

  Future<void> subscribe(String topic, int qos) async {
    if (isConnected) {
      _client.subscribe(topic, MqttQos.values[qos]);
      debugPrint('Subscribed to topic: $topic');
    }
  }

  Future<void> publish(String topic, String message) async {
    if (isConnected) {
      final builder = MqttClientPayloadBuilder();
      builder.addString(message);
      _client.publishMessage(topic, MqttQos.atLeastOnce, builder.payload!);
      debugPrint('Published message to topic: $topic');
    }
  }

  void disconnect() {
    _client.disconnect();
  }

  void _onConnected() {
    debugPrint('Connected to MQTT broker');
  }

  void _onDisconnected() {
    debugPrint('Disconnected from MQTT broker');
  }

  void _onSubscribed(String topic) {
    debugPrint('Subscribed to topic: $topic');
  }
}



class HomeContentScreen extends StatefulWidget {
  @override
  _HomeContentScreenState createState() => _HomeContentScreenState();
}

class _HomeContentScreenState extends State<HomeContentScreen> {
  final MqttService mqttService = MqttService();
  SensorData sensorData = SensorData.initial();
  bool isLightOn = false;
  bool isLoading = false;
  
  // Maintain the API URL for controlling
  //final String apiUrl = 'http://192.168.73.64/SmartHome/post_data.php';

  // MQTT Configuration
  final String mqttServer = 'test.mosquitto.org';
  final int mqttPort = 1883;
  final String clientId = 'flutter_mqtt_${DateTime.now().millisecondsSinceEpoch}';
  
  final List<String> topics = [
    'tubesprakiot/Temperature',
    'tubesprakiot/Humidity',
    'tubesprakiot/Rain',
    'tubesprakiot/Lamp',
    'tubesprakiot/Gas'
    
  ];

  @override
  void initState() {
    super.initState();
    connectToMqtt();
  }

  // Keep the existing toggleLight function for controlling
  // Fungsi toggle lampu yang hanya menggunakan MQTT
  Future<void> toggleLight() async {
    if (isLoading) return;

    setState(() {
      isLoading = true;
    });

    try {
      if (mqttService.isConnected) {
        // Publish pesan MQTT untuk mengontrol lampu
        await mqttService.publish(
          'tubesprakiot/Lamp',
          !isLightOn ? 'ON' : 'OFF'
        );
        
        // Update state langsung setelah publish berhasil
        setState(() {
          isLightOn = !isLightOn;
        });
        _showMessage('Perintah berhasil dikirim', isError: false);
      } else {
        _showMessage('Tidak terhubung ke MQTT broker', isError: true);
      }
    } catch (e) {
      if (!mounted) return;
      _showMessage('Error: ${e.toString()}', isError: true);
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }


  void _showMessage(String message, {bool isError = false}) {
    if (!mounted) return;
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red : Colors.green,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  Future<void> connectToMqtt() async {
  mqttService.broker = mqttServer;
  mqttService.port = mqttPort;
  mqttService.clientId = clientId;

  mqttService.onMessageReceived = (String topic, String message) {
    try {
      setState(() {
        switch (topic) {
          case 'tubesprakiot/Temperature':
            sensorData = SensorData(
              temperature: double.tryParse(message) ?? 0.0,
              humidity: sensorData.humidity,
              isRaining: sensorData.isRaining,
              gasStatus: sensorData.gasStatus,
              
            );
            break;

          case 'tubesprakiot/Humidity':
            sensorData = SensorData(
              temperature: sensorData.temperature,
              humidity: double.tryParse(message) ?? 0.0,
              isRaining: sensorData.isRaining,
              gasStatus: sensorData.gasStatus,
              
            );
            break;

          case 'tubesprakiot/Rain':
            sensorData = SensorData(
              temperature: sensorData.temperature,
              humidity: sensorData.humidity,
              isRaining: message == "Hujan",
              gasStatus: sensorData.gasStatus,
            );
            break;
          
          case 'tubesprakiot/Gas':
            setState(() {
              sensorData = SensorData(
                temperature: sensorData.temperature,
                humidity: sensorData.humidity,
                isRaining: sensorData.isRaining,
                gasStatus: message == "Berbahaya" ? "Berbahaya" : "Tidak Berbahaya",
              );
            });
            print('Gas Status Updated: ${sensorData.gasStatus}'); // Add this for debugging
            break;

        }
      });
    } catch (e) {
      print('Error parsing MQTT message: $e');
    }
  };

  try {
    await mqttService.connect();
    if (mqttService.isConnected) {
      for (String topic in topics) {
        await mqttService.subscribe(topic, 0);
      }
    }
  } catch (e) {
    print('Failed to connect to MQTT: $e');
  }
}


  @override
  void dispose() {
    mqttService.disconnect();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 30),
          _buildWelcomeSection(context),
          SizedBox(height: 40),
          _buildWeatherAndControlsSection(context),
          SizedBox(height: 40),
          _buildHumiditySection(context),
        ],
      ),
    );
  }

  // Rest of the widgets remain the same, just update the CircularDeviceControl usage
  Widget _buildWeatherAndControlsSection(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 2,
          child: _buildWeatherCard(context),
        ),
        SizedBox(width: 20),
        Expanded(
          flex: 1,
          child: CircularDeviceControl(
            title: "Lampu",
            isOn: isLightOn,
            onToggle: toggleLight,
            onColor: Color(0xFFFFF4CE),
            offColor: Colors.grey[800]!,
            icon: Icons.lightbulb_outline,
            isLoading: isLoading,
          ),
        ),
        
      ],
    );
  }

  // Rest of the code remains exactly the same...
  Widget _buildWelcomeSection(BuildContext context) {
    return Container(
      height: 170,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.black),
      ),
      child: Row(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 10.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Welcome to SmartHome',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Control and monitor your home remotely with safety and ease.',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black54,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 10.0),
            child: Image.asset(
              'assets/images/home1.png',
              height: 150,
              width: 150,
              fit: BoxFit.contain,
            ),
          ),
        ],
      ),
    );
  }

  // Update weather card to show real-time temperature and rain status
  Widget _buildWeatherCard(BuildContext context) {
  return Stack(
    clipBehavior: Clip.none,
    children: [
      Container(
        padding: const EdgeInsets.all(20),
        margin: const EdgeInsets.only(left: 40, top: 20),
        width: 200,
        height: 120,
        decoration: BoxDecoration(
          color: Color.fromARGB(255, 9, 45, 75),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.shade400,
              blurRadius: 5,
              offset: Offset(3, 3),
            ),
          ],
        ),
        child: Row(
          children: [
            Spacer(),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '${sensorData.temperature.toStringAsFixed(1)}°C',
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 5),
                Text(
                  sensorData.isRaining ? 'Hujan' : 'Tidak Hujan',
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.white54,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      Positioned(
        top: -50,
        left: -10,
        child: Image.asset(
          sensorData.isRaining 
              ? 'assets/images/awan gerimis.png' 
              : 'assets/images/awangelap.png',
          height: 150,
          width: 150,
          fit: BoxFit.contain,
        ),
      ),
    ],
  );
}


  Widget _buildHumiditySection(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildHumidityCard(context),
        _buildGasSection(context),
      ],
    );
  }

// Update the _buildGasSection to be more compact since we're showing text separately
Widget _buildGasSection(BuildContext context) {
  return Column(
    children: [
      Container(
        padding: EdgeInsets.all(20),
        width: 100,
        height: 100,
        margin: EdgeInsets.only(right: 10),
        decoration: BoxDecoration(
          color: sensorData.gasStatus == 'Berbahaya' 
            ? Colors.red.withOpacity(0.2) 
            : Colors.green.withOpacity(0.2),
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.shade400,
              blurRadius: 5,
              offset: Offset(3, 3),
            ),
          ],
        ),
        child: Center(
          child: Icon(
            Icons.warning,
            size: 50,
            color: sensorData.gasStatus == 'Berbahaya' 
              ? Colors.red 
              : Colors.green,
          ),
        ),
      ),
      SizedBox(height: 10), // Spacing between circle and text
      Align(
        alignment: Alignment.centerLeft, // Mengatur posisi teks ke kiri
        child: Padding(
          padding: EdgeInsets.only(left: 10), // Memberikan sedikit jarak dari kiri
          child: Text(
            sensorData.gasStatus, // Will show "Berbahaya" or "Tidak Berbahaya"
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: sensorData.gasStatus == 'Berbahaya' 
                ? Colors.red 
                : Colors.green,
            ),
          ),
        ),
      ),
    ],
  );
}

  Widget _buildHumidityCard(BuildContext context) {
  // Tentukan gambar berdasarkan nilai kelembaban
  String imagePath = sensorData.humidity > 70 
      ? 'assets/images/tinggi.png' 
      : 'assets/images/rendah.png';

  return Container(
    padding: EdgeInsets.all(20),
    width: 200,
    height: 120,
    margin: EdgeInsets.only(left: 40),
    decoration: BoxDecoration(
      color: Color.fromARGB(255, 43, 44, 93),
      borderRadius: BorderRadius.circular(20),
      boxShadow: [
        BoxShadow(
          color: Colors.grey.shade400,
          blurRadius: 5,
          offset: Offset(3, 3),
        ),
      ],
    ),
    child: Row(
      children: [
        Image.asset(
          imagePath, // Menggunakan gambar yang sesuai
          height: 60,
          width: 60,
          fit: BoxFit.contain,
        ),
        SizedBox(width: 10),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '${sensorData.humidity.toStringAsFixed(1)}', // Menampilkan nilai kelembaban
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 5),
            Text(
              'Humidity (%)', // Label kelembaban
              style: TextStyle(
                fontSize: 15,
                color: Colors.white54,
              ),
            ),
          ],
        ),
      ],
    ),
  );
}
}