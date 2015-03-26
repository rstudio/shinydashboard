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
  dashboardDeps <- list(
    htmlDependency("AdminLTE", "2.0.6",
      c(file = system.file("AdminLTE", package = "shinydashboard")),
      script = "app.min.js",
      stylesheet = c("AdminLTE.min.css", "_all-skins.min.css")
    ),
    htmlDependency("shinydashboard",
      as.character(packageVersion("shinydashboard")),
      c(file = system.file(package = "shinydashboard")),
      script = "shinydashboard.js",
      stylesheet = "shinydashboard.css"
    )
  )

  appendDependencies(x, dashboardDeps)
}
