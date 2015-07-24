#' A container for tab items
#'
#' @param ... Items to put in the container. Each item should be a
#'   \code{\link{tabItem}}.
#'
#' @seealso \code{\link{menuItem}}, \code{\link{menuSubItem}},
#'   \code{\link{tabItem}}. See \code{\link{sidebarMenu}} for a usage example.
#' @export
tabItems <- function(...) {
  lapply(list(...), tagAssert, class = "tab-pane")

  div(class = "tab-content", ...)
}

#' One tab to put inside a tab items container
#'
#' @param tabName The name of a tab. This must correspond to the \code{tabName}
#'   of a \code{\link{menuItem}} or \code{\link{menuSubItem}}.
#' @param ... Contents of the tab.
#'
#' @seealso \code{\link{menuItem}}, \code{\link{menuSubItem}},
#'   \code{\link{tabItems}}. See \code{\link{sidebarMenu}} for a usage example.
#' @export
tabItem <- function(tabName = NULL, ...) {
  if (is.null(tabName))
    stop("Need tabName")

  validateTabName(tabName)

  div(
    role = "tabpanel",
    class = "tab-pane",
    id = paste0("shiny-tab-", tabName),
    ...
  )
}

#' Change the selected tab on the client
#'
#' This function controls the active tab of \code{\link{tabItems}} from the
#' server. It behaves just like \code{\link[shiny]{updateTabsetPanel}}.
#'
#' @inheritParams shiny::updateTabsetPanel
#' @examples
#' ## Only run this example in interactive R sessions
#' if (interactive()) {
#'
#' ui <- dashboardPage(
#'   dashboardHeader(title = "Simple tabs"),
#'   dashboardSidebar(
#'     sidebarMenu(
#'       id = "tabs",
#'       menuItem("Dashboard", tabName = "dashboard", icon = icon("dashboard")),
#'       menuItem("Widgets", tabName = "widgets", icon = icon("th"))
#'     ),
#'     actionButton('switchtab', 'Switch tab')
#'   ),
#'   dashboardBody(
#'     tabItems(
#'       tabItem(tabName = "dashboard",
#'         h2("Dashboard tab content")
#'       ),
#'       tabItem(tabName = "widgets",
#'         h2("Widgets tab content")
#'       )
#'     )
#'   )
#' )
#'
#' server <- function(input, output, session) {
#'   observeEvent(input$switchtab, {
#'     newtab <- switch(input$tabs,
#'       "dashboard" = "widgets",
#'       "widgets" = "dashboard"
#'     )
#'     updateTabItems(session, "tabs", newtab)
#'   })
#' }
#'
#' shinyApp(ui, server)
#' }
#' @export
updateTabItems <- shiny::updateTabsetPanel
