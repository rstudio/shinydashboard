library(shinydashboard)

body <- dashboardBody(
  fluidRow(
    box(plotOutput("plot1", height = 250)),

    box(
      "Box content here", br(), "More box content",
      sliderInput("slider", "Slider input:", 1, 100, 50),
      textInput("text", "Text input:")
    )
  ),

  # Title and status color
  fluidRow(
    box(title = "Histogram", status = "primary", plotOutput("plot2", height = 250)),

    box(
      title = "Inputs", status = "warning",
      "Box content here", br(), "More box content",
      sliderInput("slider", "Slider input:", 1, 100, 50),
      textInput("text", "Text input:")
    )
  ),

  # Solid header, collapsible
  fluidRow(
    box(
      title = "Histogram", status = "primary", solidHeader = TRUE,
      collapsible = TRUE,
      plotOutput("plot3", height = 250)
    ),

    box(
      title = "Inputs", status = "warning", solidHeader = TRUE,
      "Box content here", br(), "More box content",
      sliderInput("slider", "Slider input:", 1, 100, 50),
      textInput("text", "Text input:")
    )
  ),

  # Solid background, collapsible
  fluidRow(
    box(
      title = "Histogram", background = "maroon", solidHeader = TRUE,
      plotOutput("plot4", height = 250)
    ),

    box(
      title = "Inputs", background = "black",
      "Box content here", br(), "More box content",
      sliderInput("slider", "Slider input:", 1, 100, 50),
      textInput("text", "Text input:")
    )
  )

)

ui <- dashboardPage(
  dashboardHeader(title = "Boxes"),
  dashboardSidebar(),
  body
)

server <- function(input, output) {
  set.seed(122)
  histdata <- rnorm(500)

  output$plot1 <- renderPlot({
    hist(histdata)
  })

  output$plot2 <- renderPlot({
    hist(histdata)
  })

  output$plot3 <- renderPlot({
    hist(histdata)
  })

  output$plot4 <- renderPlot({
    hist(histdata)
  })
}

shinyApp(ui, server)
