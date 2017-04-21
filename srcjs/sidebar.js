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

// Whenever we expand a menuItem (to be expandable, it must have children),
// update the value for the expandedItem's input binding (this is the
// tabName of the fist subMenuItem inside the menuItem that is currently
// expanded)
$(document).on("click", ".treeview > a", function() {
  var $menu = $(this).next();
  // If this menuItem was already open, then clicking on it again,
  // should trigger the "hidden" event, so Shiny doesn't worry about
  // it while it's hidden (and vice versa).
  if ($menu.hasClass("menu-open")) $menu.trigger("hidden");
  else if ($menu.hasClass("treeview-menu")) $menu.trigger("shown");

  // need to set timeout to account for the slideUp/slideDown animation
  var $obj = $('section.sidebar.shiny-bound-input');
  setTimeout(function() { $obj.trigger('change'); }, 600);
});
