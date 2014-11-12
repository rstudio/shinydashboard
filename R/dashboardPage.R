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
dashboardPage <- function(header, sidebar, body) {

  tagAssert(header, type = "header", class = "header")
  tagAssert(sidebar, type = "section", class = "sidebar")
  tagAssert(body, type = "section", class = "content")

  page <- tagList(
    # Need to add classes to <body>. Shiny doesn't have a way of doing that
    # directly, so we'll do it with jQuery.
    tags$script(type="text/javascript",
      "$('body').addClass('skin-blue');
       $('body').css('min-height', '611px');"
    ),
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

  addDeps(shiny::bootstrapPage(page))
}
