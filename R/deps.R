# Add an html dependency, without overwriting existing ones
appendDependencies <- function(x, value) {
  if (inherits(value, "html_dependency"))
    value <- list(value)

  old <- attr(x, "html_dependencies", TRUE)

  htmlDependencies(x) <- c(old, value)
  x
}

# Add dashboard dependencies to a tag object
addDeps <- function(x) {
  if (getOption("shiny.minified", TRUE)) {
    adminLTE_js <- "app.min.js"
    shinydashboard_js <- "shinydashboard.min.js"
    adminLTE_css <- c("AdminLTE.min.css", "_all-skins.min.css")
  } else {
    adminLTE_js <- "app.js"
    shinydashboard_js <- "shinydashboard.js"
    adminLTE_css <- c("AdminLTE.css", "_all-skins.css")
  }

  dashboardDeps <- list(
    htmlDependency("AdminLTE", "2.0.6",
      c(file = system.file("AdminLTE", package = "shinydashboard")),
      script = adminLTE_js,
      stylesheet = adminLTE_css
    ),
    htmlDependency("shinydashboard",
      as.character(utils::packageVersion("shinydashboard")),
      c(file = system.file(package = "shinydashboard")),
      script = shinydashboard_js,
      stylesheet = "shinydashboard.css"
    )
  )

  appendDependencies(x, dashboardDeps)
}
