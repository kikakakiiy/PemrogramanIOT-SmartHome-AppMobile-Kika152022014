<?php
// Start the session
session_start();

// Include the database configuration file
require 'config.php';

// Check if the form has been submitted
if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    // Get the input from the form
    $username = mysqli_real_escape_string($koneksi, $_POST['username']);
    $password = mysqli_real_escape_string($koneksi, $_POST['password']);

    // Validate input
    if (empty($username) || empty($password)) {
        $_SESSION['swal'] = [
            'title' => 'Registrasi Gagal',
            'text' => 'Username dan password wajib diisi!',
            'icon' => 'error'
        ];
        header('Location: register.php');
        exit;
    }

    // Check if the username already exists in the database using a prepared statement
    $query = "SELECT * FROM users WHERE username = ?";
    $stmt = mysqli_prepare($koneksi, $query);
    mysqli_stmt_bind_param($stmt, "s", $username); // "s" denotes string type
    mysqli_stmt_execute($stmt);
    $result = mysqli_stmt_get_result($stmt);

    if (mysqli_num_rows($result) > 0) {
        $_SESSION['swal'] = [
            'title' => 'Registrasi Gagal',
            'text' => 'Username sudah digunakan!',
            'icon' => 'error'
        ];
        header('Location: register.php');
        exit;
    }

    // Hash the password
    $hashed_password = password_hash($password, PASSWORD_DEFAULT);

    // Prepare query to insert the new user into the database
    $query = "INSERT INTO users (username, password) VALUES (?, ?)";
    $stmt = mysqli_prepare($koneksi, $query);
    mysqli_stmt_bind_param($stmt, "ss", $username, $hashed_password); // "ss" denotes string type for both parameters

    if (mysqli_stmt_execute($stmt)) {
        $_SESSION['swal'] = [
            'title' => 'Registrasi Sukses',
            'text' => 'Akun Anda telah berhasil dibuat!',
            'icon' => 'success'
        ];
        header('Location: login.php'); // Redirect to login page after successful registration
        exit;
    } else {
        // Error handling if the query fails
        $_SESSION['swal'] = [
            'title' => 'Registrasi Gagal',
            'text' => 'Terjadi kesalahan, coba lagi nanti.',
            'icon' => 'error'
        ];
        header('Location: register.php');
        exit;
    }

} else {
    // If accessed directly, redirect to registration page
    header('Location: register.php');
    exit;
}
