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
