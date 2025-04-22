#' A container for tab items
#'
#' @param ... Items to put in the container. Each item should be a
#'   [tabItem()].
#'
#' @seealso [menuItem()], [menuSubItem()],
#'   [tabItem()]. See [sidebarMenu()] for a usage example.
#' @export
tabItems <- function(...) {
  lapply(list(...), tagAssert, class = "tab-pane")

  div(class = "tab-content", ...)
}

#' One tab to put inside a tab items container
#'
#' @param tabName The name of a tab. This must correspond to the `tabName`
#'   of a [menuItem()] or [menuSubItem()].
#' @param ... Contents of the tab.
#'
#' @seealso [menuItem()], [menuSubItem()],
#'   [tabItems()]. See [sidebarMenu()] for a usage example.
#' @export
tabItem <- function(tabName = NULL, ...) {
  if (is.null(tabName)) stop("Need tabName")

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
#' This function controls the active tab of [tabItems()] from the
#' server. It behaves just like [shiny::updateTabsetPanel()].
#'
#' @inheritDotParams shiny::updateTabsetPanel
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
updateTabItems <- function(...) {
  shiny::updateTabsetPanel(...)
}
