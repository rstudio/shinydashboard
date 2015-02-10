#' Create a value box output (client side)
#'
#' This is the UI-side function for creating a dynamic dropdown menu.
#'
#' @inheritParams valueBox
#' @param outputId Output variable name.
#' @seealso \code{\link{renderValueBox}} for the corresponding server-side
#'   function and examples.
#' @export
valueBoxOutput <- function(outputId, width = 4) {
  shiny::uiOutput(outputId, class = paste0("col-sm-", width))
}

#' Create a value box output (server side)
#'
#' This is the server-side function for creating a dynamic \code{\link{valueBox}}.
#'
#' @inheritParams shiny::renderUI
#' @seealso \code{\link{valueBoxOutput}} for the corresponding UI-side
#'   function.
#'
#' @examples
#' ## Only run this example in interactive R sessions
#' if (interactive()) {
#' library(shiny)
#'
#' ui <- dashboardPage(
#'   dashboardHeader(title = "valueBoxes"),
#'   dashboardSidebar(),
#'   dashboardBody(
#'     fluidRow(
#'       box(width = 2, actionButton("count", "Count")),
#'       valueBoxOutput("vbox1")
#'     )
#'   )
#' )
#'
#' server <- function(input, output) {
#'   output$vbox1 <- renderValueBox({
#'     valueBox(
#'       paste("Title", input$count),
#'       paste("subtitle", input$count),
#'       icon = icon("credit-card")
#'     )
#'   })
#' }
#'
#' shinyApp(ui, server)
#' }
#' @export
renderValueBox <- function(expr, env = parent.frame(), quoted = FALSE) {
  # Convert the expression to a function
  vbox_fun <- shiny::exprToFunction(expr, env, quoted)

  # Wrap that function in another function which strips off the outer div and
  # send it to renderUI.
  renderUI(function() {
    vbox <- vbox_fun()
    tagAssert(vbox, type = "div")

    # Strip off outer div, since it's already present in output
    vbox$children[[1]]
  })
}
