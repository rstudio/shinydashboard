/* global Shiny */

// sidebarmenuExpandedInputBinding
// ------------------------------------------------------------------
// This keeps tracks of what menuItem (if any) is expanded
var sidebarmenuExpandedInputBinding = new Shiny.InputBinding();
$.extend(sidebarmenuExpandedInputBinding, {
  find: function(scope) {
    return $(scope).find('section.sidebar');
  },
  getId: function(el) {
    return "sidebarItemExpanded";
  },
  getValue: function(el) {
    var $open = $(el).find('li ul.menu-open');
    if ($open.length === 1) return $open.find('a').attr('data-value');
    else return null; // no menuItem is expanded
  },
  setValue: function(el, value, clicked) {
    clicked = (typeof clicked !== 'undefined') ?  clicked : null;
    if (value !== null) {
      var $firstChild = $('a[data-value="' + value + '"]');
      $(document).trigger('click', $firstChild);
    } else {
      $(document).trigger('click', clicked);
    }
  },
  receiveMessage: function(el, data) {
    if (data.hasOwnProperty('value'))
      this.setValue(el, data.value);
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
