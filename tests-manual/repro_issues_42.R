<<<<<<< 31102cf44a0361cb470aaa716f30397a926fddb3
## Tries to reproduce Github Issue: https://github.com/rstudio/shinydashboard/issues/42

=======
>>>>>>> e4c3bc1ef3418879040e39f52363c8e601b609cd
library(shiny)
library(shinydashboard)

ui <- dashboardPage(
  dashboardHeader(),
  dashboardSidebar(
    sidebarMenu(
      menuItem("Inputs", icon = icon("bar-chart-o"), tabName = "tabOne"
      )
    )
  ),
  dashboardBody(
    tabItems(
      tabItem("tabOne",
              box(title = "Test Box One",
                  status = "success",
                  solidHeader = TRUE,
                  collapsible = TRUE,
                  collapsed = TRUE,
                  plotOutput("plot", height = 250),
                  verbatimTextOutput("boxOneText")
              ),
              box(
                actionButton("go", "Go")
              )
      )
    )
  )
)

server <-  function(input, output) {
  output$plot <- renderPlot({
    cat(paste("plotting", input$go, "\n"))
    plot(rnorm(1 + input$go), rnorm(1 + input$go))
  })
  output$boxOneText <- renderText({
    paste("Go counter:", input$go)
  })
}

shinyApp(ui, server)
