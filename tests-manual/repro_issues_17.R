<<<<<<< 7e2d8ee5ec2d42bdf67b396a36e9fce3ce73d0fb
<<<<<<< 31102cf44a0361cb470aaa716f30397a926fddb3
## Tries to reproduce Github Issue: https://github.com/rstudio/shinydashboard/issues/17

=======
>>>>>>> e4c3bc1ef3418879040e39f52363c8e601b609cd
=======
if(interactive()){
## Tries to reproduce Github Issue: https://github.com/rstudio/shinydashboard/issues/17
>>>>>>> 228ee6faa3c1f4d6827a35be79a240b9027de4bd
library(shiny)
library(shinydashboard)

body <- dashboardBody(
  uiOutput("ui")
)

server <- function(input, output) {
  output$ui <- renderUI({
    box(title = "Collapse me",
        status = "warning", solidHeader = TRUE, collapsible = TRUE
    )
  })
}

shinyApp(
  ui = dashboardPage(
    dashboardHeader(),
    dashboardSidebar(),
    body
  ),
  server = server
)
}
