<?php
header('Access-Control-Allow-Origin: *');
header('Access-Control-Allow-Methods: GET, POST, OPTIONS');
header('Access-Control-Allow-Headers: Content-Type');
header('Content-Type: application/json');

// get_average_gas_by_day.php
include 'config.php'; // Pastikan file ini berisi koneksi ke database

// Query untuk mengambil rata-rata Gas dan GasValue per hari
$query = "SELECT DATE(Datetime) AS Date, AVG(Gas) AS AverageGas, AVG(GasValue) AS AverageGasValue FROM sensor_data GROUP BY DATE(Datetime) ORDER BY Date DESC";
$result = mysqli_query($koneksi, $query);

if ($result) {
    // Inisialisasi array untuk menyimpan data rata-rata per hari
    $averageData = [];

    // Proses setiap baris hasil query
    while ($row = mysqli_fetch_assoc($result)) {
        $averageData[] = [
            'Date' => $row['Date'],
            'AverageGas' => round($row['AverageGas'], 2), // Pembulatan nilai rata-rata Gas
            'AverageGasValue' => round($row['AverageGasValue'], 2) // Pembulatan nilai rata-rata GasValue
        ];
    }

    // Encode array sebagai JSON dan kirimkan sebagai output
    echo json_encode($averageData);
} else {
    // Tangani error jika query gagal
    echo json_encode(['error' => 'Unable to fetch data']);
}

// Tutup koneksi database
mysqli_close($koneksi);
?>
