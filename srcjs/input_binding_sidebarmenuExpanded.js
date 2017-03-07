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
    return "itemExpanded";
  },
  // needed so we set the appropriate value for bookmarked apps on startup
  initialize: function(el) {
    $(this).trigger('change');
  },
  // the value is the href of the open menuItem (or NULL if there's
  // no open menuItem)
  getValue: function(el) {
    var $expanded = $(el).find('li ul.menu-open');
    if ($expanded.length === 1) return $expanded.prev().attr('href').substring(1);
    else if ($(el).attr("data-expanded")) return $(el).attr("data-expanded");
    else return null;
  },
  setValue: function(el, value) {
    if (value !== null) {
      var $ul = $('a[href="#' + value + '"]').next();
      $ul.addClass('menu-open');
      $ul.show();
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
