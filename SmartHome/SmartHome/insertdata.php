<?php
// Include the database configuration file
include 'config.php';

// Check if the request method is POST
if ($_SERVER['REQUEST_METHOD'] === 'POST') {

    // Retrieve data from POST request
    $datetime = isset($_POST['Datetime']) ? $_POST['Datetime'] : null;
    $temperature = isset($_POST['Temperature']) ? $_POST['Temperature'] : null;
    $humidity = isset($_POST['Humidity']) ? $_POST['Humidity'] : null;
    $fan = isset($_POST['Fan']) ? $_POST['Fan'] : null;
    $gas = isset($_POST['Gas']) ? $_POST['Gas'] : null;
    $lampu = isset($_POST['Lampu']) ? $_POST['Lampu'] : null;
    $pintu = isset($_POST['Pintu']) ? $_POST['Pintu'] : null;
    $raindrops = isset($_POST['Raindrops']) ? $_POST['Raindrops'] : null;

    // Validate input data
    if (isset($datetime, $temperature, $humidity, $fan, $gas, $lampu, $pintu, $raindrops)) {

        // Prepare the SQL query to insert the data
        $query = "INSERT INTO sensor_data (Temperature, Humidity, Fan, Gas, Lampu, Pintu, Raindrops, Datetime) 
                  VALUES ('$temperature', '$humidity', '$fan', '$gas', '$lampu', '$pintu', '$raindrops', '$datetime')";

        // Execute the query
        if ($koneksi->query($query) === TRUE) {
            echo json_encode(["status" => "success", "message" => "Data inserted successfully"]);
        } else {
            echo json_encode(["status" => "error", "message" => "Failed to insert data: " . $koneksi->error]);
        }
    } else {
        // Return an error if some fields are missing
        echo json_encode(["status" => "error", "message" => "Missing required fields"]);
    }
} else {
    // If the request is not POST, return an error
    echo json_encode(["status" => "error", "message" => "Invalid request method"]);
}

// Close the database connection
$koneksi->close();
?>