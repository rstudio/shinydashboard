library(shinydashboard)

body <- dashboardBody(
  fluidRow(
    column(
      width = 4,
      box(
        title = "Box title",
        status = "primary",
        width = NULL,
        plotOutput("plot1", height = 240)
      ),
      box(
        title = "Title 1",
        solidHeader = TRUE,
        status = "primary",
        width = NULL,
        sliderInput("orders", "Orders", min = 1, max = 500, value = 120),
        radioButtons(
          "fill",
          "Fill",
          inline = TRUE,
          c(None = "none", Blue = "blue", Black = "black", red = "red")
        )
      ),
      box(
        width = NULL,
        background = "black",
        "A box with a solid black background"
      )
    ),

    column(
      width = 4,
      box(
        status = "warning",
        width = NULL,
        plotOutput("plot2", height = 240)
      ),
      box(
        title = "Title 3",
        solidHeader = TRUE,
        status = "warning",
        width = NULL,
        selectInput(
          "spread",
          "Spread",
          choices = c(
            "0%" = 0,
            "20%" = 20,
            "40%" = 40,
            "60%" = 60,
            "80%" = 80,
            "100%" = 100
          ),
          selected = "60"
        )
      ),
      box(
        title = "Title 5",
        width = NULL,
        background = "light-blue",
        "A box with a solid light-blue background"
      )
    ),

    column(
      width = 4,
      box(
        title = "Title 2",
        solidHeader = TRUE,
        width = NULL,
        p("Box content here")
      ),
      box(
        title = "Title 6",
        width = NULL,
        background = "maroon",
        "A box with a solid maroon background"
      )
    )
  )
)

ui <- dashboardPage(
  dashboardHeader(title = "Column layout"),
  dashboardSidebar(),
  body
)

server <- function(input, output) {
  set.seed(122)
  histdata <- rnorm(500)

  output$plot1 <- renderPlot({
    if (is.null(input$orders) || is.null(input$fill)) return()

    data <- histdata[seq(1, input$orders)]
    color <- input$fill
    if (color == "none") color <- NULL
    hist(data, col = color)
  })

  output$plot2 <- renderPlot({
    spread <- as.numeric(input$spread) / 100
    x <- rnorm(1000)
    y <- x + rnorm(1000) * spread
    plot(x, y, pch = ".", col = "blue")
  })
}

shinyApp(ui, server)
