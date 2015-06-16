library(shinydashboard)

shinyApp(
  ui = dashboardPage(
    dashboardHeader(title = "Example of a long title that needs more space"),
    dashboardSidebar(),
    dashboardBody(
      tags$head(tags$style(HTML('
        body > .main-header .logo {
          width: 450px;
        }
        /* Need this particular CSS selector to override color from skin-blue.
           For other skins (like skin-black), use the appropriate color name */
        .skin-blue .main-header .logo {
          background-color: #3c8dbc;
        } 
        body > .main-header .navbar {
          margin-left: 450px;
        }
      ')))
    )
  ),
  server = function(input, output) { }
)
