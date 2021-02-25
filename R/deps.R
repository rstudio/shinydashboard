# Add dashboard dependencies to a tag object
dashboard_dependencies <- function(theme = NULL) {
  if (getOption("shiny.minified", TRUE)) {
    adminLTE_js <- "app.min.js"
    shinydashboard_js <- "shinydashboard.min.js"
    adminLTE_css <- c("AdminLTE.min.css", "_all-skins.min.css")
  } else {
    adminLTE_js <- "app.js"
    shinydashboard_js <- "shinydashboard.js"
    adminLTE_css <- c("AdminLTE.css", "_all-skins.css")
  }

  sdb_version <- utils::packageVersion("shinydashboard")

  if (!is_bs_theme(theme)) {
    return(list(
      htmlDependency(
        name = "AdminLTE",
        version = "2.3.8",
        package = "shinydashboard",
        src = "AdminLTE",
        script = adminLTE_js,
        stylesheet = adminLTE_css
      ),
      htmlDependency(
        name = "shinydashboard",
        version = sdb_version,
        package = "shinydashboard",
        src = "",
        script = shinydashboard_js,
        stylesheet = "shinydashboard.css"
      )
    ))
  }

  sdb_home <- system.file(package = "shinydashboard")

  sdb <- bslib::bs_dependency(
    input = sass::sass_file(file.path(sdb_home, "shinydashboard.scss")),
    theme = theme,
    name = "shinydashboard",
    version = sdb_version,
    cache_key_extra = sdb_version,
    .dep_args = list(script = file.path(sdb_home, shinydashboard_js))
  )

  admin_version <- "3.0.5"
  admin_home <- file.path(sdb_home, paste0("AdminLTE-", admin_version))
  owd <- setwd(file.path(admin_home, "scss"))
  on.exit(setwd(owd), add = TRUE)

  admin <- bslib::bs_dependency(
    input = sass::sass_file("AdminLTE.scss"),
    theme = theme,
    name = "AdminLTE",
    version = admin_version,
    .dep_args = list(script = file.path(admin_home, "adminlte.js"))
  )

  list(admin, sdb)
}
