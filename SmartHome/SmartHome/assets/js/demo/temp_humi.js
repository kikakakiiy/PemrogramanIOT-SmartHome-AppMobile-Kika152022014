console.log("Temp_humi.js loaded!");

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

// Chart Initialization
var tempHumiChart = document.getElementById("tempHumi");
var tempHumi = new Chart(tempHumiChart, {
  type: 'line',
  data: {
    labels: [], // Labels kosong
    datasets: [
      {
        label: "Temperature (°C)",
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
        data: []
      },
      {
        label: "Humidity (%)",
        lineTension: 0.3,
        backgroundColor: "rgba(28, 200, 138, 0.05)",
        borderColor: "rgba(28, 200, 138, 1)",
        pointRadius: 3,
        pointBackgroundColor: "rgba(28, 200, 138, 1)",
        pointBorderColor: "rgba(28, 200, 138, 1)",
        pointHoverRadius: 3,
        pointHoverBackgroundColor: "rgba(28, 200, 138, 1)",
        pointHoverBorderColor: "rgba(28, 200, 138, 1)",
        pointHitRadius: 10,
        pointBorderWidth: 2,
        data: []
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
          maxTicksLimit: 5,
          padding: 10,
          callback: function(value, index, values) {
            return index === 0 ? value + '' : value + '';
          }
        },
        gridLines: {
          color: "rgb(234, 236, 244)",
          zeroLineColor: "rgb(234, 236, 244)",
          drawBorder: false,
          borderDash: [2],
          zeroLineBorderDash: [2]
        }
      }]
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
      displayColors: true,
      intersect: false,
      mode: 'index',
      caretPadding: 10,
      callbacks: {
        label: function(tooltipItem, chart) {
          const datasetLabel = chart.datasets[tooltipItem.datasetIndex].label || '';
          return datasetLabel + ': ' + tooltipItem.yLabel + (datasetLabel.includes('Temperature') ? '°C' : '%');
        }
      }
    }
  }
});

// Fetch Data and Update Chart
async function fetchHujanGasData() {
  try {
    // Ambil data dari get_hujangas.php
    const response = await fetch('get_temphumi.php');

    // Periksa apakah respons berhasil
    if (!response.ok) {
      throw new Error(`HTTP error! Status: ${response.status}`);
    }

    // Parse data JSON dari respons
    const data = await response.json();

    // Tampilkan data ke konsol untuk verifikasi
    console.log("Data dari get_temphumi.php:", data);

    // Urutkan data berdasarkan Datetime (tanggal terkecil di kiri)
    data.sort((a, b) => new Date(a.Datetime) - new Date(b.Datetime));

    // Proses data untuk chart
    data.forEach(item => {
      const formattedDatetime = formatDate(item.Datetime);
      const temperatureValue = parseFloat(item.Temperature);
      const humidityValue = parseFloat(item.Humidity);

      // Cek apakah datetime sudah ada di label
      if (!tempHumi.data.labels.includes(formattedDatetime)) {
        // Tambahkan label dan data baru
        tempHumi.data.labels.push(formattedDatetime);
        tempHumi.data.datasets[0].data.push(temperatureValue);
        tempHumi.data.datasets[1].data.push(humidityValue);

        // Batasi jumlah data di grafik agar tidak terlalu banyak
        if (tempHumi.data.labels.length > 20) {
          tempHumi.data.labels.shift();
          tempHumi.data.datasets[0].data.shift();
          tempHumi.data.datasets[1].data.shift();
        }

        // Perbarui grafik
        tempHumi.update();
        console.log("Chart updated with new data:", formattedDatetime, temperatureValue, humidityValue);
      } else {
        console.log("Datetime already exists. Skipping update.");
      }
    });
  } catch (error) {
    console.error('Error saat mengambil atau memproses data:', error);
  }
}

// Refresh Data Setiap 5 Detik
setInterval(fetchHujanGasData, 5000);
