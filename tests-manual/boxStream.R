library(shiny)
library(shinydashboard)

ui <- dashboardPage(
    dashboardHeader(),
    dashboardSidebar(),
    dashboardBody(
        valueBoxOutput("value_box"),
        infoBoxOutput("info_box"),
        infoBox("Title", 45, "Subtitle", icon = icon("bar-chart"), id = "testbox"),
        valueBox(id = "someid", 45, "Subtitle", icon = icon("dashboard"))
    ),
    title = "Test Streaming"
)

server <- function(input, output, session) {
  value <- reactiveVal(45)
  output$value_box <- renderValueBox({
      valueBox(value(), "Subtitle", icon = icon("dashboard"))
  })
  output$info_box <- renderInfoBox({
      infoBox("Title", value(), "Subtitle", icon = icon("bar-chart"))
  })
    observe({
        invalidateLater(1000)
        isolate(value(value() + 1))
        print(paste("Updated value:", value()))
        updateBoxValue(
          session,
          someid = value(),
          testbox = value()
        )
    })
}

# Run the application
shinyApp(ui = ui, server = server)
