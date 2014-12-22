library(shinydashboard)

ui <- dashboardPage(
  dashboardHeader(title = "Custom font"),
  dashboardSidebar(),
  dashboardBody(
    tags$head(
      tags$link(rel = "stylesheet", type = "text/css", href = "custom.css")
    )
  )
)

server <- function(input, output) { }

shinyApp(ui, server)
