<?php
include 'config.php'; // Make sure this file contains your database connection

// Query to get temperature data
$sql = "SELECT Humidity, Datetime FROM sensor_data ORDER BY Datetime DESC LIMIT 7"; // Last 7 days
$result = $koneksi->query($sql);

// Initialize an array to store the temperature data
$humidity_data = array();
$labels = array();

// Check if there are any results
if ($result->num_rows > 0) {
    while($row = $result->fetch_assoc()) {
        $humidity_data[] = $row['Humidity'];
        $labels[] = $row['Datetime']; // Assuming you have a date column
    }
}

// Return data as JSON
echo json_encode(array('labels' => $labels, 'data' => $humidity_data));

$koneksi->close();
?>
