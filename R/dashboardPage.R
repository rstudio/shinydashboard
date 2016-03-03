#' Dashboard page
#'
#' This creates a dashboard page for use in a Shiny app.
#'
#' @param header A header created by \code{dashboardHeader}.
#' @param sidebar A sidebar created by \code{dashboardSidebar}.
#' @param body A body created by \code{dashboardBody}.
#' @param title A title to display in the browser's title bar. If no value is
#'   provided, it will try to extract the title from the \code{dashboardHeader}.
#' @param skin A color theme. One of \code{"blue"}, \code{"black"},
#'   \code{"purple"}, \code{"green"}, \code{"red"}, or \code{"yellow"}.
#' @param sideBarMini TRUE or FALSE (default). False collapses sidebar completly
#'  while TRUE will show collapsed sidebar with icon(s). Title will, however,
#'  not become responsive.
#'
#' @seealso \code{\link{dashboardHeader}}, \code{\link{dashboardSidebar}},
#'   \code{\link{dashboardBody}}.
#' @examples
#' ## Only run this example in interactive R sessions
#' if (interactive()) {
#' # Basic dashboard page template
#' library(shiny)
#' shinyApp(
#'   ui = dashboardPage(
#'     dashboardHeader(),
#'     dashboardSidebar(),
#'     dashboardBody(),
#'     title = "Dashboard example"
#'   ),
#'   server = function(input, output) { }
#' )
#' }
#' @export
dashboardPage <- function(header, sidebar, body, title = NULL,
  skin = c("blue", "black", "purple", "green", "red", "yellow"), sideBarMini = FALSE) {

  tagAssert(header, type = "header", class = "main-header")
  tagAssert(sidebar, type = "aside", class = "main-sidebar")
  tagAssert(body, type = "div", class = "content-wrapper")
  skin <- match.arg(skin)

  extractTitle <- function(header) {
    x <- header$children[[1]]
    if (x$name == "span" &&
        !is.null(x$attribs$class) &&
        x$attribs$class == "logo" &&
        length(x$children) != 0) {

      x$children[[1]]
    } else {
      ""
    }
  }

  title <- title %OR% extractTitle(header)

  content <- div(class = "wrapper",
    header,
    sidebar,
    body
  )

  sideBar <- NULL
  if (sideBarMini == TRUE) {
    sideBar <- " sidebar-mini"
  }

  addDeps(
    tags$body(class = paste0("skin-", skin, sideBar), style = "min-height: 611px;",
      shiny::bootstrapPage(content, title = title)
    )
  )
}
