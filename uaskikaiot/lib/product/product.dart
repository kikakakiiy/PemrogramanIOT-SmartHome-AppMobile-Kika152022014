import 'package:flutter/material.dart';

class ProductScreen extends StatelessWidget {
  final List<Map<String, String>> products = [
    {
      'title': 'ESP32',
      'description': 'Mikrokontroler yang dilengkapi WiFi dan Bluetooth. Untuk menghubungkan perangkat ke internet dan mengirim data ke server.',
      'image': 'assets/images/esp32.jpg',
    },
    {
      'title': 'DHT22',
      'description': 'Sensor suhu dan kelembaban dengan akurasi tinggi untuk ruang lingkungan.',
      'image': 'assets/images/dht.jfif',
    },
    {
      'title': 'Fingerprint',
      'description': 'Sensor digunakan untuk membuka pintu secara otomatis hanya jika sidik jari yang terdeteksi sesuai dengan data yang terdaftar',
      'image': 'assets/images/finger.jfif',
    },
    {
      'title': 'Doorlock',
      'description': 'Aktuator digunakan untuk membuka pintu secara otomatis hanya jika sidik jari yang terdeteksi sesuai dengan data yang terdaftar',
      'image': 'assets/images/doorlock.jpg',
    },
    {
      'title': 'RainDrops Sensor',
      'description': 'Sensor yang mendeteksi keberadaan air hujan.',
      'image': 'assets/images/rain.jfif',
    },
    {
      'title': 'Sensor Gas',
      'description': 'Mendeteksi keberadaan gas berbahaya di rumah.',
      'image': 'assets/images/gas.jpg',
    },
    {
      'title': 'Motor Stepper',
      'description': 'Aktuator untuk menarik jemuran secara otomatis saat hujan terdeteksi oleh sensor hujan.',
      'image': 'assets/images/stepper.jfif',
    },
    {
      'title': 'Kipas Dc 12v',
      'description': 'Aktuator sebagai pendingin otomatis yang aktif berdasarkan suhu yang terdeteksi oleh DHT22.',
      'image': 'assets/images/fan.jfif',
    },
    {
      'title': 'LED',
      'description': 'Aktuator sebagai penerangan yang dapat dinyalakan dan dimatikan melalui controlling.',
      'image': 'assets/images/led.jfif',
    },
    {
      'title': 'Relay',
      'description': 'Untuk mengendalikan perangkat listrik atau beban berdaya tinggi dengan menggunakan sinyal berdaya rendah dari mikrokontroler.',
      'image': 'assets/images/relay.PNG',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'WHAT DOES OUR PRODUCT CONSIST OF?',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            ...products.map((product) => ProductCard(
                  title: product['title']!,
                  description: product['description']!,
                  imageUrl: product['image']!,
                )),
          ],
        ),
      ),
    );
  }
}

class ProductCard extends StatelessWidget {
  final String title;
  final String description;
  final String imageUrl;

  ProductCard({
    required this.title,
    required this.description,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      color: const Color.fromARGB(255, 176, 195, 236), 
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            // Menampilkan gambar lokal menggunakan Image.asset
            Image.asset(imageUrl, width: 80, height: 80, fit: BoxFit.cover),
            SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    description,
                    style: TextStyle(fontSize: 14),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
