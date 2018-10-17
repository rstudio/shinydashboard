# `.` is used in renderValueBox
utils::globalVariables(".")

#' Create an info or value box output (client side)
#'
#' This is the UI-side function for creating a dynamic \code{\link{valueBox}} or
#' \code{\link{infoBox}}.
#'
#' @inheritParams valueBox
#' @param outputId Output variable name.
#' @seealso \code{\link{renderValueBox}} for the corresponding server-side
#'   function and examples.
#' @export
valueBoxOutput <- function(outputId, width = 4) {
  shiny::uiOutput(outputId, class = paste0("col-sm-", width))
}

#' @rdname valueBoxOutput
#' @export
infoBoxOutput <- valueBoxOutput


#' Create an info or value box output (server side)
#'
#' This is the server-side function for creating a dynamic
#' \code{\link{valueBox}} or \code{\link{infoBox}}.
#'
#' @inheritParams shiny::renderUI
#' @seealso \code{\link{valueBoxOutput}} for the corresponding UI-side function.
#'
#' @examples
#' ## Only run this example in interactive R sessions
#' if (interactive()) {
#' library(shiny)
#'
#' ui <- dashboardPage(
#'   dashboardHeader(title = "Dynamic boxes"),
#'   dashboardSidebar(),
#'   dashboardBody(
#'     fluidRow(
#'       box(width = 2, actionButton("count", "Count")),
#'       infoBoxOutput("ibox"),
#'       valueBoxOutput("vbox")
#'     )
#'   )
#' )
#'
#' server <- function(input, output) {
#'   output$ibox <- renderInfoBox({
#'     infoBox(
#'       "Title",
#'       input$count,
#'       icon = icon("credit-card")
#'     )
#'   })
#'   output$vbox <- renderValueBox({
#'     valueBox(
#'       "Title",
#'       input$count,
#'       icon = icon("credit-card")
#'     )
#'   })
#' }
#'
#' shinyApp(ui, server)
#' }
#' @import promises
#' @export
renderValueBox <- function(expr, env = parent.frame(), quoted = FALSE) {
  # Convert the expression to a function
  vbox_fun <- shiny::exprToFunction(expr, env, quoted)

  # Wrap that function in another function which strips off the outer div and
  # send it to renderUI.
  shiny::renderUI({
    vbox <- vbox_fun()
    if (is.promising(vbox)) {
      vbox %...T>%
        tagAssert(type = "div") %...>%
        { .$children[[1]] }
    } else {
      tagAssert(vbox, type = "div")

      # Strip off outer div, since it's already present in output
      vbox$children[[1]]
    }
  })
}

#' @rdname renderValueBox
#' @export
renderInfoBox <- renderValueBox
