library(shinydashboard)

header <- dashboardHeader(
  title = "Dashboard Demo"
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
          leafletOutput("busmap")
        ),
        box(title = "Histogram box title", width = 6,
          status = "warning", solidHeader = TRUE, collapsible = TRUE,
          uiOutput("routeSelect")
        )
      )
    ),

    # tabItem("widgets",
    #   fluidRow(
    #     # box(status = "primary", width = 8, dygraphOutput("dygraph", height = 250)),

    #     box(title = "Controls for dygraph", background = "teal",
    #       sliderInput("months", label = "Months to Predict",
    #                    value = 72, min = 12, max = 144, step = 12, ticks = FALSE),
    #       selectInput("interval", label = "Prediction Interval",
    #                   choices = c("0.80", "0.90", "0.95", "0.99"),
    #                   selected = "0.95", selectize = TRUE),
    #       checkboxInput("showgrid", label = "Show Grid", value = TRUE)
    #     )
    #   ),

    #   fluidRow(
    #     # Box with textOutput
    #     box(title = "Status summary", background = "red", textOutput("status")),
    #     # Box with HTML output, when finer control over appearance is needed
    #     box(
    #       title = "Status summary 2",
    #       uiOutput("status2"),
    #       background = "blue"
    #     )
    #   )
    # ),

    tabItem("subitem1",
      "Sub-item 1 tab content"
    ),

    tabItem("subitem2",
      "Sub-item 2 tab content"
    )
  )
)

dashboardPage(header, sidebar, body)
