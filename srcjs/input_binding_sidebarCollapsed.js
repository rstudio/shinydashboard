/* global Shiny */

// sidebarCollapsedInputBinding
// ------------------------------------------------------------------
// This keeps tracks of whether the sidebar is expanded (default)
// or collapsed
var sidebarCollapsedInputBinding = new Shiny.InputBinding();
$.extend(sidebarCollapsedInputBinding, {
  find: function(scope) {
    // This will also have id="sidebarCollapsed"
    return $(scope).find('.main-sidebar').first();
  },
  getValue: function(el) {
    return $(el).attr("data-collapsed") === "true";
  },
  setValue: function(el, value) {
    $(el).attr("data-collapsed", value);
  },
  toggleValue: function(el) {
    var current = this.getValue(el);
    var newVal = current ? "false" : "true";
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
