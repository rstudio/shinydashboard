/* jshint browser:true, jquery:true, indent:2 */
/* global Shiny */

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
  var updateSidebarVal = function() {
    var $obj = $('.shiny-bound-input.main-sidebar');
    var inputBinding = $obj.data('shiny-input-binding');
    inputBinding.toggleValue($obj);
    $obj.trigger('change');

  };

  var updateItemExpanded = function(val) {
    var $obj = $('section.sidebar.shiny-bound-input');
    var inputBinding = $obj.data('shiny-input-binding');
    inputBinding.setValue($obj, val);
    $obj.trigger('change');

  };


  // Optionally disable sidebar
  if ($("section.sidebar").data("disable")) {
    $("body").addClass("sidebar-collapse");
    $(".navbar > .sidebar-toggle").hide();
  }

  // Trigger the resize event when the sidebar is collapsed/expanded
  // (this allows images to be responsive and resize themselves)
  $(document).on("click", ".sidebar-toggle", function() {
    $(window).trigger("resize");
    updateSidebarVal();
  });


  // ...
  $(document).on("click", "a[href^='#shiny-tab-']", function() {
    console.log(this);
    if ($(this).parent().hasClass('treeview')) {
      updateItemExpanded($(this).attr('href').substring(1));
    }
  });

  // var dataExpanded = $("section.sidebar").attr("data-expanded");
  // updateItemExpanded(dataExpanded);

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
      // return $('ul.sidebar-menu').attr('id') + "Expanded";
    },

    /* */
    initialize: function(el) {
      // if ($(el).attr("data-expanded")) return $(el).attr("data-expanded");
      $(this).trigger('change');
    },
    /* */

    // the value is the href of the open menuItem (or NULL if there's
    // no open menuItem)
    getValue: function(el) {
      var $expanded = $(el).find('li ul.menu-open');
      if ($expanded.length === 1) return $expanded.prev().attr('href').substring(1);
      else if ($(el).attr("data-expanded")) return $(el).attr("data-expanded");
      else return null;
    },
    setValue: function(el, value) {
      // first hide everything
      var $uls = $('.treeview-menu');
      //$uls.each(function() {
        //$ul.removeClass('menu-open');
        //$ul.hide();
      //});
      // then show the appropriate menu
      if (value !== null) {
        var $ul = $('a[href="#' + value + '"]').next();
        $ul.addClass('menu-open');
        $ul.show();
      }
      /*
      var $ul = $('a[href="' + value + '"').next();
      if (value === "open") {
        $ul.addClass('menu-open');
        $ul.show();
      } else {
        $ul.removeClass('menu-open');
        $ul.hide();
      }
      */
    },
    /*
    toggleValue: function(el) {
      var current = this.getValue(el);
      var newVal = (current == "open") ? "closed" : "open";
      this.setValue(el, newVal);
    },
    */
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
