## Tries to reproduce Github Issue: https://github.com/rstudio/shinydashboard/issues/42

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
