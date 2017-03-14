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
  setValue: function(el, value) {
    /*
    var $anchor = $('.sidebar-menu li a');
    if (value !== null)
      $anchor = $('a[data-value="' + value + '"]').parent().parent().prev('a');
    console.log($anchor);
    $(document).trigger("click", $anchor);
    */

    var $ul;
    if (value !== null) {
      var $firstChild = $('a[data-value="' + value + '"]');
      $ul = $firstChild.parent().parent('.treeview-menu');
      $ul.addClass('menu-open');
      $ul.show();
    } else {
      $ul = $(el).find('li ul.menu-open');
      $ul.removeClass('menu-open');
      $ul.hide();
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
