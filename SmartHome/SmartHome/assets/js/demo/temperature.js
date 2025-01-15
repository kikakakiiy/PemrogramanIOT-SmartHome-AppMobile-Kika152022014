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
var ctx = document.getElementById("tempChart");
var tempChart = new Chart(ctx, {
  type: 'line',
  data: {
    labels: [], // Labels kosong
    datasets: [{
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
      data: [] // Data kosong
    }]
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
          callback: function(value) { return value + '°C'; }
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
    legend: { display: false },
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
      caretPadding: 10,
      callbacks: {
        label: function(tooltipItem, chart) {
          var datasetLabel = chart.datasets[tooltipItem.datasetIndex].label || '';
          return datasetLabel + ': ' + tooltipItem.yLabel + '°C';
        }
      }
    }
  }
});

// Fetch Data and Update Chart
async function updateChart() {
  try {
    const response = await fetch('get_temp.php');
    const result = await response.json();
    console.log("Result from get_Temp.php:", result); // Debug respons
    
    if (!result.labels || !result.data) {
      throw new Error("Invalid data format: Missing 'labels' or 'data'.");
    }

    const labels = result.labels.map(label => formatDate(label));
    const data = result.data;

    tempChart.data.labels = labels;
    tempChart.data.datasets[0].data = data;
    tempChart.update();
  } catch (error) {
    console.error("Error fetching data:", error);
  }
}


// Refresh Data Setiap 5 Detik
setInterval(updateChart, 5000);
