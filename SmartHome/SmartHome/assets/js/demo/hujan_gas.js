// Format Tanggal
function formatDate(dateString) {
  const dateObj = new Date(dateString);
  const day = String(dateObj.getDate()).padStart(2, '0');
  const month = String(dateObj.getMonth() + 1).padStart(2, '0'); // Bulan dimulai dari 0
  const year = dateObj.getFullYear();
  const hours = String(dateObj.getHours()).padStart(2, '0');
  const minutes = String(dateObj.getMinutes()).padStart(2, '0');
  return `${day}-${month}-${year} ${hours}:${minutes}`;
}

// Inisialisasi Grafik
var ctx = document.getElementById("hujanGas");
var hujanGas = new Chart(ctx, {
  type: 'line',
  data: {
    labels: [], // Label kosong
    datasets: [
      {
        label: "Hujan",
        lineTension: 0.3,
        backgroundColor: "rgba(78, 115, 223, 0.05)",
        borderColor: "rgba(78, 115, 223, 1)",
        pointRadius: 3,
        pointBackgroundColor: "rgba(78, 115, 223, 1)",
        pointBorderColor: "rgba(78, 115, 223, 1)",
        pointHoverRadius: 3,
        pointHoverBackgroundColor: "rgba(78, 115, 223, 1)",
        pointHoverBorderColor: "rgba(78, 115, 223, 1)",
        pointHitRadius: 10,
        pointBorderWidth: 2,
        data: [] // Data Raindrops
      },
      {
        label: "Gas",
        lineTension: 0.3,
        backgroundColor: "rgba(231, 74, 59, 0.05)",
        borderColor: "rgba(231, 74, 59, 1)",
        pointRadius: 3,
        pointBackgroundColor: "rgba(231, 74, 59, 1)",
        pointBorderColor: "rgba(231, 74, 59, 1)",
        pointHoverRadius: 3,
        pointHoverBackgroundColor: "rgba(231, 74, 59, 1)",
        pointHoverBorderColor: "rgba(231, 74, 59, 1)",
        pointHitRadius: 10,
        pointBorderWidth: 2,
        data: [] // Data Gas
      }
    ]
  },
  options: {
    maintainAspectRatio: false,
    layout: {
      padding: { left: 10, right: 25, top: 25, bottom: 0 }
    },
    scales: {
      xAxes: [{
        gridLines: { display: false, drawBorder: false },
        ticks: { maxTicksLimit: 7 }
      }],
      yAxes: [{
        ticks: {
          maxTicksLimit: 2,
          padding: 10,
          callback: function(value) {
            return value === 1 ? 'Ya' : 'Tidak'; // Representasikan data 1 = Ya, 0 = Tidak
          }
        },
        gridLines: {
          color: "rgb(234, 236, 244)",
          zeroLineColor: "rgb(234, 236, 244)",
          drawBorder: false,
          borderDash: [2],
          zeroLineBorderDash: [2]
        }
      }],
    },
    legend: { display: true },
    tooltips: {
      backgroundColor: "rgb(255,255,255)",
      bodyFontColor: "#858796",
      titleMarginBottom: 10,
      titleFontColor: '#6e707e',
      titleFontSize: 14,
      borderColor: '#dddfeb',
      borderWidth: 1,
      xPadding: 15,
      yPadding: 15,
      displayColors: false,
      intersect: false,
      mode: 'index',
      caretPadding: 10
    }
  }
});

// Fetch Data dan Perbarui Grafik
async function updateChart() {
  try {
    const response = await fetch('get_hujangas.php');
    const result = await response.json();
    console.log("Result from get_hujangas.php:", result);

    // Validasi format data
    if (!Array.isArray(result)) {
      throw new Error("Invalid data format: Expected an array.");
    }

    // Urutkan data berdasarkan Datetime, dari yang paling kecil (terlama) ke yang terbaru
    result.sort((a, b) => new Date(a.Datetime) - new Date(b.Datetime));

    result.forEach(item => {
      const { Raindrops, Gas, Datetime } = item;

      // Format tanggal
      const formattedDatetime = formatDate(Datetime);

      // Cek apakah datetime baru sudah ada di grafik
      if (hujanGas.data.labels.includes(formattedDatetime)) {
        console.log("Duplicate datetime, skipping update.");
        return; // Tidak menambahkan data jika datetime sudah ada
      }

      // Konversi data Raindrops dan Gas ke 1 (Ya) dan 0 (Tidak)
      const RaindropsValue = Raindrops === "Ya" ? 1 : 0;
      const GasValue = Gas === "Ya" ? 1 : 0;

      // Tambahkan data baru ke grafik
      hujanGas.data.labels.push(formattedDatetime);
      hujanGas.data.datasets[0].data.push(RaindropsValue);
      hujanGas.data.datasets[1].data.push(GasValue);

      // Batasi jumlah data di grafik agar tidak terlalu banyak
      if (hujanGas.data.labels.length > 20) {
        hujanGas.data.labels.shift();
        hujanGas.data.datasets[0].data.shift();
        hujanGas.data.datasets[1].data.shift();
      }
    });

    // Perbarui grafik
    hujanGas.update();
  } catch (error) {
    console.error("Error fetching data:", error);
  }
}


// Refresh data setiap 5 detik
setInterval(updateChart, 5000);
