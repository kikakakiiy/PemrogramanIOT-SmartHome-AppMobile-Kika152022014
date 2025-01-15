<?php
// get_all_data.php
include 'config.php'; // Pastikan file ini berisi koneksi ke database

// Query untuk mengambil semua data dari tabel sensor_data
$query = "SELECT Temperature, Humidity, Datetime FROM sensor_data ORDER BY Datetime DESC";
$result = mysqli_query($koneksi, $query);

if ($result) {
    // Inisialisasi array untuk menyimpan semua data
    $allData = [];

    // Ambil semua baris data dan simpan ke dalam array
    while ($row = mysqli_fetch_assoc($result)) {
        $allData[] = $row;
    }

    // Encode array sebagai JSON dan kirimkan sebagai output
    echo json_encode($allData);
} else {
    // Tangani error jika query gagal
    echo json_encode(['error' => 'Unable to fetch data']);
}

// Tutup koneksi database
mysqli_close($koneksi);
?>
