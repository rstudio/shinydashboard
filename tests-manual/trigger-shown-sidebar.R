# Run this app to test that Shiny outputs that are initally hidden inside
# menuItems become visible ( trigger("shown) ) after we expand the respective
# menuItem.

library(shiny)
library(shinydashboard)

options(shiny.launch.browser=F, shiny.minified=F, shiny.port = 9000)

ui <- function(req) {
  dashboardPage(
    dashboardHeader(),
    dashboardSidebar(
      sidebarMenu(id = "smenu",
        menuItem("Menu Item 1", tabName = "tab1", "text1", menuSubItem("name", tabName = "tabName")),
        menuItem("Menu Item 2", tabName = "tab2", textOutput("text2"), startExpanded = FALSE,
          expandedName = "expanded")
      )
    ),
    dashboardBody(
      tabItems(tabItem("tabName", h3("This is the only content")))
    )
  )
}

server <- function(input, output, session) {
  output$text2 <- renderText("text2")

  observe({
    reactiveValuesToList(input)
    session$doBookmark()
  })
  onBookmarked(function(url) {
    updateQueryString(url)
  })
}

enableBookmarking("url")
shinyApp(ui = ui, server = server)
