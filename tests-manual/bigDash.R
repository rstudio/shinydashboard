## This tries to render a dashboard with many different components, incl. sidebar, dropdown menus etc.

library(shiny)
library(shinydashboard)

header <- dashboardHeader(
  title = "Dashboard Demo",

  # Dropdown menu for messages
  dropdownMenu(
    type = "messages",
    badgeStatus = "success",
    messageItem("Support Team",
                "This is the content of a message.",
                time = "5 mins"),
    messageItem("Support Team",
                "This is the content of another message.",
                time = "2 hours"),
    messageItem("New User",
                "Can I get some help?",
                time = "Today")
  ),

  # Dropdown menu for notifications
  dropdownMenu(
    type = "notifications",
    badgeStatus = "warning",
    notificationItem(
      icon = icon("users"),
      status = "info",
      "5 new members joined today"
    ),
    notificationItem(
      icon = icon("warning"),
      status = "danger",
      "Resource usage near limit."
    ),
    notificationItem(
      icon = icon("shopping-cart", lib = "glyphicon"),
      status = "success",
      "25 sales made"
    ),
    notificationItem(
      icon = icon("user", lib = "glyphicon"),
      status = "danger",
      "You changed your username"
    )
  ),

  # Dropdown menu for tasks, with progress bar
  dropdownMenu(
    type = "tasks",
    badgeStatus = "danger",
    taskItem(value = 20, color = "aqua",
             "Refactor code"),
    taskItem(value = 40, color = "green",
             "Design new layout"),
    taskItem(value = 60, color = "yellow",
             "Another task"),
    taskItem(value = 80, color = "red",
             "Write documentation")
  )
)
sidebar <- dashboardSidebar(
  sidebarUserPanel(
    "User Name",
    subtitle = a(href = "#", icon("circle", class = "text-success"), "Online"),
    # Image file should be in www/ subdir
    image = "userimage.png"
  ),
  sidebarSearchForm(label = "Enter a number", "searchText", "searchButton"),
  sidebarMenu(
    # Setting id makes input$tabs give the tabName of currently-selected tab
    id = "tabs",
    menuItem(
      "Dashboard",
      tabName = "dashboard",
      icon = icon("dashboard")
    ),
    menuItem(
      "Widgets",
      icon = icon("th"),
      tabName = "widgets",
      badgeLabel = "new",
      badgeColor = "green"
    ),
    menuItem(
      "Charts",
      icon = icon("bar-chart-o"),
      menuSubItem("Sub-item 1", tabName = "subitem1"),
      menuSubItem("Sub-item 2", tabName = "subitem2")
    )
  ),
  sidebarMenuOutput("menu")
)

body <- dashboardBody(tabItems(
  tabItem("dashboard",
          div(p(
            "Dashboard tab content"
          ))),
  tabItem("widgets",
          "Widgets tab content"),
  tabItem("subitem1",
          "Sub-item 1 tab content"),
  tabItem("subitem2",
          "Sub-item 2 tab content")),

  # Boxes need to be put in a row (or column)
  fluidRow(box(plotOutput("plot1", height = 250)),
           box(
             title = "Controls",
             sliderInput("slider", "Number of observations:", 1, 100, 50)
           )),

  # infoBoxes
  fluidRow(
    infoBox(
      "Orders",
      uiOutput("orderNum2"),
      "Subtitle",
      icon = icon("credit-card")
    ),
    infoBox(
      "Approval Rating",
      "60%",
      icon = icon("line-chart"),
      color = "green",
      fill = TRUE
    ),
    infoBox(
      "Progress",
      uiOutput("progress2"),
      icon = icon("users"),
      color = "purple"
    )
  ),

  # valueBoxes
  fluidRow(
    valueBox(
      uiOutput("orderNum"),
      "New Orders",
      icon = icon("credit-card"),
      href = "http://google.com"
    ),
    valueBox(
      tagList("60", tags$sup(style = "font-size: 20px", "%")),
      "Approval Rating",
      icon = icon("line-chart"),
      color = "green"
    ),
    valueBox(
      htmlOutput("progress"),
      "Progress",
      icon = icon("users"),
      color = "purple"
    )
  ),

  # Boxes
  fluidRow(
    box(
      status = "primary",
      sliderInput(
        "orders",
        "Orders",
        min = 1,
        max = 2000,
        value = 650
      ),
      selectInput(
        "progress",
        "Progress",
        choices = c(
          "0%" = 0,
          "20%" = 20,
          "40%" = 40,
          "60%" = 60,
          "80%" = 80,
          "100%" = 100
        )
      )
    ),
    box(
      title = "Histogram box title",
      status = "warning",
      solidHeader = TRUE,
      collapsible = TRUE,
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
  ),

  fluidRow(
    tabBox(
      title = "First tabBox",
      # The id lets us use input$tabset1 on the server to find the current tab
      id = "tabset1", height = "250px",
      tabPanel("Tab1", "First tab content"),
      tabPanel("Tab2", "Tab content 2")
    ),
    tabBox(
      side = "right", height = "250px",
      selected = "Tab3",
      tabPanel("Tab1", "Tab content 1"),
      tabPanel("Tab2", "Tab content 2"),
      tabPanel("Tab3", "Note that when side=right, the tab order is reversed.")
    )
  ),
  fluidRow(
    tabBox(
      # Title can include an icon
      title = tagList(shiny::icon("gear"), "tabBox status"),
      tabPanel("Tab1",
               "Currently selected tab from first box:",
               verbatimTextOutput("tabset1Selected")
      ),
      tabPanel("Tab2", "Tab content 2")
    )
  )

)

server <- function(input, output) {
  set.seed(122)
  histdata <- rnorm(500)

  output$menu <- renderMenu({
    sidebarMenu(menuItem("Menu item", icon = icon("calendar")))
  })

  output$plot1 <- renderPlot({
    data <- histdata[seq_len(input$slider)]
    hist(data)
  })

  output$orderNum <- renderText({
    prettyNum(input$orders, big.mark = ",")
  })

  output$orderNum2 <- renderText({
    prettyNum(input$orders, big.mark = ",")
  })

  output$progress <- renderUI({
    tagList(input$progress, tags$sup(style = "font-size: 20px", "%"))
  })

  output$progress2 <- renderUI({
    paste0(input$progress, "%")
  })

  output$status <- renderText({
    paste0(
      "There are ",
      input$orders,
      " orders, and so the current progress is ",
      input$progress,
      "%."
    )
  })

  output$status2 <- renderUI({
    iconName <- switch(input$progress,
                       "100" = "ok",
                       "0" = "remove",
                       "road")
    p("Current status is: ", icon(iconName, lib = "glyphicon"))
  })


  output$plot <- renderPlot({
    hist(rnorm(input$orders))
  })

  # The currently selected tab from the first box
  output$tabset1Selected <- renderText({
    input$tabset1
  })
}

ui <- dashboardPage(header,
                    sidebar,
                    body)

shinyApp(ui, server)
