ui <- dashboardPage(
  dashboardHeader(
    title = "Sidebar spill"
  ),
  dashboardSidebar(
    sidebarMenu(
      menuItem(text = "sfsdf sfaosh oas fwue wi aseiu wehw wuer woeur owuer")
    )
  ),
  dashboardBody(
    fluidRow()
  )
)

server <- function(input, output) {
}

shinyApp(ui, server)

