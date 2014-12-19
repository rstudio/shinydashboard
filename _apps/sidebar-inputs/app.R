library(shinydashboard)

sidebar <- dashboardSidebar(
  sidebarSearchForm(label = "Search...", "searchText", "searchButton"),
  sliderInput("slider", "Slider:", 1, 20, 5),
  textInput("text", "Text input:"),
  dateRangeInput("daterange", "Date Range:")
)

ui <- dashboardPage(
  dashboardHeader(title = "Sidebar inputs"),
  sidebar,
  dashboardBody()
)

server <- function(input, output) { }

shinyApp(ui, server)
