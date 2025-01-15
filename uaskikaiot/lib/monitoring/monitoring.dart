import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:http/http.dart' as http;
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';
import 'dart:convert';
import 'dart:async';
import 'package:intl/intl.dart';
import 'dart:math' as math;
import 'dart:io';


class ChartData {
  final String date;
  final double value;
  final String timeRange;

  ChartData(this.date, this.value, this.timeRange);
}

class DataService {
  static Map<String, dynamic> tempHumiData = {};
  static Map<String, dynamic> rainData = {};
  static List<dynamic> gasData = [];

  static Future<void> fetchTempHumiData() async {
    try {
      final response = await http
          .get(Uri.parse('http://192.168.64.64/SmartHome/get_temphumi.php'))
          .timeout(const Duration(seconds: 30)); // Increased timeout only
      
      if (response.statusCode == 200) {
        tempHumiData = json.decode(response.body);
      } else {
        throw Exception('Server returned status code: ${response.statusCode}');
      }
    } catch (e) {
      if (e is TimeoutException) {
        throw Exception('Connection timed out. Please check your network connection and server status.');
      } else if (e is SocketException) {
        throw Exception('Network error. Please check if the server is accessible and running.');
      }
      throw Exception('Error fetching temperature and humidity data: $e');
    }
  }

  static Future<void> fetchRainData() async {
    try {
      final response = await http
          .get(Uri.parse('http://192.168.64.64/SmartHome/get_rain.php'))
          .timeout(const Duration(seconds: 30)); // Increased timeout only
      
      if (response.statusCode == 200) {
        rainData = json.decode(response.body);
      } else {
        throw Exception('Server returned status code: ${response.statusCode}');
      }
    } catch (e) {
      if (e is TimeoutException) {
        throw Exception('Connection timed out. Please check your network connection and server status.');
      } else if (e is SocketException) {
        throw Exception('Network error. Please check if the server is accessible and running.');
      }
      throw Exception('Error fetching rain data: $e');
    }
  }

  static Future<void> fetchGasData() async {
    try {
      final response = await http
          .get(Uri.parse('http://192.168.64.64/SmartHome/get_gas.php'))
          .timeout(const Duration(seconds: 30)); // Increased timeout only
      
      if (response.statusCode == 200) {
        gasData = json.decode(response.body);
      } else {
        throw Exception('Server returned status code: ${response.statusCode}');
      }
    } catch (e) {
      if (e is TimeoutException) {
        throw Exception('Connection timed out. Please check your network connection and server status.');
      } else if (e is SocketException) {
        throw Exception('Network error. Please check if the server is accessible and running.');
      }
      throw Exception('Error fetching gas data: $e');
    }
  }
}

