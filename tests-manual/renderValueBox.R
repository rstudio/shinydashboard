## Display count button with two boxes which show the incremented value
library(shiny)

ui <- dashboardPage(
  dashboardHeader(title = "Dynamic boxes"),
  dashboardSidebar(),
  dashboardBody(
    fluidRow(
      box(width = 2, actionButton("count", "Count")),
      infoBoxOutput("ibox"),
      valueBoxOutput("vbox")
    )
  )
)

server <- function(input, output) {
  output$ibox <- renderInfoBox({
    infoBox(
      "Title",
      input$count,
      icon = icon("credit-card")
    )
  })
  output$vbox <- renderValueBox({
    valueBox(
      "Title",
      input$count,
      icon = icon("credit-card")
    )
  })
}

shinyApp(ui, server)

