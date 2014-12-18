#' Create a value box for the main body of a dashboard.
#'
#' A value box displays a value (usually a number) in large text, with a smaller
#' subtitle beneath, and a large icon on the right side. Value boxes are meant
#' to be placed in the main body of a dashboard.
#'
#' @param value Value text.
#' @param subtitle Subtitle text.
#' @param icon An icon tag, created by \code{\link[shiny]{icon}}.
#' @param color A color for the box. Valid colors are listed in
#'   \link{validColors}.
#' @param width The width of the box, using the Bootstrap grid system. The
#'   overall width of a region is 12, so the default valueBox width of 4
#'   occupies 1/3 of that width.
#'
#' @seealso \code{\link{box}} for usage examples.
#'
#' @export
valueBox <- function(value, subtitle, icon = NULL, color = "aqua", width = 4) {
  validateColor(color)
  if (!is.null(icon)) tagAssert(icon, type = "i")

  div(class = paste0("col-sm-", width),
    div(class = paste0("small-box bg-", color),
      div(class = "inner",
        h3(value),
        p(subtitle)
      ),
      if (!is.null(icon)) div(class = "icon-large", icon)
    )
  )
}

#' Create a box for the main body of a dashboard
#'
#' Boxes can be used to hold content in the main body of a dashboard.
#'
#' @param title Optional title.
#' @param footer Optional footer text.
#' @param status The status of the item This determines the item's background
#'   color. Valid statuses are listed in \link{validStatuses}.
#' @param solidHeader Should the header be shown with a solid color background?
#' @param background If NULL (the default), the background of the box will be
#'   white. Otherwise, a color string. Valid colors are listed in
#'   \link{validColors}.
#' @param width The width of the box, using the Bootstrap grid system. The
#'   overall width of a region is 12, so the default valueBox width of 4
#'   occupies 1/3 of that width.
#' @param collapsible If TRUE, display a button in the upper right that allows
#'   the user to collapse the box.
#' @param ... Contents of the box.
#'
#' @seealso \code{\link{valueBox}}
#'
#' @examples
#' \donttest{
#' library(shiny)
#'
#' # A dashboard body with a row of valueBoxes and two rows of boxes
#' body <- dashboardBody(
#'
#'   # valueBoxes
#'   fluidRow(
#'     valueBox(
#'       uiOutput("orderNum"), "New Orders", icon = icon("credit-card")
#'     ),
#'     valueBox(
#'       tagList("60", tags$sup(style="font-size: 20px", "%")),
#'        "Approval Rating", icon = icon("line-chart"), color = "green"
#'     ),
#'     valueBox(
#'       htmlOutput("progress"), "Progress", icon = icon("users"), color = "purple"
#'     )
#'   ),
#'
#'   # Boxes
#'   fluidRow(
#'     box(status = "primary", width = 6,
#'       sliderInput("orders", "Orders", min = 1, max = 500, value = 120),
#'       selectInput("progress", "Progress",
#'         choices = c("0%" = 0, "20%" = 20, "40%" = 40, "60%" = 60, "80%" = 80,
#'                     "100%" = 100)
#'       )
#'     ),
#'     box(title = "Histogram box title", width = 6,
#'       status = "warning", solidHeader = TRUE, collapsible = TRUE,
#'       plotOutput("plot", height = 250)
#'     )
#'   ),
#'
#'   # Boxes with solid color, using `background`
#'   fluidRow(
#'     # Box with textOutput
#'     box(title = "Status summary", background = "green", textOutput("status")),
#'
#'     # Box with HTML output, when finer control over appearance is needed
#'     box(
#'       title = "Status summary 2",
#'       uiOutput("status2"),
#'       background = "red"
#'     ),
#'
#'     box(
#'       p("This is content. The background color is set to light-blue"),
#'       background = "light-blue"
#'     )
#'   )
#' )
#'
#' server <- function(input, output) {
#'   output$orderNum <- renderText(input$orders)
#'
#'   output$progress <- renderUI({
#'     tagList(input$progress, tags$sup(style="font-size: 20px", "%"))
#'   })
#'
#'   output$status <- renderText({
#'     paste0("There are ", input$orders,
#'       " orders, and so the current progress is ", input$progress, "%.")
#'   })
#'
#'   output$status2 <- renderUI({
#'     iconName <- switch(input$progress,
#'       "100" = "ok",
#'       "0" = "remove",
#'       "road"
#'     )
#'     p("Current status is: ", icon(iconName, lib = "glyphicon"))
#'   })
#'
#'
#'   output$plot <- renderPlot({
#'     hist(rnorm(input$orders))
#'   })
#' }
#'
#' shinyApp(
#'   ui = dashboardPage(
#'     dashboardHeader(),
#'     dashboardSidebar(),
#'     body
#'   ),
#'   server = server
#' )
#' }
#' @export
box <- function(..., title = NULL, footer = NULL, status = NULL,
                solidHeader = FALSE, background = NULL, width = 4,
                collapsible = FALSE) {

  boxClass <- "box"
  if (solidHeader || !is.null(background)) {
    boxClass <- paste(boxClass, "box-solid")
  }
  if (!is.null(status)) {
    validateStatus(status)
    boxClass <- paste0(boxClass, " box-", status)
  }
  if (!is.null(background)) {
    validateColor(background)
    boxClass <- paste0(boxClass, " bg-", background)
  }

  titleTag <- NULL
  if (!is.null(title)) {
    titleTag <- h3(class = "box-title", title)
  }

  collapseTag <- NULL
  if (collapsible) {
    collapseTag <- div(class = "box-tools pull-right",
      tags$button(class = "btn btn-default btn-sm",
        `data-widget` = "collapse", `data-toggle` = "tooltip",
        title = "Collapse",
        tags$i(class = "fa fa-minus")
      )
    )
  }

  div(class = paste0("col-md-", width),
    div(class = boxClass,
      div(class = "box-header",
        titleTag,
        collapseTag
      ),
      div(class = "box-body", ...),
      if (!is.null(footer)) div(class = "box-footer", footer)
    )
  )
}
