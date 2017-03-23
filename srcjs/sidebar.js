// Optionally disable sidebar (set through the `disable` argument
// to the `dashboardSidebar` function)
if ($("section.sidebar").data("disable")) {
  $("body").addClass("sidebar-collapse");
  $(".navbar > .sidebar-toggle").hide();
}

// Whenever the sidebar expand/collapse button is clicked:
$(document).on("click", ".sidebar-toggle", function() {
  // 1) Trigger the resize event (so images are responsive and resize)
  $(window).trigger("resize");

  // 2) Update the value for the sidebar's input binding
  var $obj = $('.main-sidebar.shiny-bound-input');
  var inputBinding = $obj.data('shiny-input-binding');
  inputBinding.toggleValue($obj);
  $obj.trigger('change');
});

$(document).on("click", ".treeview > a", function() {
  $(this).next(".treeview-menu").trigger("shown");
});
