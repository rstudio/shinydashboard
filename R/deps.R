dashboardDeps <- list(
  htmlDependency("font-awesome", "4.1.0",
    src = c(href = "//cdnjs.cloudflare.com/ajax/libs/font-awesome/4.1.0/css/"),
    stylesheet = "font-awesome.min.css"
  ),
  htmlDependency("ionicons", "1.5.2",
    src = c(href = "http://code.ionicframework.com/ionicons/1.5.2/css/"),
    stylesheet = "ionicons.min.css"
  ),
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
