library(shiny)
library(shinydashboard)
library(shinythemes)

header <- dashboardHeader(
  title = "Upload Data",
  titleWidth = 1000,

  #tags$head(
  #          tags$link(  HTML( '<title>Data Upload>')
  #          )
  #)
  dropdownMenu(type = "messages",
               messageItem(from = "Dept",
                           message = "Under construction"))

)

#Sidebar Panel
sidebar <- dashboardSidebar(width = 200,
                            sidebarMenu(menuItem(
                              "Upload Data", tabName = "filetable", icon = icon("upload")
                            )))

#Dashboard Body
body <- dashboardBody(
  tags$head(tags$style(
  HTML(
    '
    .main-header .logo {
    font-family: "Georgia", Times, "Times New Roman", serif;
    font-weight: bold;
    font-size: 34px;
    }'
  )
  )),
  tags$head(
    tags$link(rel = "stylesheet", type = "text/css", href = "custom.css"),
    tags$style(
      HTML(
        '
        .main-header .logo {
        font-family: "Georgia", Times, "Times New Roman", serif;
        font-weight: bold;
        font-size: 34px;
        }'
    )
      )
      ),
  tabItems(tabItem(tabName = "filetable",
                   fluidRow(
                     box(
                       title = "Data Input",
                       status = "primary",
                       solidHeader = TRUE,
                       collapsible = TRUE,
                       radioButtons(
                         "dataInput",
                         "",
                         choices = list(
                           "Load sample data" = 1,
                           "Upload file" = 2,
                           "Paste data" = 3
                         ),
                         selected = 1
                       ),
                       conditionalPanel(condition = "input.dataInput=='1'",
                                        h5("Selected Data Input")),
                       conditionalPanel(
                         condition = "input.dataInput=='2'",
                         h5("Upload delimited text file: "),
                         fileInput("upload", "", multiple = FALSE),
                         radioButtons(
                           "fileSepDF",
                           "Delimiter:",
                           list(
                             "Comma" = 1,
                             "Tab" = 2,
                             "Semicolon" = 3
                           )
                         ), selected = NULL
                       ),
                       conditionalPanel(
                         condition = "input.dataInput=='3'",
                         h5("Paste data below:"),
                         tags$textarea(id = "myData", rows = 10, cols =
                                         100, ""),
                         br(),
                         actionButton('clearText_button', 'Clear data'),
                         radioButtons(
                           "fileSepP",
                           "Separator:",
                           list(
                             "Comma" = 1,
                             "Tab" = 2,
                             "Semicolon" = 3
                           )
                         )
                       ),
                       width = 12
                     ),
                     box(
                       title = "Data",
                       status = "primary",
                       solidHeader = TRUE,
                       collapsible = TRUE,
                       verbatimTextOutput("filetable"),
                       width = 12
                     )
                   ))))

ui <- dashboardPage(header,
                    Sidebar,
                    body,
                    skin = "blue")


server <- function(input, output, session) {
  dataM <- reactive({
    if (input$dataInput == 1) {
      data <- read.table("Sample.csv",
                         sep = ",",
                         header = TRUE,
                         fill = TRUE)

    }
    else if (input$dataInput == 2) {
      inFile <- input$upload
      # Avoid error message while file is not uploaded yet
      if (is.null(input$upload)) {
        return(NULL)
      }
      # Get the separator
      mySep <-
        switch(
          input$fileSepDF,
          '1' = ",",
          '2' = "\t",
          '3' = ";",
          '4' = ""
        ) #list("Comma"=1,"Tab"=2,"Semicolon"=3)
      if (file.info(inFile$datapath)$size <= 10485800) {
        data <- read.table(
          inFile$datapath,
          sep = mySep,
          header = TRUE,
          fill = TRUE
        )
      }
      else
        print("File is more than 10MB size will not be uploaded.")
    }
    else {
      if (is.null(input$myData)) {
        return(NULL)
      }
      tmp <- matrix(strsplit(input$myData, "\n")[[1]])
      mySep <- switch(input$fileSepP,
                      '1' = ",",
                      '2' = "\t",
                      '3' = ";")
      myColnames <- strsplit(tmp[1], mySep)[[1]]
      data <- matrix(0, length(tmp) - 1, length(myColnames))
      colnames(data) <- myColnames
      for (i in 2:length(tmp)) {
        myRow <-
          as.numeric(strsplit(paste(tmp[i], mySep, mySep, sep = ""), mySep)[[1]])
        data[i - 1, ] <- myRow[-length(myRow)]
      }
      data <- data.frame(data)

    }
    return(data)
  })

  output$filetable <- renderTable({
    print(nrow(dataM()))
    if (nrow(dataM()) < 500) {
      return(dataM())
    }
    else {
      return(dataM()[1:100, ])
    }
    #dataM()

  })

}

shinyApp(ui, server)
