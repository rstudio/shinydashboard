#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(shinydashboard)

# Define UI for application that draws a histogram
ui <- dashboardPage(
    # this setup provides almost any customization
    # just a custom AdminLTE.min.css with a subset of the original AdminLTE.css
    # suffices for quite complete tailoring, this is shown for completitude
    skin = "blue",
    theme = c("css/AdminLTE.min.css", "css/_all-skins.min.css", "css/custom.min.css",
                          "css/ion.rangeSlider.min.css"),
    
    # Application title
    dashboardHeader(title = "Old Faithful Geyser Data"),
    
    ## Sidebar content
    dashboardSidebar(
        sidebarMenu(
            menuItem("Tab 1", tabName = "tab1", icon = icon("th"))
        )
    ),
    
    ## Body content
    dashboardBody(
        tabItems(
            # First tab content
            tabItem(tabName = "tab1",
                    fluidRow(
                        box(
                            title = "Controls",
                            # Sidebar with a slider input for number of bins 
                            sliderInput("bins", "Number of bins:", min = 1, max = 50,
                                        value = 30)
                        ),
                        
                        box(
                            # Show a plot of the generated distribution
                            plotOutput("plot1", height = 250)
                        )
                    )
            )
        )
    )
)

# Define server logic required to draw a histogram
server <- function(input, output) {
    
    output$plot1 <- renderPlot({
        # generate bins based on input$bins from ui.R
        x    <- faithful[, 2]
        bins <- seq(min(x), max(x), length.out = input$bins + 1)
        
        # draw the histogram with the specified number of bins
        hist(x, breaks = bins, col = 'darkgray', border = 'white')
    })
}

# Run the application 
shinyApp(ui = ui, server = server)
