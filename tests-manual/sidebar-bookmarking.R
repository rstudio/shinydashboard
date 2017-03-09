# Run this app (with "live" URL bookmarking) to make sure that the sidebar state
# (collapsed/expanded state of the sidebar itself; selected menuItem and; if
# applicable, the expanded menuItem)

library(shinydashboard)
library(shiny)
library(threejs)

ui <- function(request) {
  dashboardPage(
    dashboardHeader(title = "Testing sidebar bookmarkability"),
    dashboardSidebar(
      uiOutput("sidebarControls"),
      sidebarMenu(id = "smenu",
        menuItem("Frontpage", tabName = "front"),
        menuItem("Models",
          menuSubItem("Linear model", "models1"),
          menuSubItem("Logistic regression", "models2")
        ),
        menuItem("Plots",
          helpText("This is help text"),
          menuSubItem("Scatterplot", "plots1"),
          menuSubItem("3D graph", "plots2")
        ),
        menuItem("Tables", tabName = "tables")
      )
    ),
    dashboardBody(
      tabItems(
        tabItem("front",
          h3("Click through the different tabs to see different content")
        ),
        tabItem("models1",
          h3("Here's a linear model"),
          verbatimTextOutput("models1")
        ),
        tabItem("models2",
          h3("Here's a logistic regression"),
          verbatimTextOutput("models2")
        ),
        tabItem("plots1",
          h3("Here's a 2D plot"),
          plotOutput("plots1")
        ),
        tabItem("plots2",
          h3("Here's a 3D plot"),
          scatterplotThreeOutput('plots2')
        ),
        tabItem("tables",
          h3("Here's a table"),
          tableOutput("tbl")
        )
      )
    )
  )
}
server <- function(input, output, session) {

  data <- function() mtcars

  output$sidebarControls <- renderUI({
     if (input$smenu %in% c("models1", "models2", "plots1")) {
       tagList(
         selectInput("xaxis", "X axis", names(data()), selected = input$xaxis),
         selectInput("yaxis", "Y axis", names(data()), selected = input$yaxis)
       )
     } else if (input$smenu == "plots2") {
       tagList(
         selectInput("xaxis", "X axis", names(data()), selected = input$xaxis),
         selectInput("yaxis", "Y axis", names(data()), selected = input$yaxis),
         selectInput("zaxis", "Z axis", names(data()), selected = input$zaxis)
       )
     }
  })

  formula <- reactive({
    req(input$yaxis, input$xaxis)
    as.formula(paste(input$yaxis, input$xaxis, sep = " ~ "))
  })

  output$models1 <- renderPrint({
    summary(glm(formula(), data = data()), family = "linear")
  })

  output$models2 <- renderPrint({
    summary(glm(formula(), data = data()), family = "binomial")
  })

  output$plots1 <- renderPlot({
    plot(formula(), data = data())
  })

  output$plots2 <- renderScatterplotThree({
    x <- data()[[input$xaxis]]
    y <- data()[[input$yaxis]]
    z <- data()[[input$zaxis]]
    scatterplot3js(x, y, z)
  })

  output$tbl <- renderTable({
    data()
  })

  observe({
    # Trigger this observer every time an input changes
    reactiveValuesToList(input)
    session$doBookmark()
  })
  onBookmarked(function(url) {
    updateQueryString(url)
  })

}

enableBookmarking("url")
shinyApp(ui, server)
