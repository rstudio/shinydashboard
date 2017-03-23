  // Optionally disable sidebar
  if ($("section.sidebar").data("disable")) {
    $("body").addClass("sidebar-collapse");
    $(".navbar > .sidebar-toggle").hide();
  }

  // Trigger the resize event when the sidebar is collapsed/expanded
  // (this allows images to be responsive and resize themselves)
 $(document).on("click", ".sidebar-toggle", function() {
    $(window).trigger("resize");
  });

 $(document).on("click", ".treeview > a", function() {
    $(this).next(".treeview-menu").trigger("shown");
  });
