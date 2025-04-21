library(shinydashboard)

shinyApp(
  ui = dashboardPage(
    dashboardHeader(
      title = "Example of a long title that needs more space",
      titleWidth = 450
    ),
    dashboardSidebar(),
    dashboardBody(
      # Also add some custom CSS to make the title background area the same
      # color as the rest of the header.
      tags$head(tags$style(HTML(
        '
        .skin-blue .main-header .logo {
          background-color: #3c8dbc;
        }
        .skin-blue .main-header .logo:hover {
          background-color: #3c8dbc;
        }
      '
      )))
    )
  ),
  server = function(input, output) { }
)
