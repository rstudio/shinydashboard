

Shiny.addCustomMessageHandler('streamValueBox', function(data) {
    $.each(data, function(key, val){
      // update the value (in unhealthy fashion)
      el = document.getElementById(key);

      if (el.className.includes("small-box")) {
        el.getElementsByClassName("valuebox-value")[0].innerText = val;
      } else if (el.className.includes("info-box")) {
        el.getElementsByClassName("info-box-number")[0].innerText = val;
      }
    });
  });
