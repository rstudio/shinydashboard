library(shinydashboard)

ui <- bootstrapPage(
  span(
    id = "content",
    "Calendar from Font-Awesome:",
    icon("calendar"),
    br(),
    br(),
    "Cog from Glyphicons:",
    icon("cog", lib = "glyphicon")
  )
)

server <- function(input, output) { }

shinyApp(ui, server)
