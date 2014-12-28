library(shinydashboard)


statusBoxes <- lapply(shinydashboard:::validStatuses, function(status) {
  box(title = status, status = status, solidHeader = TRUE, width = 2)
})

colorBoxes <- lapply(shinydashboard:::validColors, function(color) {
  box(title = color, background = color, width = 2)
})

body <- dashboardBody(
  fluidRow(statusBoxes),
  fluidRow(colorBoxes)
)

ui <- dashboardPage(
  dashboardHeader(title = "Colors and statuses"),
  dashboardSidebar(),
  body
)

server <- function(input, output) { }

shinyApp(ui, server)
