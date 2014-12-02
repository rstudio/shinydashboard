#' Dashboard page
#'
#' This creates a dashboard page for use in a Shiny app.
#'
#' @param header A header created by \code{dashboardHeader}.
#' @param sidebar A sidebar created by \code{dashboardSidebar}.
#' @param body A body created by \code{dashboardBody}.
#'
#' @seealso \code{\link{dashboardHeader}}, \code{\link{dashboardSidebar}},
#'   \code{\link{dashboardBody}}.
#' @examples
#' \donttest{
#' # Basic dashboard page template
#' library(shiny)
#' shinyApp(
#'   ui = dashboardPage(
#'     dashboardHeader(),
#'     dashboardSidebar(),
#'     dashboardBody()
#'   ),
#'   server = function(input, output) { }
#' )
#' }
#' @export
dashboardPage <- function(header, sidebar, body) {

  tagAssert(header, type = "header", class = "header")
  tagAssert(sidebar, type = "section", class = "sidebar")
  tagAssert(body, type = "section", class = "content")

  content <- tagList(
    header,
    div(class = "wrapper row-offcanvas row-offcanvas-left",
      tags$aside(class = "left-side sidebar-offcanvas",
        sidebar
      ),
      tags$aside(class = "right-side",
        tags$section(class = "content-header",
          h1("Dashboard", tags$small("Control panel"))
        ),
        body
      )
    )
  )

  addDeps(
    tags$body(class = "skin-blue", style = "min-height: 611px;",
      shiny::bootstrapPage(content)
    )
  )
}
