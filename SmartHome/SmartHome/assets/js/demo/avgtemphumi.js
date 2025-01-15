console.log("humidity.js loaded!");

// Chart Initialization
var avgTempHumi = document.getElementById("avgTempHumi");
var avgTempHumi = new Chart(avgTempHumi, {
  type: 'line',
  data: {
    labels: [],
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
          callback: function(value) {
            return value + '';
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
async function updateChart() {
  try {
    console.log("Fetching data...");
    const response = await fetch('get_avgtemphumi.php');
    const result = await response.json();

    // Process each data entry
    result.forEach(item => {
      const date = item.Date; // Use the date as it is, no need to format
      const avgTemperature = parseFloat(item.AvgTemperature);
      const avgHumidity = parseFloat(item.AvgHumidity);

      // Check if the date already exists in the labels
      if (!avgTempHumi.data.labels.includes(date)) {
        // Add new label and data at the beginning (reverse order)
        avgTempHumi.data.labels.unshift(date); // Insert at the start of the labels array
        avgTempHumi.data.datasets[0].data.unshift(avgTemperature); // Insert temperature data at the start
        avgTempHumi.data.datasets[1].data.unshift(avgHumidity); // Insert humidity data at the start

        // Limit data points to 20
        if (avgTempHumi.data.labels.length > 20) {
          avgTempHumi.data.labels.pop();
          avgTempHumi.data.datasets[0].data.pop();
          avgTempHumi.data.datasets[1].data.pop();
        }

        // Update the chart
        avgTempHumi.update();
        console.log("Chart updated with new data:", date, avgTemperature, avgHumidity);
      } else {
        console.log("Date already exists. Skipping update.");
      }
    });
  } catch (error) {
    console.error("Error fetching data:", error);
  }
}

// Refresh Data Every 5 Seconds
setInterval(updateChart, 5000);
