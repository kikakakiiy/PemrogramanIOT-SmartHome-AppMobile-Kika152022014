<?php
include 'config.php'; // Make sure this file contains your database connection

// Query to get temperature data
$sql = "SELECT Temperature, Datetime FROM sensor_data ORDER BY Datetime DESC LIMIT 7"; // Last 7 days
$result = $koneksi->query($sql);

// Initialize an array to store the temperature data
$temperature_data = array();
$labels = array();

// Check if there are any results
if ($result->num_rows > 0) {
    while($row = $result->fetch_assoc()) {
        $temperature_data[] = $row['Temperature'];
        $labels[] = $row['Datetime']; // Assuming you have a date column
    }
}

// Return data as JSON
echo json_encode(array('labels' => $labels, 'data' => $temperature_data));

$koneksi->close();
?>
