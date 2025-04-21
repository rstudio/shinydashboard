library(shinydashboard)

ui <- dashboardPage(
  dashboardHeader(
    title = "SSP logout",
    dropdownMenu(
      type = "messages",
      badgeStatus = "success",
      messageItem("Message 1", "Content of a message.")
    )
  ),
  dashboardSidebar(
    # Custom CSS to hide the default logout panel
    tags$head(tags$style(HTML('.shiny-server-account { display: none; }'))),

    # The dynamically-generated user panel
    uiOutput("userpanel"),

    sidebarMenu(
      menuItem("Menu item 1", icon = shiny::icon("calendar"))
    )
  ),
  dashboardBody()
)

server <- function(input, output, session) {
  # Generate the dynamic UI for the logout panel
  output$userpanel <- renderUI({
    # session$user is non-NULL only in authenticated sessions
    if (!is.null(session$user)) {
      sidebarUserPanel(
        span("Logged in as ", session$user),
        subtitle = a(icon("sign-out"), "Logout", href = "__logout__")
      )
    }
  })
}

shinyApp(ui, server)
