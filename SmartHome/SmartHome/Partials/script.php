<!-- jQuery CDN -->
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>

<!-- Bootstrap core JavaScript-->
<script src="assets/vendor/jquery/jquery.min.js"></script>
<script src="assets/vendor/bootstrap/js/bootstrap.bundle.min.js"></script>

<!-- Core plugin JavaScript-->
<script src="assets/vendor/jquery-easing/jquery.easing.min.js"></script>
<script src="assets/vendor/chart.js/Chart.min.js"></script>

<!-- Custom scripts for all pages-->
<script src="assets/js/sb-admin-2.min.js"></script>

<!-- Page level plugins -->
<script src="assets/vendor/datatables/jquery.dataTables.min.js"></script>
<script src="assets/vendor/datatables/dataTables.bootstrap4.min.js"></script>

<!-- Page level custom scripts -->
<script src="assets/js/demo/datatables-demo.js"></script>

<?php
if (isset($_SESSION['swal'])) {
    $swal = $_SESSION['swal'];
    
    // Hapus flashdata agar tidak muncul lagi setelah refresh
    unset($_SESSION['swal']);
    
    // Script untuk menampilkan SweetAlert
    echo "
    <script>
        document.addEventListener('DOMContentLoaded', function() {
            Swal.fire({
                title: '" . addslashes($swal['title']) . "',
                text: '" . addslashes($swal['text']) . "',
                icon: '" . addslashes($swal['icon']) . "',
                confirmButtonColor: '#087167',
                confirmButtonText: 'OK'
            });
        });
    </script>
    ";
}
?>


