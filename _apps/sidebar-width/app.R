library(shinydashboard)

shinyApp(
  ui = dashboardPage(
    dashboardHeader(
      title = "Title and sidebar 350 pixels wide",
      titleWidth = 350
    ),
    dashboardSidebar(
      width = 350,
      sidebarMenu(
        menuItem("Menu Item")
      )
    ),
    dashboardBody()
  ),
  server = function(input, output) { }
)
