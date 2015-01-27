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

    // Find all tab links under sidebar-menu
    var $tablinks = $this.closest("ul.sidebar-menu").find("a[data-toggle='tab']");

    // If any other items are active, deactivate them
    $tablinks.not($this).parent("li").removeClass("active");
  };

  $(document).on('shown.bs.tab', '.sidebar-menu a[data-toggle="tab"]',
                 deactivateOtherTabs);


  // When document is ready, if there is a sidebar menu with no activated tabs,
  // activate the first one.
  var ensureActivatedTab = function() {
    var $tablinks = $("ul.sidebar-menu").find("a[data-toggle='tab']");

    if (! $tablinks.parent("li").hasClass("active") ) {
      $tablinks.first().tab("show");
    }
  };

  ensureActivatedTab();

  // Optionally disable sidebar
  if ($("section.sidebar").data("disable")) {
    $(".left-side").addClass("collapse-left");
    $(".right-side").addClass("strech");
    $(".navbar > .sidebar-toggle").hide();
  }


  // htmlReplaceOutputBinding
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

});
