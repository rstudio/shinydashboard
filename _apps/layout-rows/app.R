library(shinydashboard)

# Can set box height from environment var
useboxheight <- Sys.getenv("USE_BOX_HEIGHT")
if (tolower(useboxheight) == "true") {
  row1height <- 300
  row2height <- 240
  row3height <- 110
} else {
  row1height <- row2height <- row3height <- NULL
}

body <- dashboardBody(
  fluidRow(
    box(
      title = "Box title",
      status = "primary",
      plotOutput("plot1", height = 240),
      height = row1height
    ),
    box(
      status = "warning",
      plotOutput("plot2", height = 240),
      height = row1height
    )
  ),

  # Boxes with solid headers
  fluidRow(
    box(
      title = "Title 1", width = 4, solidHeader = TRUE, status = "primary",
      height = row2height,
      sliderInput("orders", "Orders", min = 1, max = 500, value = 120),
      radioButtons("fill", "Fill", inline = TRUE,
        c(None = "none", Blue = "blue", Black = "black", red = "red")
      )
    ),
    box(
      title = "Title 2",
      width = 4, solidHeader = TRUE,
      height = row2height,
      p("Box content here")
    ),
    box(
      title = "Title 3",
      width = 4, solidHeader = TRUE, status = "warning",
      height = row2height,
      selectInput("spread", "Spread",
        choices = c("0%" = 0, "20%" = 20, "40%" = 40, "60%" = 60, "80%" = 80, "100%" = 100),
        selected = "60"
      )
    )
  ),

  # Solid backgrounds
  fluidRow(
    box(
      width = 4,
      height = row3height,
      background = "black",
      "A box with a solid black background"
    ),
    box(
      title = "Title 5",
      width = 4,
      height = row3height,
      background = "light-blue",
      "A box with a solid light-blue background"
    ),
    box(
      title = "Title 6",
      width = 4,
      height = row3height,
      background = "maroon",
      "A box with a solid maroon background"
    )

  )
)

ui <- dashboardPage(
  dashboardHeader(title = "Row layout"),
  dashboardSidebar(),
  body
)

server <- function(input, output) {

  histdata <- rnorm(500)

  output$plot1 <- renderPlot({
    if (is.null(input$orders) || is.null(input$fill))
      return()

    data <- histdata[seq(1, input$orders)]
    color <- input$fill
    if (color == "none")
      color <- NULL
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
