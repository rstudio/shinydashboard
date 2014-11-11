#' Dashboard page
#'
#' @examples
#' library(shiny)
#' shinyApp(
#'   ui = dashboardPage(),
#'   server = function(input, output) {
#'   }
#' )
#' @export
dashboardPage <- function(header, ...) {
  deps <- list(
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
      stylesheet = c("AdminLTE.css")
    )
  )

  tagAssert(header, type = "header", class = "header")

  page <- tagList(
    # Need to add classes to <body>. Shiny doesn't have a way of doing that
    # directly, so we'll do it with jQuery.
    tags$script(type="text/javascript",
      "$('body').addClass('skin-blue');
       $('body').css('min-height', '611px');"
    ),
    header,
    ...
  )

  addDependencies(shiny::bootstrapPage(page), deps)
}
