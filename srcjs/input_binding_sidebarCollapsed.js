/* global Shiny */

// sidebarCollapsedInputBinding
// ------------------------------------------------------------------
// This keeps tracks of whether the sidebar is expanded (default)
// or collapsed
var sidebarCollapsedInputBinding = new Shiny.InputBinding();
$.extend(sidebarCollapsedInputBinding, {
  find: function(scope) {
    return $(scope).find('.main-sidebar').first();
  },
  getId: function(el) {
    return "sidebarCollapsed";
  },
  getValue: function(el) {
    return $(el).attr("data-value");
  },
  setValue: function(el, value) {
    $(el).attr("data-value", value);
  },
  toggleValue: function(el) {
    var current = this.getValue(el);
    var newVal = (current == "collapsed") ? "expanded" : "collapsed";
    this.setValue(el, newVal);
  },
  receiveMessage: function(el, data) {
    if (data.hasOwnProperty('value'))
      this.setValue(el, data.value);
  },
  subscribe: function(el, callback) {
    $(el).on('change.sidebarCollapsedInputBinding', function() {
      callback();
    });
  },
  unsubscribe: function(el) {
    $(el).off('.sidebarCollapsedInputBinding');
  }
});
Shiny.inputBindings.register(sidebarCollapsedInputBinding,
  'shinydashboard.sidebarCollapsedInputBinding');
