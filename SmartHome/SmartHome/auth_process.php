<?php
// Mulai sesi
session_start();

// Masukkan file konfigurasi
require 'config.php';

// Periksa apakah form login telah dikirim
if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $username = mysqli_real_escape_string($koneksi, $_POST['username']);
    $password = mysqli_real_escape_string($koneksi, $_POST['password']);

    // Periksa apakah input kosong
    if (empty($username) || empty($password)) {
        $_SESSION['swal'] = [
            'title' => 'Login Gagal',
            'text' => 'Username dan password wajib diisi!',
            'icon' => 'error'
        ];
        header('Location: login.php');
        exit;
    }

    // Query untuk mendapatkan data pengguna
    $query = "SELECT * FROM users WHERE username = '$username'";
    $result = mysqli_query($koneksi, $query);

    if (mysqli_num_rows($result) === 1) {
        $user = mysqli_fetch_assoc($result);

        // Verifikasi password
        if (password_verify($password, $user['password'])) {
            // Set session untuk login
            $_SESSION['user'] = [
                'id' => $user['id'],
                'username' => $user['username'],
            ];

            // Set session untuk SweetAlert2
            $_SESSION['swal'] = [
                'title' => 'Selamat Datang!',
                'text' => 'Anda berhasil login sebagai ' . $user['username'],
                'icon' => 'success'
            ];

            header('Location: dashboard.php');
            exit;
        } else {
            // Password salah
            $_SESSION['swal'] = [
                'title' => 'Login Gagal',
                'text' => 'Password salah!',
                'icon' => 'error'
            ];
            header('Location: login.php');
            exit;
        }
    } else {
        // Username tidak ditemukan
        $_SESSION['swal'] = [
            'title' => 'Login Gagal',
            'text' => 'Username atau password salah!',
            'icon' => 'error'
        ];
        header('Location: login.php');
        exit;
    }
} else {
    // Akses langsung ke file ini tidak diperbolehkan
    header('Location: login.php');
    exit;
}
?>
