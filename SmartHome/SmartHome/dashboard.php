<?php
$title = "Dashboard";
include 'auth_helper.php';
require_once 'config.php';

isLoggedIn();
?>
<!DOCTYPE html>
<html lang="en">
<?php include 'Partials/head.php' ?>
  
  <style>
      .large-badge {
        font-size: 0.8rem;
        padding: 0.5rem 1rem;
      }
    </style>

  <body id="page-top">
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

            <div class="d-flex flex-column flex-sm-row align-items-start align-items-sm-center justify-content-between mb-4">
              <h1 class="h3 text-gray-800 mb-2 mb-sm-0">Dashboard</h1>
              <span class="badge badge-success badge-pill large-badge">
                Last Updated: <span id="last-updated"></span>
              </span>
            </div>



            <!-- Content Row -->
            <div class="row">
              <!-- Temperature Card -->
              <div class="col-xl-3 col-md-6 mb-4">
                <div class="card border-left-success shadow h-100 py-2">
                  <div class="card-body">
                    <div class="row no-gutters align-items-center">
                      <div class="col mr-2">
                        <div
                          class="text-xs font-weight-bold text-success text-uppercase mb-1"
                        >
                          Temperature
                        </div>
                        <div
                         
                          class="h5 mb-0 font-weight-bold text-gray-800"
                        >
                          <span  id="temperature">Loading... </span><span id="temperature-unit">°C</span>
                        </div>
                      </div>
                      <div class="col-auto">
                        <i
                          class="fas fa-thermometer-half fa-2x text-success"
                        ></i>
                      </div>
                    </div>
                  </div>
                </div>
              </div>

              <!-- Humidity Card -->
              <div class="col-xl-3 col-md-6 mb-4">
                <div class="card border-left-info shadow h-100 py-2">
                  <div class="card-body">
                    <div class="row no-gutters align-items-center">
                      <div class="col mr-2">
                        <div
                          class="text-xs font-weight-bold text-info text-uppercase mb-1"
                        >
                          Humidity
                        </div>
                        <div class="row no-gutters align-items-center">
                          <div class="col-auto">
                            <div
                              class="h5 mb-0 mr-3 font-weight-bold text-gray-800"
                            >
                             <span id="humidity">Loading... </span> <span id="humidity-unit">%</span>
                            </div>
                          </div>
                        </div>
                      </div>
                      <div class="col-auto">
                        <i class="fas fa-water fa-2x text-info"></i>
                      </div>
                    </div>
                  </div>
                </div>
              </div>

              <!-- Raindrops Status Card -->
              <div class="col-xl-3 col-md-6 mb-4">
                <div class="card border-left-warning shadow h-100 py-2">
                  <div class="card-body">
                    <div class="row no-gutters align-items-center">
                      <div class="col mr-2">
                        <div
                          class="text-xs font-weight-bold text-warning text-uppercase mb-1"
                        >
                          Raindrops
                        </div>
                        <div
                          id="raindrops"
                          class="h5 mb-0 font-weight-bold text-gray-800"
                        >
                          Loading...
                        </div>
                      </div>
                      <div class="col-auto">
                        <i class="fas fa-cloud-sun fa-2x text-warning"></i>
                      </div>
                    </div>
                  </div>
                </div>
              </div>

              <!-- Gas Detection Card -->
              <div class="col-xl-3 col-md-6 mb-4">
                <div class="card border-left-danger shadow h-100 py-2">
                  <div class="card-body">
                    <div class="row no-gutters align-items-center">
                      <div class="col mr-2">
                        <div
                          class="text-xs font-weight-bold text-danger text-uppercase mb-1"
                        >
                          Gas
                        </div>
                        <div
                          id="gas"
                          class="h5 mb-0 font-weight-bold text-gray-800"
                        >
                          Loading...
                        </div>
                      </div>
                      <div class="col-auto">
                        <i class="fas fa-smog fa-2x text-danger"></i>
                      </div>
                    </div>
                  </div>
                </div>
              </div>

              <!-- Fan Status Card -->
              <div class="col-xl-3 col-md-6 mb-4">
                <div class="card border-left-primary shadow h-100 py-2">
                  <div class="card-body">
                    <div class="row no-gutters align-items-center">
                      <div class="col mr-2">
                        <div
                          class="text-xs font-weight-bold text-primary text-uppercase mb-1"
                        >
                          Fan
                        </div>
                        <div
                          id="fan"
                          class="h5 mb-0 font-weight-bold text-gray-800"
                        >
                          Loading...
                        </div>
                      </div>
                      <div class="col-auto">
                        <i class="fas fa-fan fa-2x text-primary"></i>
                      </div>
                    </div>
                  </div>
                </div>
              </div>

              <!-- Lampu Status Card -->
              <div class="col-xl-3 col-md-6 mb-4">
                <div class="card border-left-primary shadow h-100 py-2">
                  <div class="card-body">
                    <div class="row no-gutters align-items-center">
                      <div class="col mr-2">
                        <div
                          class="text-xs font-weight-bold text-primary text-uppercase mb-1"
                        >
                          Lampu
                        </div>
                        <div
                          id="lampu"
                          class="h5 mb-0 font-weight-bold text-gray-800"
                        >
                          Loading...
                        </div>
                      </div>
                      <div class="col-auto">
                        <i class="fas fa-lightbulb fa-2x text-primary"></i>
                      </div>
                    </div>
                  </div>
                </div>
              </div>

              <!-- Pintu Status Card -->
              <div class="col-xl-3 col-md-6 mb-4">
                <div class="card border-left-primary shadow h-100 py-2">
                  <div class="card-body">
                    <div class="row no-gutters align-items-center">
                      <div class="col mr-2">
                        <div
                          class="text-xs font-weight-bold text-primary text-uppercase mb-1"
                        >
                          Pintu
                        </div>
                        <div
                          id="pintu"
                          class="h5 mb-0 font-weight-bold text-gray-800"
                        >
                          Loading...
                        </div>
                      </div>
                      <div class="col-auto">
                        <i class="fas fa-door-closed fa-2x text-primary"></i>
                      </div>
                    </div>
                  </div>
                </div>
              </div>
            </div>

            <!-- Content Row -->

            <div class="row">
              <!-- Area Chart -->
              <div class="col-xl-6 col-md-6 col-lg-12">
                <div class="card shadow mb-4">
                  <!-- Card Header - Dropdown -->
                  <div
                    class="card-header py-3 d-flex flex-row align-items-center justify-content-between"
                  >
                    <h6 class="m-0 font-weight-bold text-primary">
                      Temperature & Humidity
                    </h6>
                    <div class="dropdown no-arrow">
                      <a
                        class="dropdown-toggle"
                        href="#"
                        role="button"
                        id="dropdownMenuLink"
                        data-toggle="dropdown"
                        aria-haspopup="true"
                        aria-expanded="false"
                      >
                      </a>
                    </div>
                  </div>
                  <!-- Card Body -->
                  <div class="card-body">
                    <div class="chart-area">
                      <canvas id="tempHumi"></canvas>
                    </div>
                  </div>
                </div>
              </div>

              <div class="col-xl-6 col-md-6 col-lg-12">
                <div class="card shadow mb-4">
                  <!-- Card Header - Dropdown -->
                  <div
                    class="card-header py-3 d-flex flex-row align-items-center justify-content-between"
                  >
                    <h6 class="m-0 font-weight-bold text-success">
                      Average Temperature & Humidity
                    </h6>
                    <div class="dropdown no-arrow">
                      <a
                        class="dropdown-toggle"
                        href="#"
                        role="button"
                        id="dropdownMenuLink"
                        data-toggle="dropdown"
                        aria-haspopup="true"
                        aria-expanded="false"
                      >
                      </a>
                    </div>
                  </div>
                  <!-- Card Body -->
                  <div class="card-body">
                    <div class="chart-area">
                      <canvas id="avgTempHumi"></canvas>
                    </div>
                  </div>
                </div>
              </div>

              <!-- Pie Chart -->
              
            </div>

            <div class="row">
            <div class="col-xl-6 col-md-6 col-lg-12">
                <div class="card shadow mb-4">
                  <!-- Card Header - Dropdown -->
                  <div
                    class="card-header py-3 d-flex flex-row align-items-center justify-content-between"
                  >
                    <h6 class="m-0 font-weight-bold text-info">Hujan & Gas</h6>
                    <div class="dropdown no-arrow">
                      <a
                        class="dropdown-toggle"
                        href="#"
                        role="button"
                        id="dropdownMenuLink"
                        data-toggle="dropdown"
                        aria-haspopup="true"
                        aria-expanded="false"
                      >
                      </a>
                    </div>
                  </div>
                  <!-- Card Body -->
                  <div class="card-body">
                    <div class="chart-area">
                      <canvas id="hujanGas"></canvas>
                    </div>
                  </div>
                </div>
              </div>
              
            </div>

            <!-- Content Row -->
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

    <!-- Logout Modal-->

    <!-- Bootstrap core JavaScript-->
    <?php include 'Partials/script.php' ?>
    <script>
  // Function to update the dashboard with the latest sensor data
  function updateDashboard() {
    // Perform an AJAX request to fetch the latest sensor data from the server
    fetch('get_data.php')
      .then(response => response.json())
      .then(data => {
        // Check if there's an error
        if (data.error) {
          console.error(data.error);
          return;
        }

        // Update the dashboard with the latest data
        document.getElementById('temperature').textContent = data.Temperature || 'N/A';
        document.getElementById('humidity').textContent = data.Humidity || 'N/A';
        document.getElementById('raindrops').textContent = data.Raindrops || 'N/A';
        document.getElementById('gas').textContent = data.Gas || 'N/A';
        document.getElementById('fan').textContent = data.Fan || 'N/A';
        document.getElementById('lampu').textContent = data.Lampu || 'N/A';
        document.getElementById('pintu').textContent = data.Pintu || 'N/A';

        // Format the datetime to DD-MM-YYYY HH:MM:SS
        let formattedDatetime = formatDatetime(data.Datetime);
        document.getElementById('last-updated').textContent = formattedDatetime || 'N/A';
      })
      .catch(error => {
        console.error('Error fetching data:', error);
      });
  }

  // Function to format the datetime to DD-MM-YYYY HH:MM:SS
  function formatDatetime(datetime) {
    // Ensure that the datetime is in the correct format
    if (!datetime) return '';

    // Split the datetime string into date and time parts
    let [date, time] = datetime.split(' ');

    // Split the date part into day, month, and year
    let [year, month, day] = date.split('-');

    // Return the formatted datetime in DD-MM-YYYY HH:MM:SS
    return `${day}-${month}-${year} ${time}`;
  }

  // Call the updateDashboard function when the page loads
  window.onload = function() {
    updateDashboard(); // Initial data load
    // Refresh data every 10 seconds (10000ms)
    setInterval(updateDashboard, 10000);
  };
</script>


    <!-- Page level custom scripts -->
    <script src="assets/js/demo/temp_humi.js"></script>
    <script src="assets/js/demo/avgtemphumi.js"></script>
    <script src="assets/js/demo/hujan_gas.js"></script>
  </body>
</html>
