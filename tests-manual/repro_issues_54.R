<<<<<<< 31102cf44a0361cb470aaa716f30397a926fddb3
## Tries to reproduce Github Issue: https://github.com/rstudio/shinydashboard/issues/54
=======
# Working example
<<<<<<< 7e2d8ee5ec2d42bdf67b396a36e9fce3ce73d0fb
>>>>>>> e4c3bc1ef3418879040e39f52363c8e601b609cd
=======
## Tries to reproduce Github Issue: https://github.com/rstudio/shinydashboard/issues/54
>>>>>>> 228ee6faa3c1f4d6827a35be79a240b9027de4bd

# library(shiny)
# library(shinydashboard)
#
# sidebar <- dashboardSidebar(
#   sidebarMenu(menuItem("foo",
#                        menuSubItem("foo_"), tabName = "tabfoo"))
# )
#
#
# ui <- dashboardPage(
#   dashboardHeader(),
#   sidebar,
#   dashboardBody()
# )
#
# server <- function(input, output) {}
#
# shinyApp(ui, server)

# Not working example

library(shinydashboard)
library(shiny)

sidebar <- dashboardSidebar(
  sidebarMenuOutput("sbMenu")
)


ui <- dashboardPage(
  dashboardHeader(),
  sidebar,
  dashboardBody()
)

server <- function(input, output) {
  output$sbMenu <- renderMenu({
    sidebarMenu(menuItem("foo", menuSubItem("foo_"), tabName = "tabfoo"))
  })
}

shinyApp(ui, server)
