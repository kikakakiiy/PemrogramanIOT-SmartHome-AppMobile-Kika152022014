<?php
// get_avg_data.php
include 'config.php'; // Pastikan file ini berisi koneksi ke database

// Query untuk menghitung rata-rata Temperature dan Humidity per tanggal
$query = "
    SELECT 
        DATE(Datetime) AS Date,
        AVG(Temperature) AS AvgTemperature,
        AVG(Humidity) AS AvgHumidity
    FROM 
        sensor_data
    GROUP BY 
        DATE(Datetime)
    ORDER BY 
        DATE(Datetime) DESC
    LIMIT 7
";

$result = mysqli_query($koneksi, $query);

if ($result) {
    // Ambil data sebagai array asosiatif
    $data = [];
    while ($row = mysqli_fetch_assoc($result)) {
        // Format tanggal ke format "Sat 14 Dec"
        $formattedDate = date("D d M", strtotime($row['Date'])); // Format: "Sat 14 Dec"
        
        // Tambahkan data yang sudah diformat ke array
        $data[] = [
            'Date' => $formattedDate, // Menggunakan tanggal yang sudah diformat
            'AvgTemperature' => $row['AvgTemperature'],
            'AvgHumidity' => $row['AvgHumidity']
        ];
    }
    echo json_encode($data);
} else {
    // Tampilkan pesan error jika query gagal
    echo json_encode(['error' => 'Unable to fetch average data']);
}

mysqli_close($koneksi);
?>
