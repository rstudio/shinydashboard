# Run this app to test that Shiny outputs that are initally hidden inside
# menuItems become visible ( trigger("shown) ) after we expand the respective
# menuItem. Currently, this doesn't look exactly pretty, but it does work.
#
# ------------------------------------------------------------------------------
#
# Aside from being ugly, this app also shows another unfortunate side effect
# of the hacky code for the trigger("shown) of Shiny outputs. Which is that
# the ensureActivatedTab() function does not work on app startup if the only
# tabNamed things are initially hidden inside the menuItem parents.
#
# To see this, go to this app URL:
# http://127.0.0.1:4601/?_inputs_&sidebarCollapsed=%22false%22&sidebarItemExpanded=%22tabName%22&smenu=null
# You will see that even though `smenu` is "null" the `name` tab (menuSubItem)
# appears highlighted, as it should be if the ensureActivatedTab() function is
# doing its job.
# But if you do this "manually", even though you get the *SAME* bookmarked URL,
# you don't see the `name` tab highlighted...:
#     1) Go to http://127.0.0.1:4601/
#     2) Click on the "Menu Item 1" to expand it
#     3) Check with abadonment and dismay that the URL looks the same as above,
#        but that the `name` tab is *NOT* highlighted
#     4) Regain some faith and hope through the fact that at least the content
#        ("This is the only content") always appears, so while something if off
#        with ensureActivatedTab(), it's still doing its most important job,
#        which is to display some/any content on the dashboardBody if there is
#        a menuItem or menuSubItem anywhere in the dashboardSidebar with a
#        tabName and a corresponding tabItem anywhere in the dashboardBody
#
# ------------------------------------------------------------------------------
#
# This also shows that you can only bookmark the expanded menuItem *IF* at least
# one of its children is a menuSubItem *with* a tabName.

library(shiny)
library(shinydashboard)

options(shiny.launch.browser=F, shiny.minified=F, shiny.port = 4601)

ui <- function(req) {
  dashboardPage(
    dashboardHeader(),
    dashboardSidebar(
      sidebarMenu(id = "smenu",
        menuItem("Menu Item 1", tabName = "tab1", "text1", menuSubItem("name", tabName = "tabName")),
        menuItem("Menu Item 2", tabName = "tab2", textOutput("text2"))
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
