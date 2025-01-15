<?php
// get_all_data.php
include 'config.php'; // Pastikan file ini berisi koneksi ke database

// Query untuk mengambil semua data dari tabel sensor_data
$query = "SELECT Raindrops, Gas, Datetime FROM sensor_data ORDER BY Datetime DESC";
$result = mysqli_query($koneksi, $query);

if ($result) {
    // Inisialisasi array untuk menyimpan semua data
    $allData = [];

    // Ambil semua baris data dan proses nilai Raindrops dan Gas
    while ($row = mysqli_fetch_assoc($result)) {
        $row['Raindrops'] = ($row['Raindrops'] === 'Hujan') ? 'Ya' : 'Tidak';
        $row['Gas'] = ($row['Gas'] === 'Terdeteksi') ? 'Ya' : 'Tidak';
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
