library(shiny)
library(shinydashboard)

# When the selected tab is not the first, and the renderMenu 
# is invalidated, the first tab gets selected. Here is an 
# example: If you type something inside the textInput called 
# "foo" (on tab2), tab1 is selected.

ui <- dashboardPage(
  dashboardHeader(
    title = NULL,
    dropdownMenuOutput("top")
  ),
  dashboardSidebar(
    sidebarMenu(
      menuItem("Tab1", tabName = "tab1"),
      menuItem("Tab2", tabName = "tab2")
    )
  ),
  dashboardBody(
    tabItems(
      tabItem(tabName = "tab1", 
              h1("tab1")
              ),
      tabItem(tabName = "tab2",
              h1("tab2"),
              textInput("foo", "Type something", "")
              )
    )
  )
)

server <- shinyServer(function(input, output, session) {
  output$top <- renderMenu({
    tags$li(class = "dropdown",
            if (input$foo == "") {
              "text1"
            } else {
              "text2"
            }
    )
  })
})

shinyApp(ui, server)