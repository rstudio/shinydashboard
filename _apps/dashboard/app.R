library(shinydashboard)
library(dygraphs)
library(leaflet)

header <- dashboardHeader(
  title = "Dashboard Demo",
  dropdownMenu(type = "messages", badgeStatus = "success",
    messageItem("Support Team",
      "Message content here.",
      time = "5 mins"
    ),
    messageItem("Support Team",
      "Message content here.",
      time = "2 hours"
    ),
    messageItem("New User",
      "Message content here.",
      time = "Today"
    )
  ),
  # Notifications
  dropdownMenu(type = "notifications", badgeStatus = "warning",
    notificationItem(icon = icon("users"), status = "info",
      "5 new members joined today"
    ),
    notificationItem(icon = icon("warning"), status = "danger",
      "Very long description here that may not fit into the page and may cause design problems"
    ),
    notificationItem(icon = icon("users"), status = "warning",
      "5 new members joined"
    ),
    notificationItem(icon = icon("shopping-cart", lib = "glyphicon"),
      status = "success", "25 sales made"
    ),
    notificationItem(icon = icon("user", lib = "glyphicon"),
      status = "danger", "You changed your username"
    )
  ),
  # Tasks
  dropdownMenu(type = "tasks", badgeStatus = "danger",
    taskItem(value = 20, color = "aqua",
      "Create a nice theme"
    ),
    taskItem(value = 40, color = "green",
      "Design some buttons"
    ),
    taskItem(value = 60, color = "yellow",
      "Another task"
    ),
    taskItem(value = 80, color = "red",
      "And yet another task"
    )
  )
)

sidebar <- dashboardSidebar(
  sidebarSearchForm(label = "Enter approval number", "approvalText", "approvalButton"),
  sidebarMenu(
    menuItem("Dashboard", tabName = "dashboard", icon = icon("dashboard")),
    menuItem("Widgets", icon = icon("th"), tabName = "widgets", badgeLabel = "new",
             badgeColor = "green"),
    menuItem("Charts", icon = icon("bar-chart-o"),
      menuSubItem("Sub-item 1", tabName = "subitem1"),
      menuSubItem("Sub-item 2", tabName = "subitem2")
    ),
    menuItem("Source code for app", icon = icon("file-code-o"),
      href = "https://gist.github.com/wch/8957ee5e2d79770abf9a")
  )
)

body <- dashboardBody(
  tabItems(
    tabItem("dashboard",
      # valueBoxes
      fluidRow(
        valueBox(
          uiOutput("orderNum"), "New Orders", icon = icon("credit-card")
        ),
        valueBox(
          uiOutput("progress"), "Progress", icon = uiOutput("progressIcon"),
          color = "purple"
        ),
        # An entire box can be in a uiOutput
        uiOutput("approvalBox")
      ),

      # Boxes
      fluidRow(
        box(status = "primary", width = 6,
          sliderInput("orders", "Orders", min = 1, max = 500, value = 120),
          selectInput("progress", "Progress",
            choices = c("0%" = 0, "20%" = 20, "40%" = 40, "60%" = 60, "80%" = 80,
                        "100%" = 100)
          )
        ),
        box(title = "Histogram box title", width = 6,
          status = "warning", solidHeader = TRUE, collapsible = TRUE,
          plotOutput("plot", height = 250)
        )
      ),

      fluidRow(
        box(width = 6,
          leafletOutput
        )
      )

    ),

    tabItem("widgets",
      fluidRow(
        box(status = "primary", width = 8, dygraphOutput("dygraph", height = 250)),

        box(title = "Controls for dygraph", background = "teal",
          sliderInput("months", label = "Months to Predict",
                       value = 72, min = 12, max = 144, step = 12, ticks = FALSE),
          selectInput("interval", label = "Prediction Interval",
                      choices = c("0.80", "0.90", "0.95", "0.99"),
                      selected = "0.95", selectize = TRUE),
          checkboxInput("showgrid", label = "Show Grid", value = TRUE)
        )
      ),

      fluidRow(
        # Box with textOutput
        box(title = "Status summary", background = "red", textOutput("status")),
        # Box with HTML output, when finer control over appearance is needed
        box(
          title = "Status summary 2",
          uiOutput("status2"),
          background = "blue"
        )
      )
    ),

    tabItem("subitem1",
      "Sub-item 1 tab content"
    ),

    tabItem("subitem2",
      "Sub-item 2 tab content"
    )
  )
)

server <- function(input, output) {
  output$orderNum <- renderText(input$orders)

  # Progress value
  output$progress <- renderUI({
    tagList(input$progress, tags$sup(style="font-size: 20px", "%"))
  })

  # Icon to show with progress
  output$progressIcon <- renderUI({
    iconName <- switch(input$progress,
      "100" = "ok",
      "0" = "remove",
      "road"
    )
    icon(iconName, lib = "glyphicon")
  })

  output$approvalBox <- renderUI({
    # Take a dependence on the button
    button <- input$approvalButton

    isolate({
      if (is.null(button) ||
          is.null(input$approvalText) ||
          input$approvalText == "") {
        return(NULL)
      }
      valueBox(
        tagList(input$approvalText, tags$sup(style="font-size: 20px", "%")),
        "Approval Rating", icon = icon("line-chart"), color = "green"
      )
    })
  })

  # Histogram
  output$plot <- renderPlot({
    hist(rnorm(input$orders))
  })

  # Predicted values for dygraph
  predicted <- reactive({
    hw <- HoltWinters(ldeaths)
    predict(hw, n.ahead = input$months,
            prediction.interval = TRUE,
            level = as.numeric(input$interval))
  })

  output$dygraph <- renderDygraph({
    dygraph(predicted(), main = "Predicted Deaths/Month") %>%
      dySeries(c("lwr", "fit", "upr"), label = "Deaths") %>%
      dyOptions(drawGrid = input$showgrid)
  })

  # Status text
  output$status <- renderText({
    paste0("The number of months is ", input$months,
      ", and the interval is ", input$interval, ".")
  })

  # Status with uiOutput
  output$status2 <- renderUI({
    total <- round(sum(predicted()[,"fit"]))
    if(total < 75000)
      iconClass <- "smile-o"
    else if (total < 150000)
      iconClass <- "meh-o"
    else
      iconClass <- "frown-o"

    div(
      "Total predicted deaths in range: ",
      div(total, style = "font-size: 30px"),
      div(icon(iconClass), style = "font-size: 50px; text-align: right;")
    )
  })
}


shinyApp(
  ui = dashboardPage(header, sidebar, body),
  server = server
)
