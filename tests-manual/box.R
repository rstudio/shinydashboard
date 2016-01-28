# A dashboard body with a row of infoBoxes and valueBoxes, and two rows of other boxes

library(shiny)
body <- dashboardBody(

  # infoBoxes
  fluidRow(
    infoBox(
      "Orders", uiOutput("orderNum2"), "Subtitle", icon = icon("credit-card")
    ),
    infoBox(
      "Approval Rating", "60%", icon = icon("line-chart"), color = "green",
      fill = TRUE
    ),
    infoBox(
      "Progress", uiOutput("progress2"), icon = icon("users"), color = "purple"
    )
  ),

  # valueBoxes
  fluidRow(
    valueBox(
      uiOutput("orderNum"), "New Orders", icon = icon("credit-card"),
      href = "http://google.com"
    ),
    valueBox(
      tagList("60", tags$sup(style="font-size: 20px", "%")),
      "Approval Rating", icon = icon("line-chart"), color = "green"
    ),
    valueBox(
      htmlOutput("progress"), "Progress", icon = icon("users"), color = "purple"
    )
  ),

  # Boxes
  fluidRow(
    box(status = "primary",
        sliderInput("orders", "Orders", min = 1, max = 2000, value = 650),
        selectInput("progress", "Progress",
                    choices = c("0%" = 0, "20%" = 20, "40%" = 40, "60%" = 60, "80%" = 80,
                                "100%" = 100)
        )
    ),
    box(title = "Histogram box title",
        status = "warning", solidHeader = TRUE, collapsible = TRUE,
        plotOutput("plot", height = 250)
    )
  ),

  # Boxes with solid color, using `background`
  fluidRow(
    # Box with textOutput
    box(
      title = "Status summary",
      background = "green",
      width = 4,
      textOutput("status")
    ),

    # Box with HTML output, when finer control over appearance is needed
    box(
      title = "Status summary 2",
      width = 4,
      background = "red",
      uiOutput("status2")
    ),

    box(
      width = 4,
      background = "light-blue",
      p("This is content. The background color is set to light-blue")
    )
  )
)

server <- function(input, output) {
  output$orderNum <- renderText({
    prettyNum(input$orders, big.mark=",")
  })

  output$orderNum2 <- renderText({
    prettyNum(input$orders, big.mark=",")
  })

  output$progress <- renderUI({
    tagList(input$progress, tags$sup(style="font-size: 20px", "%"))
  })

  output$progress2 <- renderUI({
    paste0(input$progress, "%")
  })

  output$status <- renderText({
    paste0("There are ", input$orders,
           " orders, and so the current progress is ", input$progress, "%.")
  })

  output$status2 <- renderUI({
    iconName <- switch(input$progress,
                       "100" = "ok",
                       "0" = "remove",
                       "road"
    )
    p("Current status is: ", icon(iconName, lib = "glyphicon"))
  })


  output$plot <- renderPlot({
    hist(rnorm(input$orders))
  })
}
# A dashboard header with 3 dropdown menus
header <- dashboardHeader(
  title = "Dashboard Demo",

  # Dropdown menu for messages
  dropdownMenu(type = "messages", badgeStatus = "success",
               messageItem("Support Team",
                           "This is the content of a message.",
                           time = "5 mins"
               ),
               messageItem("Support Team",
                           "This is the content of another message.",
                           time = "2 hours"
               ),
               messageItem("New User",
                           "Can I get some help?",
                           time = "Today"
               )
  ),

  # Dropdown menu for notifications
  dropdownMenu(type = "notifications", badgeStatus = "warning",
               notificationItem(icon = icon("users"), status = "info",
                                "5 new members joined today"
               ),
               notificationItem(icon = icon("warning"), status = "danger",
                                "Resource usage near limit."
               ),
               notificationItem(icon = icon("shopping-cart", lib = "glyphicon"),
                                status = "success", "25 sales made"
               ),
               notificationItem(icon = icon("user", lib = "glyphicon"),
                                status = "danger", "You changed your username"
               )
  ),

  # Dropdown menu for tasks, with progress bar
  dropdownMenu(type = "tasks", badgeStatus = "danger",
               taskItem(value = 20, color = "aqua",
                        "Refactor code"
               ),
               taskItem(value = 40, color = "green",
                        "Design new layout"
               ),
               taskItem(value = 60, color = "yellow",
                        "Another task"
               ),
               taskItem(value = 80, color = "red",
                        "Write documentation"
               )
  )
)

shinyApp(
  ui = dashboardPage(
    header,
    dashboardSidebar(),
    body
  ),
  server = server
)

