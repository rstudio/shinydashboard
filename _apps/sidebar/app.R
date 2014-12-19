library(shinydashboard)

sidebar <- dashboardSidebar(
  sidebarSearchForm(label = "Search...", "searchText", "searchButton"),
  sidebarMenu(
    menuItem("Dashboard", tabName = "dashboard", icon = icon("dashboard")),
    menuItem("Widgets", icon = icon("th"), tabName = "widgets", badgeLabel = "new",
             badgeColor = "green"
    ),
    menuItem("Charts", icon = icon("bar-chart-o"),
      menuSubItem("Chart sub-item 1", tabName = "subitem1"),
      menuSubItem("Chart sub-item 2", tabName = "subitem2")
    ),
    menuItem("Source code for app", icon = icon("file-code-o"),
      href = "https://github.com/rstudio/shinydashboard/blob/gh-pages/_apps/sidebar/app.R"
    )
  ),

  sliderInput("threshold", "Threshold:", 1, 20, 5),
  textInput("text", "Text input")
)

body <- dashboardBody(


)

ui <- dashboardPage(
  dashboardHeader(title = "My Dashboard"),
  sidebar,
  dashboardBody()
)

server <- function(input, output) { }

shinyApp(ui, server)
