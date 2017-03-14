//---------------------------------------------------------------------
// Source file: ../srcjs/_start.js

$(function() {

//---------------------------------------------------------------------
// Source file: ../srcjs/tabs.js

// This function handles a special case in the AdminLTE sidebar: when there
// is a sidebar-menu with items, and one of those items has sub-items, and
// they are used for tab navigation. Normally, if one of the items is
// selected and then a sub-item is clicked, both the item and sub-item will
// retain the "active" class, so they will both be highlighted. This happens
// because they're not designed to be used together for tab panels. This
// code ensures that only one item will have the "active" class.
var deactivateOtherTabs = function() {
  // Find all tab links under sidebar-menu even if they don't have a
  // tabName (which is why the second selector is necessary)
  var $tablinks = $(".sidebar-menu a[data-toggle='tab']," +
    ".sidebar-menu li.treeview > a");

  // If any other items are active, deactivate them
  $tablinks.not($(this)).parent("li").removeClass("active");

  // Trigger event for the tabItemInputBinding
  var $obj = $('.sidebarMenuSelectedTabItem');
  var inputBinding = $obj.data('shiny-input-binding');
  if (typeof inputBinding !== 'undefined') {
    inputBinding.setValue($obj, $(this).attr('data-value'));
    $obj.trigger('change');
  }
};

$(document).on('shown.bs.tab', '.sidebar-menu a[data-toggle="tab"]',
               deactivateOtherTabs);

// When document is ready, if there is a sidebar menu with no activated tabs,
// activate the one specified by `data-start-selected`, or if that's not
// present, the first one.
var ensureActivatedTab = function() {
  var $tablinks = $(".sidebar-menu a[data-toggle='tab']");

  // If there's a `data-start-selected` attribute and we can find a tab with
  // that name, activate it.
  var $startTab = $tablinks.filter("[data-start-selected='1']");
  if ($startTab.length !== 0) {
    $startTab.tab("show");
    return;
  }

  // If we got this far, just activate the first tab.
  if (! $tablinks.parent("li").hasClass("active") ) {
    $tablinks.first().tab("show");
  }
};

ensureActivatedTab();

//---------------------------------------------------------------------
// Source file: ../srcjs/sidebar.js

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
    value = null;
  } else if ($(this).next().hasClass("treeview-menu")) {
    value = $(this).next().find('a').attr('href').substring(1);
  }
  inputBinding.setValue($obj, value);
  $obj.trigger('change');
});

//---------------------------------------------------------------------
// Source file: ../srcjs/output_binding_menu.js

/* global Shiny */

// menuOutputBinding
// ------------------------------------------------------------------
// Based on Shiny.htmlOutputBinding, but instead of putting the result in a
// wrapper div, it replaces the origin DOM element with the new DOM elements,
// copying over the ID and class.
var menuOutputBinding = new Shiny.OutputBinding();
$.extend(menuOutputBinding, {
  find: function(scope) {
    return $(scope).find('.shinydashboard-menu-output');
  },
  onValueError: function(el, err) {
    Shiny.unbindAll(el);
    this.renderError(el, err);
  },
  renderValue: function(el, data) {
    Shiny.unbindAll(el);

    var html;
    var dependencies = [];
    if (data === null) {
      return;
    } else if (typeof(data) === 'string') {
      html = data;
    } else if (typeof(data) === 'object') {
      html = data.html;
      dependencies = data.deps;
    }

    var $html = $($.parseHTML(html));

    // Convert the inner contents to HTML, and pass to renderHtml
    Shiny.renderHtml($html.html(), el, dependencies);

    // Extract class of wrapper, and add them to the wrapper element
    el.className = 'shinydashboard-menu-output shiny-bound-output ' +
                   $html.attr('class');

    //Shiny.inputBindings.register(tabItemInputBinding, 'shinydashboard.tabItemInput');
    Shiny.initializeInputs(el);
    Shiny.bindAll(el);
    ensureActivatedTab();
  }
});
Shiny.outputBindings.register(menuOutputBinding,
                              "shinydashboard.menuOutputBinding");


/*

// menuOutputBinding
// ------------------------------------------------------------------
  // Based on Shiny.htmlOutputBinding, but instead of putting the result in a
// wrapper div, it replaces the origin DOM element with the new DOM elements,
// copying over the ID and class.
var menuOutputBinding = new Shiny.OutputBinding();
$.extend(menuOutputBinding, {
  find: function(scope) {
    return $(scope).find('.shinydashboard-menu-output');
  },
  onValueError: function(el, err) {
    Shiny.unbindAll(el);
    this.renderError(el, err);
  },
  renderValue: function(el, data) {
    Shiny.unbindAll(el);

    var html;
    var dependencies = [];
    if (data === null) {
      return;
    } else if (typeof(data) === 'string') {
      html = data;
    } else if (typeof(data) === 'object') {
      html = data.html;
      dependencies = data.deps;
    }

    var $html = $($.parseHTML(html));

    $(el).append('<div class = "shinydashboard-menu-output-child ' + $html.attr('class') + '"></div>');

    // Convert the inner contents to HTML, and pass to renderHtml
    Shiny.renderHtml($html.html(), $(el).find('.shinydashboard-menu-output-child'), dependencies);

    // Extract class of wrapper, and add them to the wrapper element
    el.className = 'shinydashboard-menu-output shiny-bound-output ' //+
      //$html.attr('class');

    Shiny.initializeInputs(el);
    Shiny.bindAll(el);
    ensureActivatedTab();
  }
});
Shiny.outputBindings.register(menuOutputBinding,
  "shinydashboard.menuOutputBinding");

*/

//---------------------------------------------------------------------
// Source file: ../srcjs/input_binding_tabItem.js

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
  setValue: function(el, value) { // eslint-disable-line consistent-return
    var self = this;
    var anchors = $(el).parent('ul.sidebar-menu').find('li:not(.treeview)').children('a');
    anchors.each(function() {
      if (self._getTabName($(this)) === value) {
        $(this).tab('show');
        $(el).attr('data-value', self._getTabName($(this)));
        return false;
      } else return null;
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

//---------------------------------------------------------------------
// Source file: ../srcjs/input_binding_sidebarCollapsed.js

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
    var newVal = (current === "collapsed") ? "expanded" : "collapsed";
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

//---------------------------------------------------------------------
// Source file: ../srcjs/input_binding_sidebarmenuExpanded.js

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
    if ($expanded.length === 1) {
      return $expanded.find('a').attr('href').substring(1);
    } else if ($(el).attr("data-expanded")) {
      return $(el).attr("data-expanded");
    } else {
      return null;
    }
  },
  setValue: function(el, value) {
    if (value !== null) {
      var firstChild = 'a[href="#' + value + '"]';
      var $ul = $(firstChild).parent().parent('.treeview-menu');
      $ul.addClass('menu-open');
      $ul.show();
    } else {
      var $ul = $(el).find('li ul.menu-open');
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

//---------------------------------------------------------------------
// Source file: ../srcjs/_end.js

});

//# sourceMappingURL=shinydashboard.js.map