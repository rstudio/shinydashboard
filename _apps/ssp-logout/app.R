library(shinydashboard)

ui <- dashboardPage(
  dashboardHeader(
    title = "SSP logout",
    dropdownMenu(type = "messages", badgeStatus = "success",
      messageItem("Message 1", "Content of a message.")
    )
  ),
  dashboardSidebar(
    tags$head(tags$style(HTML('
      .shiny-server-account { display: none; }
    '))),
    uiOutput("userpanel"),
    sidebarMenu(
      menuItem("Menu item 1", icon = shiny::icon("calendar"))
    )
  ),
  dashboardBody()
)

server <- function(input, output, session) {
  output$userpanel <- renderUI({
    if (!is.null(session$user)) {
      sidebarUserPanel(
        span("Logged in as ", session$user),
        subtitle = a(shiny::icon("sign-out"), "Logout", href="__logout__"))
    }
  })
}

shinyApp(ui, server)
