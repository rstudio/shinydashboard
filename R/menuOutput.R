#' Create a dynamic menu output for shinydashboard (client side)
#'
#' This can be used as a placeholder for dynamically-generated
#' \code{\link{dropdownMenu}}, \code{\link{notificationItem}},
#' \code{\link{messageItem}}, \code{\link{taskItem}} \code{\link{sidebarMenu}},
#' or \code{\link{menuItem}}. If called directly, you must make sure to supply
#' the correct type of tag. It is simpler to use the wrapper functions if
#' present; for example, \code{\link{dropdownMenuOutput}} and
#' \code{\link{sidebarMenuOutput}}.
#'
#' @param outputId Output variable name.
#' @param tag A tag function, like \code{tags$li} or \code{tags$ul}.
#'
#' @family menu outputs
#' @seealso \code{\link{renderMenu}} for the corresponding server side function
#'   and examples.
menuOutput <- function(outputId, tag = tags$li) {
  tag(id = outputId, class = "shinydashboard-menu-output")
}


#' Create a dropdown menu output (client side)
#'
#' This is the UI-side function for creating a dynamic dropdown menu.
#'
#' @inheritParams menuOutput
#' @family menu outputs
#' @seealso \code{\link{renderMenu}} for the corresponding server-side function
#'   and examples, and \code{\link{dropdownMenu}} for the corresponding function
#'   for generating static menus.
#' @export
dropdownMenuOutput <- function(outputId) {
  menuOutput(outputId = outputId, tag = tags$li)
}


#' Create a sidebar menu output (client side)
#'
#' This is the UI-side function for creating a dynamic sidebar menu.
#'
#' @inheritParams menuOutput
#' @family menu outputs
#' @seealso \code{\link{renderMenu}} for the corresponding server-side function
#'   and examples, and \code{\link{sidebarMenu}} for the corresponding function
#'   for generating static sidebar menus.
#' @export
sidebarMenuOutput <- function(outputId) {
  menuOutput(outputId = outputId, tag = tags$ul)
}

#' Create a sidebar menu item output (client side)
#'
#' This is the UI-side function for creating a dynamic sidebar menu item.
#'
#' @inheritParams menuOutput
#' @family menu outputs
#' @seealso \code{\link{renderMenu}} for the corresponding server-side function
#'   and examples, and \code{\link{menuItem}} for the corresponding function
#'   for generating static sidebar menus.
#' @export
menuItemOutput <- function(outputId) {
  menuOutput(outputId = outputId, tag = tags$li)
}


#' Create dynamic menu output (server side)
#'
#' @inheritParams shiny::renderUI
#'
#' @seealso \code{\link{menuOutput}} for the corresponding client side function
#'   and examples.
#' @family menu outputs
#' @export
#' @examples
#' ## Only run these examples in interactive R sessions
#'
#' if (interactive()) {
#' library(shiny)
#' # ========== Dynamic sidebarMenu ==========
#' ui <- dashboardPage(
#'   dashboardHeader(title = "Dynamic sidebar"),
#'   dashboardSidebar(
#'     sidebarMenuOutput("menu")
#'   ),
#'   dashboardBody()
#' )
#'
#' server <- function(input, output) {
#'   output$menu <- renderMenu({
#'     sidebarMenu(
#'       menuItem("Menu item", icon = icon("calendar"))
#'     )
#'   })
#' }
#'
#' shinyApp(ui, server)
#'
#' # ========== Dynamic dropdownMenu ==========
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
#'   output$messageMenu <- renderMenu({
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
renderMenu <- function(expr, env = parent.frame(), quoted = FALSE, outputArgs = list()) {
  if (!quoted) {
    expr <- substitute(expr)
    quoted <- TRUE
  }
  shiny::renderUI(expr, env = env, quoted = quoted, outputArgs = outputArgs)
}

# R CMD check thinks that shiny::renderUI has an undeclared global variable
# called "func".
utils::globalVariables("func")

#' Create a dropdown menu output (server side; deprecated)
#'
#' This is the server-side function for creating a dynamic dropdown menu.
#'
#' @inheritParams shiny::renderUI
#' @export
renderDropdownMenu <- function(expr, env = parent.frame(), quoted = FALSE) {
  .Deprecated("renderMenu")
   shiny::renderUI(expr, env, quoted, func = FALSE)
}