class TempHumiChart extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final data = DataService.tempHumiData;
    List<ChartData> tempData = [];
    List<ChartData> humiData = [];
    
    // Process only the last 20 data points
    var sortedDates = data.keys.toList()..sort((a, b) => b.compareTo(a));
    var recentDates = sortedDates.take(20).toList();

    double latestTemp = 0;
    double latestHumi = 0;
    String latestDateTime = '';

    for (var date in recentDates) {
      if (date.isNotEmpty && data[date] is Map<String, dynamic>) {
        var dayData = data[date] as Map<String, dynamic>;
        var timeRanges = dayData.keys.toList()..sort((a, b) => b.compareTo(a));
        
        for (var timeRange in timeRanges) {
          var values = dayData[timeRange];
          if (values is Map<String, dynamic> &&
              values['AverageTemperature'] != null &&
              values['AverageHumidity'] != null) {
            try {
              var temp = double.parse(values['AverageTemperature'].toString());
              var humi = double.parse(values['AverageHumidity'].toString());
              
              // Store latest values for the summary
              if (latestDateTime.isEmpty) {
                latestTemp = temp;
                latestHumi = humi;
                latestDateTime = '$date $timeRange';
              }

              tempData.add(ChartData(date, temp, timeRange));
              humiData.add(ChartData(date, humi, timeRange));
            } catch (e) {
              print('Error parsing data for date $date: $e');
            }
          }
        }
      }
    }

    return Column(
      children: [
        // Summary Cards
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Expanded(
                child: Card(
                  elevation: 4,
                  color: Colors.red[50],
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Temperature',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          '${latestTemp.toStringAsFixed(1)}°C',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.red,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(width: 16),
              Expanded(
                child: Card(
                  elevation: 4,
                  color: Colors.blue[50],
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Humidity',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          '${latestHumi.toStringAsFixed(1)}%',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        
        // Chart
        Container(
          height: 300, 
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Container(
              width: math.max(MediaQuery.of(context).size.width, 20 * 100.0),
              padding: const EdgeInsets.all(16),
              child: SfCartesianChart(
                primaryXAxis: CategoryAxis(
                  labelRotation: 0, // Changed from 45 to 0
                  labelIntersectAction: AxisLabelIntersectAction.wrap,
                  majorGridLines: MajorGridLines(width: 0),
                ),
                primaryYAxis: NumericAxis(
                  majorGridLines: MajorGridLines(width: 0.5),
                ),
                legend: Legend(
                  isVisible: true,
                  position: LegendPosition.top,
                ),
                tooltipBehavior: TooltipBehavior(enable: true),
                series: <ChartSeries>[
                  LineSeries<ChartData, String>(
                    name: 'Temperature (°C)',
                    dataSource: tempData,
                    xValueMapper: (ChartData data, _) => 
                        '${data.date.substring(5)} ${data.timeRange}',
                    yValueMapper: (ChartData data, _) => data.value,
                    color: Colors.red,
                    markerSettings: const MarkerSettings(
                      isVisible: true,
                      height: 8,
                      width: 8,
                    ),
                    dataLabelSettings: const DataLabelSettings(
                      isVisible: true,
                      labelAlignment: ChartDataLabelAlignment.top,
                    ),
                  ),
                  LineSeries<ChartData, String>(
                    name: 'Humidity (%)',
                    dataSource: humiData,
                    xValueMapper: (ChartData data, _) => 
                        '${data.date.substring(5)} ${data.timeRange}',
                    yValueMapper: (ChartData data, _) => data.value,
                    color: Colors.blue,
                    markerSettings: const MarkerSettings(
                      isVisible: true,
                      height: 8,
                      width: 8,
                    ),
                    dataLabelSettings: const DataLabelSettings(
                      isVisible: true,
                      labelAlignment: ChartDataLabelAlignment.top,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class RainChart extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final data = DataService.rainData;
    List<ChartData> rainData = [];
    
    // Get all dates and sort them
    var sortedDates = data.keys.where((key) => key.isNotEmpty).toList()
      ..sort((a, b) => b.compareTo(a));

    double latestProbability = 0;
    String latestStatus = '';
    String latestDateTime = '';
    
    // Process each date
    for (var date in sortedDates) {
      if (data[date] is Map<String, dynamic>) {
        var dayData = data[date] as Map<String, dynamic>;
        // Get and sort time ranges for each date
        var timeRanges = dayData.keys.toList()
          ..sort((a, b) => a.compareTo(b)); // Sort time ranges chronologically
        
        // Process each time range
        for (var timeRange in timeRanges) {
          var values = dayData[timeRange];
          if (values is Map<String, dynamic> && values['probability'] != null) {
            try {
              var probability = double.parse(values['probability'].toString());
              var status = values['status'] ?? '';
              
              // Store latest values for the summary
              if (latestDateTime.isEmpty) {
                latestProbability = probability;
                latestStatus = status;
                latestDateTime = '$date $timeRange';
              }

              // Create formatted date-time label with date on top and time below
              String formattedDate = '${date.substring(5)}\n${timeRange.split(" ")[0]}'; // Shows MM-DD and time below

              rainData.add(ChartData(formattedDate, probability, status));
            } catch (e) {
              print('Error parsing rain data for date $date, time $timeRange: $e');
            }
          }
        }
      }
    }

    return Column(
      children: [
        // Summary Card
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Card(
            elevation: 4,
            color: Colors.blue[50],
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Rain Percentage',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            '${latestProbability.toStringAsFixed(1)}%',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.blue,
                            ),
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            'Status',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            latestStatus,
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.blue,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
        
        // Chart
        Container(
          height: 300,
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Container(
              width: math.max(MediaQuery.of(context).size.width, rainData.length * 80.0), // Adjusted width calculation
              padding: const EdgeInsets.all(16),
              child: SfCartesianChart(
                primaryXAxis: CategoryAxis(
                  labelRotation: 0, // No rotation, labels are now stacked
                  labelIntersectAction: AxisLabelIntersectAction.none,
                  majorGridLines: MajorGridLines(width: 0),
                ),
                primaryYAxis: NumericAxis(
                  majorGridLines: MajorGridLines(width: 0.5),
                  minimum: 0,
                  maximum: 100,
                  interval: 20, // Added interval for better readability
                ),
                legend: Legend(
                  isVisible: true,
                  position: LegendPosition.top,
                ),
                tooltipBehavior: TooltipBehavior(
                  enable: true,
                  format: 'Time: point.x\nProbability: point.y%',
                ),
                series: <ChartSeries>[
                  ColumnSeries<ChartData, String>(
                    name: 'Rain Probability',
                    dataSource: rainData,
                    xValueMapper: (ChartData data, _) => data.date,
                    yValueMapper: (ChartData data, _) => data.value,
                    pointColorMapper: (ChartData data, _) {
                      if (data.value == 0) {
                        return Colors.red;
                      } else if (data.value == 50) {
                        return Colors.yellow;
                      } else if (data.value > 50) {
                        return Colors.green[200]; // Pastel green
                      }
                      return Colors.blue[300];
                    },
                    dataLabelSettings: const DataLabelSettings(
                      isVisible: true,
                      labelAlignment: ChartDataLabelAlignment.top,
                      angle: 0,
                    ),
                    width: 0.8,
                    spacing: 0.2,
                  )
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}


class GasChart extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Ambil data dari DataService dengan null safety
    final data = DataService.gasData ?? <Map<String, dynamic>>[];
    List<ChartData> gasData = [];

    double latestGasValue = 0;
    String latestDateTime = 'Unknown';

    if (data.isNotEmpty) {
      // Pastikan data diurutkan berdasarkan tanggal
      try {
        data.sort((a, b) {
          final dateA = DateTime.tryParse(a['Date'] ?? '') ?? DateTime(1970);
          final dateB = DateTime.tryParse(b['Date'] ?? '') ?? DateTime(1970);
          return dateA.compareTo(dateB);
        });

        // Ambil data terbaru
        final latestEntry = data.last;
        if (latestEntry['Date'] != null && latestEntry['AverageGasValue'] != null) {
          latestGasValue =
              double.tryParse(latestEntry['AverageGasValue'].toString()) ?? 0;
          latestDateTime = latestEntry['Date'].toString();
        }
      } catch (e) {
        print('Error sorting data: $e');
      }
    }

    // Ambil maksimal 20 data terbaru untuk grafik
    for (var item in data.reversed.take(20)) {
      if (item['Date'] == null || item['AverageGasValue'] == null) continue;
      try {
        final gasValue = double.tryParse(item['AverageGasValue'].toString()) ?? 0;
        gasData.add(ChartData(
          item['Date'].toString(),
          gasValue,
          '',
        ));
      } catch (e) {
        print('Error parsing gas data: $e');
      }
    }

    // Fungsi untuk menentukan status gas
    String getGasStatus(double value) {
      if (value == 0) return 'No Gas';
      if (value < 200) return 'Normal';
      if (value < 400) return 'Moderate';
      if (value < 600) return 'High';
      return 'Dangerous';
    }

    // Fungsi untuk menentukan warna status gas
    Color getStatusColor(double value) {
      if (value == 0) return Colors.red;
      if (value < 200) return Colors.green;
      if (value < 400) return Colors.orange;
      if (value < 600) return Colors.deepOrange;
      return Colors.red;
    }

    String currentStatus = getGasStatus(latestGasValue);
    Color statusColor = getStatusColor(latestGasValue);

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Card(
            elevation: 4,
            color: Colors.purple[50],
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Latest Gas Level',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  SizedBox(height: 8),
                  Text(
                    '$latestGasValue ($currentStatus)',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: statusColor,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Date: $latestDateTime',
                    style: TextStyle(fontSize: 16, color: Colors.black87),
                  ),
                ],
              ),
            ),
          ),
        ),

        Container(
          height: 300,
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Container(
              width: math.max(MediaQuery.of(context).size.width, 20 * 80.0),
              padding: const EdgeInsets.all(16),
              child: SfCartesianChart(
                primaryXAxis: CategoryAxis(
                  labelRotation: 0,
                  labelIntersectAction: AxisLabelIntersectAction.wrap,
                  majorGridLines: MajorGridLines(width: 0),
                ),
                primaryYAxis: NumericAxis(
                  majorGridLines: MajorGridLines(width: 0.5),
                ),
                legend: Legend(
                  isVisible: true,
                  position: LegendPosition.top,
                ),
                tooltipBehavior: TooltipBehavior(enable: true),
                series: <ChartSeries<ChartData, String>>[
                  LineSeries<ChartData, String>(
                    name: 'Gas Value',
                    dataSource: gasData,
                    xValueMapper: (ChartData data, _) => data.date.substring(5),
                    yValueMapper: (ChartData data, _) => data.value,
                    color: Colors.purple,
                    markerSettings: MarkerSettings(
                      isVisible: true,
                      height: 8,
                      width: 8,
                    ),
                    dataLabelSettings: DataLabelSettings(
                      isVisible: true,
                      labelAlignment: ChartDataLabelAlignment.top,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}


class StreamingCharts extends StatefulWidget {
  @override
  _StreamingChartsState createState() => _StreamingChartsState();
}

class _StreamingChartsState extends State<StreamingCharts> {
  MqttServerClient? client;
  final String broker = 'test.mosquitto.org';
  final int port = 1883;
  final String clientId = 'flutter_client${DateTime.now().millisecondsSinceEpoch}';

  static const int maxDataPoints = 15;
  List<LiveData> temperatureData = [];
  List<LiveData> humidityData = [];
  List<LiveData> rainData = [];
  List<LiveData> gasData = [];
  
  ChartSeriesController? temperatureController;
  ChartSeriesController? humidityController;
  ChartSeriesController? rainController;
  ChartSeriesController? gasController;

  bool isConnected = false;

  @override
  void initState() {
    super.initState();
    setupMqttClient();
    
  }

  Future<void> setupMqttClient() async {
    client = MqttServerClient(broker, clientId);
    client!.port = port;
    client!.logging(on: false);
    client!.keepAlivePeriod = 60;
    client!.onConnected = onConnected;
    client!.onDisconnected = onDisconnected;
    client!.onSubscribed = onSubscribed;
    client!.pongCallback = pong;

    final connMessage = MqttConnectMessage()
        .withClientIdentifier(clientId)
        .keepAliveFor(60)
        .withWillQos(MqttQos.atMostOnce);
    client!.connectionMessage = connMessage;

    try {
      await client!.connect();
    } catch (e) {
      print('Exception: $e');
      client!.disconnect();
    }
  }

  void onConnected() {
    print('Connected to MQTT Broker');
    setState(() => isConnected = true);
    
    client!.subscribe('tubesprakiot/Temperature', MqttQos.atMostOnce);
    client!.subscribe('tubesprakiot/Humidity', MqttQos.atMostOnce);

    client!.updates!.listen((List<MqttReceivedMessage<MqttMessage>> c) {
      final MqttPublishMessage message = c[0].payload as MqttPublishMessage;
      final payload = MqttPublishPayload.bytesToStringAsString(message.payload.message);
      
      try {
        updateData(c[0].topic, double.parse(payload));
      } catch (e) {
        print('Error processing MQTT message: $e');
      }
    });
  }

  void updateData(String topic, double value) {
  if (!mounted) return;

  final time = DateTime.now();
  setState(() {
    switch (topic) {
      case 'tubesprakiot/Temperature':
        temperatureData.add(LiveData(time, value));
        if (temperatureData.length > maxDataPoints) {
          temperatureData.removeAt(0);
          temperatureController?.updateDataSource(
            addedDataIndex: temperatureData.length - 1,
            removedDataIndex: 0,
          );
        }
        break;
      case 'tubesprakiot/Humidity':
        humidityData.add(LiveData(time, value));
        if (humidityData.length > maxDataPoints) {
          humidityData.removeAt(0);
          humidityController?.updateDataSource(
            addedDataIndex: humidityData.length - 1,
            removedDataIndex: 0,
          );
        }
        break;
    }
  });
}

  void onDisconnected() {
    print('Disconnected from MQTT Broker');
    setState(() => isConnected = false);
  }

  void onSubscribed(String topic) {
    print('Subscribed to topic: $topic');
  }

  void pong() {
    print('Ping response received');
  }

  @override
  void dispose() {
    client?.disconnect();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          if (!isConnected)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Card(
                color: Colors.red[100],
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Icon(Icons.error_outline, color: Colors.red),
                      const SizedBox(width: 8),
                      Text('Disconnected from MQTT Broker'),
                      const Spacer(),
                      ElevatedButton(
                        onPressed: setupMqttClient,
                        child: Text('Reconnect'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          buildChart(
            'Temperature (°C)',
            temperatureData,
            const Color.fromARGB(255, 48, 48, 95),
            (ChartSeriesController controller) => temperatureController = controller,
          ),
          buildChart(
            'Humidity (%)',
            humidityData,
            const Color.fromARGB(255, 132, 92, 136),
            (ChartSeriesController controller) => humidityController = controller,
          ),
        ],
      ),
    );
  }

  Widget buildChart(
    String title,
    List<LiveData> data,
    Color color,
    Function(ChartSeriesController) onRendererCreated,
  ) {
    return Container(
      height: 200,
      padding: const EdgeInsets.all(8),
      child: Card(
        elevation: 4,
        color: const Color.fromARGB(255, 255, 237, 240),
        child: SfCartesianChart(
          title: ChartTitle(text: title),
          legend: Legend(isVisible: true),
          tooltipBehavior: TooltipBehavior(enable: true),
          
          series: <ChartSeries>[
            LineSeries<LiveData, DateTime>(
              onRendererCreated: onRendererCreated,
              dataSource: data,
              color: color,
              name: title,
              xValueMapper: (LiveData data, _) => data.time,
              yValueMapper: (LiveData data, _) => data.value,
              animationDuration: 0,

              markerSettings: MarkerSettings(
                isVisible: true,
                height: 8,
                width: 8,
                shape: DataMarkerType.circle,
                borderWidth: 2,
                borderColor: color,
              ),

              dataLabelSettings: DataLabelSettings(
                isVisible: true,
                labelAlignment: ChartDataLabelAlignment.top,
                textStyle: TextStyle(
                  color: Colors.black,
                  fontSize: 10,
                ),
              ),

            ),
          ],
          primaryXAxis: DateTimeAxis(
            majorGridLines: const MajorGridLines(width: 0),
            edgeLabelPlacement: EdgeLabelPlacement.shift,
            intervalType: DateTimeIntervalType.seconds,
            autoScrollingDelta: maxDataPoints, // Set to match our max data points
            autoScrollingMode: AutoScrollingMode.end,
            dateFormat: DateFormat.Hms(), 
          ),
          primaryYAxis: NumericAxis(
            majorGridLines: const MajorGridLines(width: 0),
            axisLine: const AxisLine(width: 0),
          ),
        ),
      ),
    );
  }
}

class LiveData {
  final DateTime time;
  final double value;
  
  LiveData(this.time, this.value);
}

class MonitoringPage extends StatefulWidget {
  @override
  _MonitoringPageState createState() => _MonitoringPageState();
}

class _MonitoringPageState extends State<MonitoringPage> {
  int _selectedIndex = 0;
  Timer? _timer;
  late Future<void> _dataFuture;
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _dataFuture = _fetchDataWithErrorHandling();
    _startPeriodicFetch();
  }

  void _startPeriodicFetch() {
    _timer = Timer.periodic(const Duration(seconds: 30), (timer) {
      if (!_isLoading) {
        setState(() {
          _dataFuture = _fetchDataWithErrorHandling();
        });
      }
    });
  }

  Future<void> _fetchDataWithErrorHandling() async {
    if (_isLoading) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      await Future.wait([
        DataService.fetchTempHumiData(),
        DataService.fetchRainData(),
        DataService.fetchGasData(),
      ]);
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to fetch data: $e';
      });
      throw Exception(_errorMessage);
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  Widget _buildTab(String text, int index) {
    bool isSelected = _selectedIndex == index;
    
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedIndex = index;
        });
      },
      child: Container(
        margin: const EdgeInsets.only(right: 24),
        padding: const EdgeInsets.only(bottom: 8),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: isSelected ? Colors.purple : Colors.transparent,
              width: 2,
            ),
          ),
        ),
        child: Text(
          text,
          style: TextStyle(
            color: isSelected ? Colors.purple : Colors.black87,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  Widget _buildErrorWidget(String error) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, color: Colors.red, size: 48),
            const SizedBox(height: 16),
            Text(
              error,
              style: TextStyle(color: Colors.red),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: () {
                setState(() {
                  _dataFuture = _fetchDataWithErrorHandling();
                });
              },
              icon: Icon(Icons.refresh),
              label: Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          color: const Color.fromARGB(255, 228, 234, 252),
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    _buildTab("Streaming", 0),
                    _buildTab("Temperature & Humidity", 1),
                    _buildTab("Raindrops", 2),
                    _buildTab("Gas", 3),
                  ],
                ),
              ),
            ],
          ),
        ),
        if (_isLoading && _selectedIndex != 0)
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: LinearProgressIndicator(),
          ),
        Expanded(
          child: FutureBuilder<void>(
            future: _dataFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting && _selectedIndex != 0) {
                return const Center(child: CircularProgressIndicator());
              }
              
              if (snapshot.hasError || _errorMessage != null) {
                return _buildErrorWidget(_errorMessage ?? snapshot.error.toString());
              }

              final List<Widget> tabContents = [
                StreamingCharts(),
                TempHumiChart(),
                RainChart(),
                GasChart(),
              ];

              return tabContents[_selectedIndex];
            },
          ),
        ),
      ],
    );
  }
}