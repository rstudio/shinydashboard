library(shinydashboard)

skin <- Sys.getenv("DASHBOARD_SKIN")
skin <- tolower(skin)
if (skin == "")
  skin <- "blue"


sidebar <- dashboardSidebar(
  sidebarSearchForm(label = "Search...", "searchText", "searchButton"),
  sidebarMenu(
    menuItem("Dashboard", tabName = "dashboard", icon = icon("dashboard")),
    menuItem("Widgets", icon = icon("th"), tabName = "widgets", badgeLabel = "new",
             badgeColor = "green"
    ),
    menuItem("Charts", icon = icon("bar-chart-o"),
      menuSubItem("Chart sub-item 1", tabName = "subitem1"),
      menuSubItem("Chart sub-item 2", tabName = "subitem2")
    ),
    menuItem("Source code for app", icon = icon("file-code-o"),
      href = "https://github.com/rstudio/shinydashboard/blob/gh-pages/_apps/sidebar/app.R"
    )
  )
)

body <- dashboardBody(
  tabItems(
    tabItem("dashboard",
      fluidRow(
        box(
          title = "Box title",
          status = "primary",
          plotOutput("plot1", height = 240),
          height = 300
        ),
        box(
          status = "warning",
          plotOutput("plot2", height = 280),
          height = 300
        )
      ),

      # Boxes with solid headers
      fluidRow(
        box(
          title = "Title 1", width = 4, solidHeader = TRUE, status = "primary",
          sliderInput("orders", "Orders", min = 1, max = 500, value = 120),
          radioButtons("fill", "Fill", # inline = TRUE,
            c(None = "none", Blue = "blue", Black = "black", red = "red")
          )
        ),
        box(
          title = "Title 2",
          width = 4, solidHeader = TRUE,
          p("Box content here")
        ),
        box(
          title = "Title 3",
          width = 4, solidHeader = TRUE, status = "warning",
          selectInput("spread", "Spread",
            choices = c("0%" = 0, "20%" = 20, "40%" = 40, "60%" = 60, "80%" = 80, "100%" = 100),
            selected = "60"
          )
        )
      ),

      # Solid backgrounds
      fluidRow(
        box(
          title = "Title 4",
          width = 4,
          background = "black",
          "A box with a solid black background"
        ),
        box(
          title = "Title 5",
          width = 4,
          background = "light-blue",
          "A box with a solid light-blue background"
        ),
        box(
          title = "Title 6",
          width = 4,
          background = "maroon",
          "A box with a solid maroon background"
        )

      )
    )
  )
)

messages <- dropdownMenu(type = "messages",
  messageItem(
    from = "Sales Dept",
    message = "Sales are steady this month."
  ),
  messageItem(
    from = "New User",
    message = "How do I register?",
    icon = icon("question"),
    time = "13:45"
  ),
  messageItem(
    from = "Support",
    message = "The new server is ready.",
    icon = icon("life-ring"),
    time = "2014-12-01"
  )
)

notifications <- dropdownMenu(type = "notifications", badgeStatus = "warning",
  notificationItem(
    text = "5 new users today",
    icon("users")
  ),
  notificationItem(
    text = "12 items delivered",
    icon("truck"),
    status = "success"
  ),
  notificationItem(
    text = "Server load at 86%",
    icon = icon("exclamation-triangle"),
    status = "warning"
  )
)

tasks <- dropdownMenu(type = "tasks", badgeStatus = "success",
  taskItem(value = 90, color = "green",
    "Documentation"
  ),
  taskItem(value = 17, color = "aqua",
    "Project X"
  ),
  taskItem(value = 75, color = "yellow",
    "Server deployment"
  ),
  taskItem(value = 80, color = "red",
    "Overall project"
  )
)

header <- dashboardHeader(
  title = "My Dashboard",
  messages,
  notifications,
  tasks
)

ui <- dashboardPage(header, sidebar, body, skin = skin)

server <- function(input, output) {

  set.seed(122)
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
