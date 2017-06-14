// Optionally disable sidebar (set through the `disable` argument
// to the `dashboardSidebar` function)
if ($("section.sidebar").data("disable")) {
  $("body").addClass("sidebar-collapse");
  $(".navbar > .sidebar-toggle").hide();
}

// Get the correct value for `input$sidebarCollapsed`, depending on
// whether or not the left offset on the sidebar is negative (hidden
// - so `input$sidebarCollapsed` should be TRUE) or 0 (shown - so
// `input$sidebarCollapsed` should be FALSE). That we know of,
// `$(".main-sidebar").is(":visible")` is always true, so there is
// no need to check for that.
var sidebarCollapsedValue = function() {
  if ($(".main-sidebar").offset().left < 0) return(true);
  else return(false);
};

// Whenever the sidebar changes from collapsed to expanded and vice versa,
// call this function, so that we can trigger the resize event on the rest
// of the window and also update the value for the sidebar's input binding.
var sidebarChange = function() {
  // 1) Trigger the resize event (so images are responsive and resize)
  $(window).trigger("resize");

  // 2) Update the value for the sidebar's input binding
  var $obj = $('.main-sidebar.shiny-bound-input');
  var inputBinding = $obj.data('shiny-input-binding');
  inputBinding.setValue($obj, sidebarCollapsedValue());
  $obj.trigger('change');
};

// Whenever the sidebar finishes a transition (which it does every time it
// changes from collapsed to expanded and vice versa), call sidebarChange()
$(".main-sidebar").on(
  'webkitTransitionEnd otransitionend oTransitionEnd msTransitionEnd transitionend',
    sidebarChange);

// This fixes an edge case: when the app starts up with the sidebar already
// collapsed (either because the screen is small or because
// `dashboardSidebar(disable = TRUE`), make sure that `input$sidebarCollapsed`
// is set to `FALSE`. Whenever this is the case, `$(".main-sidebar").offset().left`
// is negative. That we know of, `$(".main-sidebar").is(":visible")` is always
// true, so there is no need to check for that.
if ($(".main-sidebar").offset().left < 0) {
  // This is indirectly setting the value of the Shiny input by setting
  // an attribute on the html element it is bound to. We cannot use the
  // inputBinding's setValue() method here because this is called too
  // early (before Shiny has fully initialized)
  $(".main-sidebar").attr("data-collapsed", "true");
}

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
