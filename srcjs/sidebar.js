// Optionally disable sidebar (set through the `disable` argument
// to the `dashboardSidebar` function)
if ($("section.sidebar").data("disable")) {
  $("body").addClass("sidebar-collapse");
  $(".navbar > .sidebar-toggle").hide();
}


// Trigger "shown" event for elements that only become visible after
// the corresponding menuItem is expanded (otherwise, Shiny will still
// think they're hidden and not render them)
$(document).on("click", ".treeview > a", function() {
  $(this).next(".treeview-menu").trigger("shown");
});


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
  var $obj = $('section.sidebar.shiny-bound-input');
  var inputBinding = $obj.data('shiny-input-binding');
  var value;

  // If this menuItem was already open, then clicking on it again,
  // should update the input binding back to null
  if ($(this).next().hasClass("menu-open")) {
    value = null;
  } else if ($(this).next().hasClass("treeview-menu")) {
    value = $(this).next().find('a').attr('data-value');
  }
  inputBinding.setValue($obj, value);
  $obj.trigger('change');
});
