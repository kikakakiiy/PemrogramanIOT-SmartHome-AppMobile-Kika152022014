<?php
function isLoggedIn()
{
    // Start session if not already started
    if (session_status() === PHP_SESSION_NONE) {
        session_start();
    }

    // Check if the user session exists
    if (!isset($_SESSION['user'])) {
        header("Location: login.php");
        exit;
    }

    // If logged in as Admin, allow access
    return true;
}
?>
