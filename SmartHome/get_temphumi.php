<?php
header('Access-Control-Allow-Origin: *');
header('Access-Control-Allow-Methods: GET, POST, OPTIONS');
header('Access-Control-Allow-Headers: Content-Type');
header('Content-Type: application/json');

// get_average_data_by_5hour_interval.php
include 'config.php'; // Pastikan file ini berisi koneksi ke database

// Query untuk menghitung rata-rata Temperature dan Humidity dalam interval 5 jam
$query = "SELECT 
            DATE(Datetime) AS Date, 
            FLOOR(HOUR(Datetime) / 5) AS IntervalGroup, 
            AVG(Temperature) AS AverageTemperature, 
            AVG(Humidity) AS AverageHumidity 
        FROM sensor_data 
        GROUP BY DATE(Datetime), FLOOR(HOUR(Datetime) / 5) 
        ORDER BY Date DESC, IntervalGroup ASC";
$result = mysqli_query($koneksi, $query);

if ($result) {
    // Inisialisasi array untuk menyimpan data rata-rata per interval 5 jam
    $groupedData = [];

    // Proses setiap baris hasil query
    while ($row = mysqli_fetch_assoc($result)) {
        $date = $row['Date']; // Ambil tanggal dari kolom Date
        $intervalGroup = $row['IntervalGroup']; // Ambil grup interval (0-4, 5-9, dll.)
        $intervalLabel = sprintf('%02d:00 - %02d:59', $intervalGroup * 5, ($intervalGroup + 1) * 5 - 1); // Label interval waktu

        // Kelompokkan data berdasarkan tanggal dan interval waktu
        if (!isset($groupedData[$date])) {
            $groupedData[$date] = []; // Inisialisasi array untuk tanggal baru
        }

        $groupedData[$date][$intervalLabel] = [
            'AverageTemperature' => round($row['AverageTemperature'], 2),
            'AverageHumidity' => round($row['AverageHumidity'], 2)
        ]; // Simpan rata-rata dalam kelompok interval
    }

    // Encode array sebagai JSON dan kirimkan sebagai output
    echo json_encode($groupedData);
} else {
    // Tangani error jika query gagal
    echo json_encode(['error' => 'Unable to fetch data']);
}

// Tutup koneksi database
mysqli_close($koneksi);
?>
