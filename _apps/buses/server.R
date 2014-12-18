library(shinydashboard)
library(leaflet)

# Download data from the Twin Cities Metro Transit API
# http://svc.metrotransit.org/NexTrip/help
getMetroData <- function(path) {
  url <- paste0("http://svc.metrotransit.org/NexTrip/", path, "?format=json")
  jsonlite::fromJSON(url)
}

routes <- getMetroData("Routes")

function(input, output) {

  output$routeSelect <- renderUI({
    routeNums <- sort(as.numeric(routes$Route))
    selectInput("routeNum", "Route", choices = routeNums)
  })

  vehicleLocations <- reactive({
    if (is.null(input$routeNum))
      return(NULL)

    getMetroData(paste0("VehicleLocations/", input$routeNum))
  })

  output$busmap <- renderLeaflet(quoted = TRUE, quote({
    locations <- vehicleLocations()
    if (is.null(locations))
      return(NULL)

    # Four possible directions for bus routes
    dirPal <- colorFactor(
      c("#595490", "#527525", "#A93F35", "#BA48AA"),
      c("1", "2", "3", "4")
    )

    leaflet(locations) %>%
      addTiles() %>%
      addCircleMarkers(
        ~VehicleLongitude,
        ~VehicleLatitude,
        color = ~dirPal(Direction)
      )
  }))

}
