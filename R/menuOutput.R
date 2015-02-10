#' Create a dropdown menu output
#'
#' This is the UI-side function for creating a dynamic dropdown menu.
#'
#' @param outputId Output variable name.
#' @seealso \code{\link{renderDropdownMenu}} for the corresponding server-side
#'   function and examples, and \code{\link{dropdownMenu}} for the corresponding
#'   function for generating static menus.
#' @export
dropdownMenuOutput <- function(outputId) {
  tags$li(id = outputId, class = "shinydashboard-menu-output")
}

#' Dropdown menu output
#'
#' This is the server-side function for creating a dynamic dropdown menu.
#'
#' @inheritParams shiny::renderUI
#' @seealso \code{\link{dropdownMenuOutput}} for the corresponding UI-side
#'   function, and \code{\link{dropdownMenu}} for the corresponding function for
#'   generating static menus.
#'
#' @examples
#' ## Only run this example in interactive R sessions
#' if (interactive()) {
#' library(shiny)
#'
#' # Example message data in a data frame
#' messageData <- data.frame(
#'   from = c("Admininstrator", "New User", "Support"),
#'   message = c(
#'     "Sales are steady this month.",
#'     "How do I register?",
#'     "The new server is ready."
#'   ),
#'   stringsAsFactors = FALSE
#' )
#'
#' ui <- dashboardPage(
#'   dashboardHeader(
#'     title = "Dynamic menus",
#'     dropdownMenuOutput("messageMenu")
#'   ),
#'   dashboardSidebar(),
#'   dashboardBody(
#'     fluidRow(
#'       box(
#'         title = "Controls",
#'         sliderInput("slider", "Number of observations:", 1, 100, 50)
#'       )
#'     )
#'   )
#' )
#'
#' server <- function(input, output) {
#'   output$messageMenu <- renderUI({
#'     # Code to generate each of the messageItems here, in a list. messageData
#'     # is a data frame with two columns, 'from' and 'message'.
#'     # Also add on slider value to the message content, so that messages update.
#'     msgs <- apply(messageData, 1, function(row) {
#'       messageItem(
#'         from = row[["from"]],
#'         message = paste(row[["message"]], input$slider)
#'       )
#'     })
#'
#'     dropdownMenu(type = "messages", .list = msgs)
#'   })
#' }
#'
#' shinyApp(ui, server)
#' }
#' @export
renderDropdownMenu <- shiny::renderUI
