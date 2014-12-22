library(shinydashboard)

sidebar <- dashboardSidebar(
  sidebarMenu(
    menuItem("Dashboard", tabName = "dashboard", icon = icon("dashboard")),
    menuItem("Widgets", icon = icon("th"), tabName = "widgets",
             badgeLabel = "new", badgeColor = "green")
  )
)

body <- dashboardBody(
  tabItems(
    tabItem(tabName = "dashboard",
      h2("Dashboard tab content")
    ),

    tabItem(tabName = "widgets",
      h2("Widgets tab content")
    )
  )
)

ui <- dashboardPage(
  dashboardHeader(title = "Simple tabs"),
  sidebar,
  body
)

server <- function(input, output) { }

shinyApp(ui, server)
