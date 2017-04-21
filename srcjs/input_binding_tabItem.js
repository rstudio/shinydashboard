/* global Shiny */

// tabItemInputBinding
// ------------------------------------------------------------------
// Based on Shiny.tabItemInputBinding, but customized for tabItems in
// shinydashboard, which have a slightly different structure.
var tabItemInputBinding = new Shiny.InputBinding();
$.extend(tabItemInputBinding, {
  find: function(scope) {
    return $(scope).find('.sidebarMenuSelectedTabItem');
  },
  getValue: function(el) {
    var value = $(el).attr('data-value');
    if (value === "null") return null;
    return value;
  },
  setValue: function(el, value) {
    var self = this;
    var anchors = $(el).parent('ul.sidebar-menu').find('li:not(.treeview)').children('a');
    anchors.each(function() { // eslint-disable-line consistent-return
      if (self._getTabName($(this)) === value) {
        $(this).tab('show');
        $(el).attr('data-value', self._getTabName($(this)));
        return false;
      }
    });
  },
  receiveMessage: function(el, data) {
    if (data.hasOwnProperty('value'))
      this.setValue(el, data.value);
  },
  subscribe: function(el, callback) {
    // This event is triggered by deactivateOtherTabs, which is triggered by
    // shown. The deactivation of other tabs must occur before Shiny gets the
    // input value.
    $(el).on('change.tabItemInputBinding', function() {
      callback();
    });
  },
  unsubscribe: function(el) {
    $(el).off('.tabItemInputBinding');
  },
  _getTabName: function(anchor) {
    return anchor.attr('data-value');
  }
});

Shiny.inputBindings.register(tabItemInputBinding, 'shinydashboard.tabItemInput');
