document.addEventListener("DOMContentLoaded", function () {
    const doorButton = document.getElementById("doorButton");
    const doorIcon = document.getElementById("doorIcon");
    const doorText = document.getElementById("doorText");
    const lampButton = document.getElementById("lampButton");
    const lampIcon = document.getElementById("lampIcon");
    const lampText = document.getElementById("lampText");
  
    // Fungsi untuk memperbarui status pintu dari server
    function updateDoorStatus() {
      fetch("control_pintu.php")
        .then((response) => response.json())
        .then((data) => {
          if (data.status) {
            const status = data.status;
            if (status === "Terbuka") {
              doorIcon.className = "fas fa-door-open";
              doorButton.className = "btn btn-success btn-icon-split";
              doorText.textContent = "Pintu Terbuka";
            } else {
              doorIcon.className = "fas fa-door-closed";
              doorButton.className = "btn btn-danger btn-icon-split";
              doorText.textContent = "Pintu Tertutup";
            }
          } else {
            console.error("Error fetching door status:", data.error);
          }
        })
        .catch((error) => console.error("Error:", error));
    }
  
    // Fungsi untuk memperbarui status lampu dari server
    function updateLampStatus() {
      fetch("control_lampu.php")
        .then((response) => response.json())
        .then((data) => {
          if (data.status) {
            const status = data.status;
            if (status === "ON") {
              lampButton.classList.replace("btn-danger", "btn-success");
              lampIcon.className = "fas fa-lightbulb";
              lampText.textContent = "Lampu ON";
            } else {
              lampButton.classList.replace("btn-success", "btn-danger");
              lampIcon.className = "fas fa-times";
              lampText.textContent = "Lampu OFF";
            }
          } else {
            console.error("Error fetching lamp status:", data.error);
          }
        })
        .catch((error) => console.error("Error:", error));
    }
  
    // Panggil fungsi untuk membaca status awal
    updateDoorStatus();
    updateLampStatus();
  
    // Event Listener untuk mengubah status pintu saat tombol diklik
    doorButton.addEventListener("click", function () {
      const currentStatus = doorText.textContent.includes("Terbuka") ? "Tertutup" : "Terbuka";
  
      fetch("control_pintu.php", {
        method: "POST",
        headers: {
          "Content-Type": "application/x-www-form-urlencoded",
        },
        body: `status=${currentStatus}`,
      })
        .then((response) => response.json())
        .then((data) => {
          if (data.success) {
            updateDoorStatus();
          } else {
            console.error("Error updating door status:", data.error);
          }
        })
        .catch((error) => console.error("Error:", error));
    });
  
    // Event Listener untuk mengubah status lampu saat tombol diklik
    lampButton.addEventListener("click", function () {
      const currentStatus = lampText.textContent.includes("ON") ? "OFF" : "ON";
  
      fetch("control_lampu.php", {
        method: "POST",
        headers: {
          "Content-Type": "application/x-www-form-urlencoded",
        },
        body: `status=${currentStatus}`,
      })
        .then((response) => response.json())
        .then((data) => {
          if (data.success) {
            updateLampStatus();
          } else {
            console.error("Error updating lamp status:", data.error);
          }
        })
        .catch((error) => console.error("Error:", error));
    });
  });
  