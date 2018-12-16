

Shiny.addCustomMessageHandler('streamBox', function(data) {
    $.each(data, function(key, val){
      // get element
      el = document.getElementById(key);

      // update value
      if (el.className.includes("small-box")) {
        // for valueBox
        el.getElementsByClassName("value-box-value")[0].innerText = val;
      } else if (el.className.includes("info-box")) {
        // for infoBox
        el.getElementsByClassName("info-box-number")[0].innerText = val;
      }
    });
  });
