library(shinydashboard)

ui <- dashboardPage(
  dashboardHeader(title = "Value boxes"),
  dashboardSidebar(),
  dashboardBody(
    fluidRow(
      valueBox(
        # The value comes from the server via uiOutput
        uiOutput("orderNum"), "New Orders", icon = icon("credit-card")
      ),

      valueBox(
        # The icon can also be a uiOutput
        uiOutput("progress"), "Progress", icon = uiOutput("progressIcon"),
        color = "purple"
      ),

      # An entire box can be in a uiOutput
      uiOutput("approvalBox")
    )
  )
)

server <- function(input, output) {
  output$orderNum <- renderText({ 10*2 })

  output$progress <- renderText({ "75%" })

  output$progressIcon <- renderUI({ icon("list") })

  output$approvalBox <- renderUI({
    valueBox(
      "80%", "Approval", icon = icon("thumbs-up", lib = "glyphicon"),
      color = "yellow"
    )
  })

}

shinyApp(ui, server)
