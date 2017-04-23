#' Create a dashboard control sidebar.
#'
#' TODO: create functions that can create sub-components in control-sidebar,
#' like functions defined in dashboardSidebar.R
#'
#' @export
dashboardControlbar <- function(ctrlHTML = NULL) {

  if ( is.null(ctrlHTML) ) {

    HTML(paste0(
      '<!-- Control Sidebar -->
      <aside class="control-sidebar control-sidebar-dark">
      <!-- Create the tabs -->
      <ul class="nav nav-tabs nav-justified control-sidebar-tabs">
      <li class="active"><a href="#control-sidebar-home-tab" data-toggle="tab"><i class="fa fa-home"></i></a></li>
      <li><a href="#control-sidebar-settings-tab" data-toggle="tab"><i class="fa fa-gears"></i></a></li>
      </ul>
      <!-- Tab panes -->
      <div class="tab-content">
      <!-- Home tab content -->
      <div class="tab-pane active" id="control-sidebar-home-tab">
      <h3 class="control-sidebar-heading">Recent Activity</h3>
      <ul class="control-sidebar-menu">
      <li>
      <a href="javascript::;">
      <i class="menu-icon fa fa-code bg-purple"></i>
      <div class="menu-info">
      <h4 class="control-sidebar-subheading">shinydashboard development</h4>
      <p>TODO: complete control-sidebar module.</p>
      </div>
      </a>
      </li>
      </ul>
      <!-- /.control-sidebar-menu -->
      <h3 class="control-sidebar-heading">Tasks Progress</h3>
      <ul class="control-sidebar-menu">
      <li>
      <a href="javascript::;">
      <h4 class="control-sidebar-subheading">
      Custom Template Design
      <span class="label label-danger pull-right">70%</span>
      </h4>
      <div class="progress progress-xxs">
      <div class="progress-bar progress-bar-danger" style="width: 70%"></div>
      </div>
      </a>
      </li>
      <li>
      <a href="javascript::;">
      <h4 class="control-sidebar-subheading">
      Update Resume
      <span class="label label-danger pull-right">95%</span>
      </h4>
      <div class="progress progress-xxs">
      <div class="progress-bar progress-bar-success" style="width: 95%"></div>
      </div>
      </a>
      </li>
      <li>
      <a href="javascript::;">
      <h4 class="control-sidebar-subheading">
      Backend Framework
      <span class="label label-danger pull-right">68%</span>
      </h4>
      <div class="progress progress-xxs">
      <div class="progress-bar progress-bar-primary" style="width: 68%"></div>
      </div>
      </a>
      </li>
      </ul>
      <!-- /.control-sidebar-menu -->
      </div>
      <!-- /.tab-pane -->
      <!-- Stats tab content -->
      <div class="tab-pane" id="control-sidebar-stats-tab">Stats Tab Content</div>
      <!-- /.tab-pane -->
      <!-- Settings tab content -->
      <div class="tab-pane" id="control-sidebar-settings-tab">
      <form method="post">
      <h3 class="control-sidebar-heading">General Settings</h3>
      <div class="form-group">
      <label class="control-sidebar-subheading">
      Report panel usage
      <input type="checkbox" class="pull-right" checked>
      </label>
      <p>
      Some information about this general settings option
      </p>
      </div>
      <!-- /.form-group -->
      </form>
      </div>
      <!-- /.tab-pane -->
      <div class= "tab-pane" id="control-sidebar-theme-demo-options-tab"
      </div>
      </aside>
      <!-- /.control-sidebar -->
      <!-- Add the sidebar"s background. This div must be placed
      immediately after the control sidebar -->
      <div class="control-sidebar-bg"></div>
      '))

  } else {

    ctrlHTML

  }
}
