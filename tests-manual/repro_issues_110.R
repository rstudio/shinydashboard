## Tries to reproduce Github Issue: https://github.com/rstudio/shinydashboard/issues/110
library(shiny)
library(shinydashboard)

header <- dashboardHeader(title = "Dashboard Demo")

body <- dashboardBody()

server <- function(input, output) {
}

sidebar <- dashboardSidebar(
  sidebarSearchForm(label = "Enter a number", "searchText", "searchButton"),
  sidebarMenu(
    # Setting id makes input$tabs give the tabName of currently-selected tab
    id = "tabs",
    menuItem(
      "Dashboard",
      tabName = "dashboard",
      icon = icon("dashboard")
    ),
    menuItem(
      "Widgets",
      icon = icon("th"),
      tabName = "widgets",
      badgeLabel = "new",
      badgeColor = "green"
    ),
    menuItem(
      "Charts",
      icon = icon("bar-chart-o"),
      menuSubItem("Sub-item 1", tabName = "subitem1"),
      menuSubItem("Sub-item 2", tabName = "subitem2")
    ),
    menuItem(
      "test stack",
      icon = icon("fa fa-user-plus"),
      icon("user", "fa-stack-1x"),
      icon("ban", "fa-stack-2x"),
      span(shiny::icon("fa fa-user-plus"))
    )
  ),
  sidebarMenuOutput("menu")
)

ui <- dashboardPage(header,
                    sidebar,
                    body)

shinyApp(ui, server)
