## This creates dashboard with a sidebar. The sidebar has a button which allows to switch between different
## panels (tabs) within the same dashboard

  ui <- dashboardPage(
    dashboardHeader(title = "Simple tabs"),
    dashboardSidebar(
      sidebarMenu(
        id = "tabs",
        menuItem("Dashboard", tabName = "dashboard", icon = icon("dashboard")),
        menuItem("Widgets", tabName = "widgets", icon = icon("th"))
      ),
      actionButton('switchtab', 'Switch tab')
    ),
    dashboardBody(
      tabItems(
        tabItem(tabName = "dashboard",
                h2("Dashboard tab content")
        ),
        tabItem(tabName = "widgets",
                h2("Widgets tab content")
        )
      )
    )
  )

  server <- function(input, output, session) {
    observeEvent(input$switchtab, {
      newtab <- switch(input$tabs,
                       "dashboard" = "widgets",
                       "widgets" = "dashboard"
      )
      updateTabItems(session, "tabs", newtab)
    })
  }

  shinyApp(ui, server)
