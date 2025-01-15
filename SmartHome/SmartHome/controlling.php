<?php
$title = "Controlling";
include 'auth_helper.php';
include 'config.php';

isLoggedIn();
?>

<!DOCTYPE html>
<html lang="en">
  <?php include 'Partials/head.php' ?>

  <sc id="page-top">
    <!-- Page Wrapper -->
    <div id="wrapper">
      <!-- Sidebar -->
      <?php include 'Partials/sidebar.php' ?>
      <!-- End of Sidebar -->

      <!-- Content Wrapper -->
      <div id="content-wrapper" class="d-flex flex-column">
        <!-- Main Content -->
        <div id="content">
          <!-- Topbar -->
          <?php include 'Partials/navbar.php' ?>
          <!-- End of Topbar -->

          <!-- Begin Page Content -->
          <div class="container-fluid">
            <!-- Page Heading -->
            <h1 class="h3 mb-4 text-gray-800">Controlling</h1>

            <div class="row">
              <!-- Lamp Control Section -->
              <div class="col-lg-6">
                <div class="card shadow mb-4">
                  <div class="card-header py-3">
                    <h6 class="m-0 font-weight-bold text-primary">
                      Kontrol Lampu
                    </h6>
                  </div>
                  <div class="card-body">
                    <p>
                      Gunakan tombol di bawah untuk mengontrol status lampu.
                      Pilih untuk menyalakan atau mematikan lampu.
                    </p>

                    <!-- Lamp Control Button -->
                    <button
                      id="lampButton"
                      class="btn btn-success btn-icon-split"
                    >
                      <span class="icon text-white-50">
                        <i id="lampIcon" class="fas fa-lightbulb"></i>
                      </span>
                      <span id="lampText" class="text">Lampu ON</span>
                    </button>
                  </div>
                </div>
              </div>

              <!-- Door Control Section -->
              <div class="col-lg-6">
                <div class="card shadow mb-4">
                  <div class="card-header py-3">
                    <h6 class="m-0 font-weight-bold text-primary">
                      Kontrol Pintu
                    </h6>
                  </div>
                  <div class="card-body">
                    <p>
                      Gunakan tombol di bawah untuk mengontrol status pintu.
                      Pilih untuk membuka atau menutup pintu.
                    </p>

                    <!-- Door Control Button -->
                    <button id="doorButton" class="btn btn-warning btn-icon-split">
                      <span class="icon text-white-50">
                        <i id="doorIcon" class="fas fa-door-closed"></i>
                      </span>
                      <span id="doorText" class="text">Pintu Tertutup</span>
                    </button>
                  </div>
                </div>
              </div>
            </div>
          </div>
          <!-- /.container-fluid -->
        </div>
        <!-- End of Main Content -->

        <!-- Footer -->
        <?php include 'Partials/footer.php' ?>
        <!-- End of Footer -->
      </div>
      <!-- End of Content Wrapper -->
    </div>
    <!-- End of Page Wrapper -->

    <!-- Scroll to Top Button-->
    <a class="scroll-to-top rounded" href="#page-top">
      <i class="fas fa-angle-up"></i>
    </a>

    <?php include 'Partials/script.php' ?>
   <script src="assets/js/control.js"></script>
  </body>
</html>
