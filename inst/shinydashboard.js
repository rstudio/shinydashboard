/* jshint browser:true, jquery:true, indent:2 */
/* global Shiny */

$(function() {
  // This function handles a special case in the AdminLTE sidebar: when there
  // is a sidebar-menu with items, and one of those items has sub-items, and
  // they are used for tab navigation. Normally, if one of the items is
  // selected and then a sub-item is clicked, both the item and sub-item will
  // retain the "active" class, so they will both be highlighted. This happens
  // because they're not designed to be used together for tab panels. This
  // code ensures that only one item will have the "active" class.
  var deactivateOtherTabs = function() {
    var $this = $(this);
    var $sidebarMenu = $this.closest("ul.sidebar-menu");

    // Find all tab links under sidebar-menu
    var $tablinks = $sidebarMenu.find("a[data-toggle='tab']");

    // If any other items are active, deactivate them
    $tablinks.not($this).parent("li").removeClass("active");

    // Trigger event for the tabItemInputBinding
    $sidebarMenu.trigger('change.tabItemInputBinding');
  };

  $(document).on('shown.bs.tab', '.sidebar-menu a[data-toggle="tab"]',
                 deactivateOtherTabs);


  // When document is ready, if there is a sidebar menu with no activated tabs,
  // activate the one specified by `data-start-selected`, or if that's not
  // present, the first one.
  var ensureActivatedTab = function() {
    var $tablinks = $("ul.sidebar-menu").find("a").filter("[data-toggle='tab']");

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

  // sendMessage to sidebar when we programmatically disable it
  // (this ensure that the sidebar has the correct value)
  var updateSidebarVal = function(newVal) {
    var $obj = $('.shiny-bound-input#main-sidebar-id');
    var inputBinding = $obj.data('shiny-input-binding');
    alert($obj.attr('data-value'));
    if (!newVal) inputBinding.toggleValue($obj);
    else inputBinding.setValue($obj, newVal);
    alert($obj.attr('data-value'));
  };

  // Optionally disable sidebar
  if ($("section.sidebar").data("disable")) {
    $("body").addClass("sidebar-collapse");
    updateSidebarVal("collapsed");
    $(".navbar > .sidebar-toggle").hide();
  }

  // Trigger the resize event when the sidebar is collapsed/expanded
  // (this allows images to be responsive and resize themselves)
  $(document).on("click", ".sidebar-toggle", function() {
    $(window).trigger("resize");
    updateSidebarVal();
  });

 $(document).on("click", ".treeview > a", function() {
    $(this).next(".treeview-menu").trigger("shown");
  });

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

      Shiny.initializeInputs(el);
      Shiny.bindAll(el);
    }
  });
  Shiny.outputBindings.register(menuOutputBinding,
                                "shinydashboard.menuOutputBinding");


  // tabItemInputBinding
  // ------------------------------------------------------------------
  // Based on Shiny.tabItemInputBinding, but customized for tabItems in
  // shinydashboard, which have a slightly different structure.
  var tabItemInputBinding = new Shiny.InputBinding();
  $.extend(tabItemInputBinding, {
    find: function(scope) {
      return $(scope).find('ul.sidebar-menu');
    },
    getValue: function(el) {
      var anchor = $(el).find('li:not(.treeview).active').children('a');
      if (anchor.length === 1)
        return this._getTabName(anchor);

      return null;
    },
    setValue: function(el, value) {
      var self = this;
      var anchors = $(el).find('li:not(.treeview)').children('a');
      anchors.each(function() {
        if (self._getTabName($(this)) === value) {
          $(this).tab('show');
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



  // sidebarInputBinding
  // ------------------------------------------------------------------
  var sidebarInputBinding = new Shiny.InputBinding();
  $.extend(sidebarInputBinding, {
    find: function(scope) {
      return $(scope).find('#main-sidebar-id');
    },
    getValue: function(el) {
      return $(el).attr("data-value");
      // if ($('body').hasClass('sidebar-collapse')) return 'collapsed';
      // else return 'expanded';
    },
    setValue: function(el, value) {
      $(el).attr("data-value", value);
      // if (value === 'collapsed') $('body').addClass('sidebar-collapse');
      // else  $('body').removeClass('sidebar-collapse');
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
      $(el).on('change.sidebarInputBinding', function() {
        callback();
      });
    },
    unsubscribe: function(el) {
      $(el).off('.sidebarInputBinding');
    }
  });
  Shiny.inputBindings.register(sidebarInputBinding,
    'shinydashboard.sidebarInputBinding');


});
