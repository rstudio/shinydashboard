if(interactive()) {

  library(shiny)
  # ========== Dynamic sidebarMenu ==========
  ui <- dashboardPage(
    dashboardHeader(title = "Dynamic sidebar"),
    dashboardSidebar(
      sidebarMenuOutput("menu")
    ),
    dashboardBody()
  )

  server <- function(input, output) {
    output$menu <- renderMenu({
      sidebarMenu(
        menuItem("Menu item", icon = icon("calendar"))
      )
    })
  }

  shinyApp(ui, server)
}
