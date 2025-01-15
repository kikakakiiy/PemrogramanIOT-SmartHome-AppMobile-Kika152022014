<?php
// get_data.php
include 'config.php'; // Make sure this file contains your database connection

// Query to fetch the latest sensor data
$query = "SELECT Lampu, Pintu FROM sensor_data ORDER BY Datetime DESC LIMIT 1";
$result = mysqli_query($koneksi, $query);

if ($result) {
    // Fetch the latest data as an associative array
    $latestData = mysqli_fetch_assoc($result);
    echo json_encode($latestData);
} else {
    // Handle error if the query fails
    echo json_encode(['error' => 'Unable to fetch data']);
}

mysqli_close($koneksi);
?>
