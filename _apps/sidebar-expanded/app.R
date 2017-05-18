library(shiny)
library(shinydashboard)

ui <- dashboardPage(
  dashboardHeader(),
  dashboardSidebar(
    sidebarMenu(
      menuItem("Dashboard", tabName = "dashboard", icon = icon("dashboard")),
      menuItem("Widgets", icon = icon("th"), tabName = "widgets"),
      menuItem("Charts", icon = icon("bar-chart-o"), startExpanded = TRUE,
        menuSubItem("Sub-item 1", tabName = "subitem1"),
        menuSubItem("Sub-item 2", tabName = "subitem2")
      )
    ),
    textOutput("res")
  ),
  dashboardBody(
    tabItems(
      tabItem("dashboard", "Dashboard tab content"),
      tabItem("widgets", "Widgets tab content"),
      tabItem("subitem1", "Sub-item 1 tab content"),
      tabItem("subitem2", "Sub-item 2 tab content")
    )
  )
)

server <- function(input, output, session) {
  output$res <- renderText({
    req(input$sidebarItemExpanded)
    paste("Expanded menuItem:", input$sidebarItemExpanded)
  })
}

shinyApp(ui, server)
