dashboardDeps <- list(
  htmlDependency("AdminLTE", "1.2",
    c(file = system.file("AdminLTE", package = "shinydashboard")),
    script = c("app.js"),
    stylesheet = c("AdminLTE.css")
  )
)

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
  appendDependencies(x, dashboardDeps)
}
