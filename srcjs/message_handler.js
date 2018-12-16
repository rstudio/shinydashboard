

Shiny.addCustomMessageHandler('streamValueBox', function(data) {
    $.each(data, function(key, val){
      // update the value (in unhealthy fashion)
      el = document.getElementById(key);
      el.getElementsByClassName("valuebox-value")[0].innerText = val;
    });
  });
