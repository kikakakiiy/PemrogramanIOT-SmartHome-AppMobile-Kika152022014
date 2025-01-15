<?php
// Sertakan file konfigurasi database
include 'config.php';

// Periksa apakah metode request adalah POST untuk update data
if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    // Pastikan input status diterima dengan aman
    $newStatus = isset($_POST['status']) ? $_POST['status'] : null;

    if ($newStatus) {
        // Query untuk memperbarui data terakhir di tabel sensor_data
        $query = "UPDATE sensor_data SET Lampu = ? WHERE id = (SELECT MAX(id) FROM sensor_data)";
        $stmt = $koneksi->prepare($query);
        $stmt->bind_param('s', $newStatus);

        if ($stmt->execute()) {
            echo json_encode(['success' => true, 'status' => $newStatus]);
        } else {
            echo json_encode(['error' => 'Gagal memperbarui data Lampu']);
        }
    } else {
        echo json_encode(['error' => 'Status tidak valid atau tidak ada']);
    }
    exit;
}

// Periksa apakah metode request adalah GET untuk membaca data terakhir
if ($_SERVER['REQUEST_METHOD'] === 'GET') {
    // Query untuk membaca status data terakhir
    $query = "SELECT Lampu FROM sensor_data WHERE id = (SELECT MAX(id) FROM sensor_data)";
    $result = $koneksi->query($query);

    if ($result && $row = $result->fetch_assoc()) {
        echo json_encode(['status' => $row['Lampu']]);
    } else {
        echo json_encode(['error' => 'Gagal membaca data Lampu']);
    }
    exit;
}

// Jika metode request bukan POST atau GET
http_response_code(405); // Method Not Allowed
echo json_encode(['error' => 'Metode tidak didukung']);
exit;
?>
