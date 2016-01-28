library(shiny)
library(shinydashboard)

ui = shinyUI(dashboardPage(
  dashboardHeader(),
  dashboardSidebar(disable = TRUE),
  dashboardBody(
    box(title = "Report", width = 12, verbatimTextOutput("protocol")
    )

  )
))

server = shinyServer(function(input, output, session) {
  output$protocol <- renderPrint({
    print(numeric(10e3))
  })
})

shinyApp(ui, server)
