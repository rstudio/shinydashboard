

Shiny.addCustomMessageHandler('streamBox', function(data) {
    $.each(data, function(key, val){
      // get element
      el = document.getElementById(key);

      // TODO: Error handling... what if el does not exist?

      // update value
      if (el.classList.contains("small-box")) {
        // for valueBox
        el.getElementsByClassName("value-box-value")[0].innerText = val;
      } else if (el.classList.contains("info-box")) {
        // for infoBox
        el.getElementsByClassName("info-box-number")[0].innerText = val;
      }
    });
  });
