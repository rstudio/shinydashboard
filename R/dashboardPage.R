#' Dashboard page
#'
#' @examples
#' \donttest{
#' library(shiny)
#' shinyApp(
#'   ui = bootstrapPage(),
#'   server = function(input, output) {
#'   }
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
