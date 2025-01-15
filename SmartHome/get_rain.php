<?php
header('Access-Control-Allow-Origin: *');
header('Access-Control-Allow-Methods: GET, POST, OPTIONS');
header('Access-Control-Allow-Headers: Content-Type');
header('Content-Type: application/json');

// get_all_data_by_interval.php
include 'config.php'; // Pastikan file ini berisi koneksi ke database

// Query untuk mengambil semua data dari tabel sensor_data, termasuk status hujan
$query = "SELECT Raindrops, Datetime, DATE(Datetime) AS Date FROM sensor_data ORDER BY Datetime DESC";
$result = mysqli_query($koneksi, $query);

if ($result) {
    // Inisialisasi array untuk menyimpan data yang dikelompokkan berdasarkan interval 5 jam
    $groupedData = [];

    // Proses setiap baris hasil query
    while ($row = mysqli_fetch_assoc($result)) {
        $date = $row['Date']; // Ambil tanggal dari kolom Date
        $datetime = $row['Datetime']; // Ambil datetime untuk pengelompokan

        // Hitung interval 5 jam berdasarkan datetime
        $hour = (int)date('H', strtotime($datetime)); // Ambil jam
        $intervalGroup = floor($hour / 5); // Bagi jam ke dalam interval 5 jam

        $intervalLabel = sprintf('%02d:00 - %02d:59', $intervalGroup * 5, ($intervalGroup + 1) * 5 - 1); // Label interval waktu

        unset($row['Date']); // Hilangkan kolom Date dari data

        // Kelompokkan data berdasarkan tanggal dan interval waktu
        if (!isset($groupedData[$date])) {
            $groupedData[$date] = []; // Inisialisasi array untuk tanggal baru
        }
        if (!isset($groupedData[$date][$intervalLabel])) {
            $groupedData[$date][$intervalLabel] = ['total' => 0, 'rain' => 0]; // Inisialisasi array untuk interval baru
        }

        // Hitung jumlah kejadian hujan dalam interval ini
        $groupedData[$date][$intervalLabel]['total'] += 1;
        if ($row['Raindrops'] > 0) {
            $groupedData[$date][$intervalLabel]['rain'] += 1; // Hitung jika ada hujan
        }
    }

    // Hitung probabilitas hujan untuk setiap interval dan beri keterangan
    foreach ($groupedData as $date => $intervals) {
        foreach ($intervals as $intervalLabel => $data) {
            $probability = $data['total'] > 0 ? ($data['rain'] / $data['total']) * 100 : 0;
            $groupedData[$date][$intervalLabel]['probability'] = round($probability, 2); // Probabilitas hujan dalam persen
            
            // Menambahkan keterangan apakah hujan atau tidak
            if ($probability > 50) {
                $groupedData[$date][$intervalLabel]['status'] = 'Hujan';
            } else {
                $groupedData[$date][$intervalLabel]['status'] = 'Tidak Hujan';
            }
        }
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
