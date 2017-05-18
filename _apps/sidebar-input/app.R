library(shiny)
library(shinydashboard)

ui <- dashboardPage(
  dashboardHeader(),
  dashboardSidebar(
    sidebarMenu(
      # Setting id makes input$tabs give the tabName of currently-selected tab
      id = "tabs",

      menuItem("Dashboard", tabName = "dashboard", icon = icon("dashboard")),
      menuItem("Widgets", icon = icon("th"), tabName = "widgets"),
      menuItem("Charts", icon = icon("bar-chart-o"),
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
    paste("You've selected:", input$tabs)
  })
}

shinyApp(ui, server)
