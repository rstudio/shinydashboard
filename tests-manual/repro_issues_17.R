library(shiny)
library(shinydashboard)

body <- dashboardBody(
  uiOutput("ui")
)

server <- function(input, output) {
  output$ui <- renderUI({
    box(title = "Collapse me",
        status = "warning", solidHeader = TRUE, collapsible = TRUE
    )
  })
}

shinyApp(
  ui = dashboardPage(
    dashboardHeader(),
    dashboardSidebar(),
    body
  ),
  server = server
)
