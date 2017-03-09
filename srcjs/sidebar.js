// Optionally disable sidebar
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
//   *  Trigger the resize event (this allows images to be
//      responsive and resize themselves)
//   *  Update the value for the sidebar's input binding
$(document).on("click", ".sidebar-toggle", function() {
  $(window).trigger("resize");
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
      value = null
    } else if ($(this).next().hasClass("treeview-menu")) {
      value = $(this).next().find('a').attr('href').substring(1);
    }
    inputBinding.setValue($obj, value);
    $obj.trigger('change');
});
