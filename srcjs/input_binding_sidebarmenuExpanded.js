/* global Shiny */

// sidebarmenuExpandedInputBinding
// ------------------------------------------------------------------
// This keeps tracks of what menuItem (if any) is expanded
var sidebarmenuExpandedInputBinding = new Shiny.InputBinding();
$.extend(sidebarmenuExpandedInputBinding, {
  find: function(scope) {
    // This will also have id="sidebarItemExpanded"
    return $(scope).find('section.sidebar');
  },
  getValue: function(el) {
    var $open = $(el).find('li ul.menu-open');
    if ($open.length === 1) return $open.attr('data-expanded');
    else return null;
  },
  setValue: function(el, value) {
    var $menuItem = $(el).find("[data-expanded='" + value + "']");
    // This will trigger actions defined by AdminLTE, as well as actions
    // defined in sidebar.js.
    $menuItem.prev().trigger("click");
  },
  subscribe: function(el, callback) {
    $(el).on('change.sidebarmenuExpandedInputBinding', function() {
      callback();
    });
  },
  unsubscribe: function(el) {
    $(el).off('.sidebarmenuExpandedInputBinding');
  }
});
Shiny.inputBindings.register(sidebarmenuExpandedInputBinding,
  'shinydashboard.sidebarmenuExpandedInputBinding');
