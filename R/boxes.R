#' Create a value box for the main body of a dashboard.
#'
#' A value box displays a value (usually a number) in large text, with a smaller
#' subtitle beneath, and a large icon on the right side. Value boxes are meant
#' to be placed in the main body of a dashboard.
#'
#' @inheritParams box
#' @param value The value to display in the box. Usually a number or short text.
#' @param subtitle Subtitle text.
#' @param icon An icon tag, created by \code{\link[shiny]{icon}}.
#' @param color A color for the box. Valid colors are listed in
#'   \link{validColors}.
#' @param href An optional URL to link to.
#'
#' @family boxes
#' @seealso \code{\link{box}} for usage examples.
#'
#' @export
valueBox <- function(value, subtitle, icon = NULL, color = "aqua", width = 4,
  href = NULL)
{
  validateColor(color)
  if (!is.null(icon)) tagAssert(icon, type = "i")

  boxContent <- div(class = paste0("small-box bg-", color),
    div(class = "inner",
      h3(value),
      p(subtitle)
    ),
    if (!is.null(icon)) div(class = "icon-large", icon)
  )

  if (!is.null(href))
    boxContent <- a(href = href, boxContent)

  div(class = if (!is.null(width)) paste0("col-sm-", width),
    boxContent
  )
}


#' Create an info box for the main body of a dashboard.
#'
#' An info box displays a large icon on the left side, and a title, value
#' (usually a number), and an optional smaller subtitle on the right side. Info
#' boxes are meant to be placed in the main body of a dashboard.
#'
#' @inheritParams box
#' @param title Title text.
#' @param value The value to display in the box. Usually a number or short text.
#' @param subtitle Subtitle text (optional).
#' @param icon An icon tag, created by \code{\link[shiny]{icon}}.
#' @param color A color for the box. Valid colors are listed in
#'   \link{validColors}.
#' @param fill If \code{FALSE} (the default), use a white background for the
#'   content, and the \code{color} argument for the background of the icon. If
#'   \code{TRUE}, use the \code{color} argument for the background of the
#'   content; the icon will use the same color with a slightly darkened
#'   background.
#' @param href An optional URL to link to.
#'
#' @family boxes
#' @seealso \code{\link{box}} for usage examples.
#'
#' @export
infoBox <- function(title, value = NULL, subtitle = NULL,
  icon = shiny::icon("bar-chart"), color = "aqua", width = 4, href = NULL,
  fill = FALSE) {

  validateColor(color)
  tagAssert(icon, type = "i")

  colorClass <- paste0("bg-", color)

  boxContent <- div(
    class = "info-box",
    class = if (fill) colorClass,
    span(
      class = "info-box-icon",
      class = if (!fill) colorClass,
      icon
    ),
    div(class = "info-box-content",
      span(class = "info-box-text", title),
      if (!is.null(value)) span(class = "info-box-number", value),
      if (!is.null(subtitle)) p(subtitle)
    )
  )

  if (!is.null(href))
    boxContent <- a(href = href, boxContent)

  div(class = if (!is.null(width)) paste0("col-sm-", width),
    boxContent
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
#' @param width The width of the box, using the Bootstrap grid system. This is
#'   used for row-based layouts. The overall width of a region is 12, so the
#'   default valueBox width of 4 occupies 1/3 of that width. For column-based
#'   layouts, use \code{NULL} for the width; the width is set by the column that
#'   contains the box.
#' @param height The height of a box, in pixels or other CSS unit. By default
#'   the height scales automatically with the content.
#' @param collapsible If TRUE, display a button in the upper right that allows
#'   the user to collapse the box.
#' @param collapsed If TRUE, start collapsed. This must be used with
#'   \code{collapsible=TRUE}.
#' @param ... Contents of the box.
#'
#' @family boxes
#'
#' @examples
#' ## Only run this example in interactive R sessions
#' if (interactive()) {
#' library(shiny)
#'
#' # A dashboard body with a row of infoBoxes and valueBoxes, and two rows of boxes
#' body <- dashboardBody(
#'
#'   # infoBoxes
#'   fluidRow(
#'     infoBox(
#'       "Orders", uiOutput("orderNum2"), "Subtitle", icon = icon("credit-card")
#'     ),
#'     infoBox(
#'       "Approval Rating", "60%", icon = icon("line-chart"), color = "green",
#'       fill = TRUE
#'     ),
#'     infoBox(
#'       "Progress", uiOutput("progress2"), icon = icon("users"), color = "purple"
#'     )
#'   ),
#'
#'   # valueBoxes
#'   fluidRow(
#'     valueBox(
#'       uiOutput("orderNum"), "New Orders", icon = icon("credit-card"),
#'       href = "http://google.com"
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
#'     box(status = "primary",
#'       sliderInput("orders", "Orders", min = 1, max = 2000, value = 650),
#'       selectInput("progress", "Progress",
#'         choices = c("0%" = 0, "20%" = 20, "40%" = 40, "60%" = 60, "80%" = 80,
#'                     "100%" = 100)
#'       )
#'     ),
#'     box(title = "Histogram box title",
#'       status = "warning", solidHeader = TRUE, collapsible = TRUE,
#'       plotOutput("plot", height = 250)
#'     )
#'   ),
#'
#'   # Boxes with solid color, using `background`
#'   fluidRow(
#'     # Box with textOutput
#'     box(
#'       title = "Status summary",
#'       background = "green",
#'       width = 4,
#'       textOutput("status")
#'     ),
#'
#'     # Box with HTML output, when finer control over appearance is needed
#'     box(
#'       title = "Status summary 2",
#'       width = 4,
#'       background = "red",
#'       uiOutput("status2")
#'     ),
#'
#'     box(
#'       width = 4,
#'       background = "light-blue",
#'       p("This is content. The background color is set to light-blue")
#'     )
#'   )
#' )
#'
#' server <- function(input, output) {
#'   output$orderNum <- renderText({
#'     prettyNum(input$orders, big.mark=",")
#'   })
#'
#'   output$orderNum2 <- renderText({
#'     prettyNum(input$orders, big.mark=",")
#'   })
#'
#'   output$progress <- renderUI({
#'     tagList(input$progress, tags$sup(style="font-size: 20px", "%"))
#'   })
#'
#'   output$progress2 <- renderUI({
#'     paste0(input$progress, "%")
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
                solidHeader = FALSE, background = NULL, width = 6,
                height = NULL, collapsible = FALSE, collapsed = FALSE) {

  boxClass <- "box"
  if (solidHeader || !is.null(background)) {
    boxClass <- paste(boxClass, "box-solid")
  }
  if (!is.null(status)) {
    validateStatus(status)
    boxClass <- paste0(boxClass, " box-", status)
  }
  if (collapsible && collapsed) {
    boxClass <- paste(boxClass, "collapsed-box")
  }
  if (!is.null(background)) {
    validateColor(background)
    boxClass <- paste0(boxClass, " bg-", background)
  }

  style <- NULL
  if (!is.null(height)) {
    style <- paste0("height: ", validateCssUnit(height))
  }

  titleTag <- NULL
  if (!is.null(title)) {
    titleTag <- h3(class = "box-title", title)
  }

  collapseTag <- NULL
  if (collapsible) {
    buttonStatus <- status %OR% "default"

    collapseIcon <- if (collapsed) "plus" else "minus"

    collapseTag <- div(class = "box-tools pull-right",
      tags$button(class = paste0("btn btn-box-tool"),
        `data-widget` = "collapse",
        shiny::icon(collapseIcon)
      )
    )
  }

  headerTag <- NULL
  if (!is.null(titleTag) || !is.null(collapseTag)) {
    headerTag <- div(class = "box-header",
      titleTag,
      collapseTag
    )
  }

  div(class = if (!is.null(width)) paste0("col-sm-", width),
    div(class = boxClass,
      style = if (!is.null(style)) style,
      headerTag,
      div(class = "box-body", ...),
      if (!is.null(footer)) div(class = "box-footer", footer)
    )
  )
}

#' Create a tabbed box
#'
#' @inheritParams shiny::tabsetPanel
#' @inheritParams box
#' @param title Title for the tabBox.
#' @param side Which side of the box the tabs should be on (\code{"left"} or
#'   \code{"right"}). When \code{side="right"}, the order of tabs will be
#'   reversed.
#'
#' @family boxes
#'
#' @examples
#' ## Only run this example in interactive R sessions
#' if (interactive()) {
#' library(shiny)
#'
#' body <- dashboardBody(
#'   fluidRow(
#'     tabBox(
#'       title = "First tabBox",
#'       # The id lets us use input$tabset1 on the server to find the current tab
#'       id = "tabset1", height = "250px",
#'       tabPanel("Tab1", "First tab content"),
#'       tabPanel("Tab2", "Tab content 2")
#'     ),
#'     tabBox(
#'       side = "right", height = "250px",
#'       selected = "Tab3",
#'       tabPanel("Tab1", "Tab content 1"),
#'       tabPanel("Tab2", "Tab content 2"),
#'       tabPanel("Tab3", "Note that when side=right, the tab order is reversed.")
#'     )
#'   ),
#'   fluidRow(
#'     tabBox(
#'       # Title can include an icon
#'       title = tagList(shiny::icon("gear"), "tabBox status"),
#'       tabPanel("Tab1",
#'         "Currently selected tab from first box:",
#'         verbatimTextOutput("tabset1Selected")
#'       ),
#'       tabPanel("Tab2", "Tab content 2")
#'     )
#'   )
#' )
#'
#' shinyApp(
#'   ui = dashboardPage(dashboardHeader(title = "tabBoxes"), dashboardSidebar(), body),
#'   server = function(input, output) {
#'     # The currently selected tab from the first box
#'     output$tabset1Selected <- renderText({
#'       input$tabset1
#'     })
#'   }
#' )
#' }
#' @export
tabBox <- function(..., id = NULL, selected = NULL, title = NULL,
                   width = 6, height = NULL, side = c("left", "right"))
{
  side <- match.arg(side)

  # The content is basically a tabsetPanel with some custom modifications
  content <- shiny::tabsetPanel(..., id = id, selected = selected)
  content$attribs$class <- "nav-tabs-custom"

  # Set height
  if (!is.null(height)) {
    content <- tagAppendAttributes(content,
      style = paste0("height: ", validateCssUnit(height))
    )
  }

  # Move tabs to right side if needed
  if (side == "right") {
    content$children[[1]] <- tagAppendAttributes(content$children[[1]],
      class = "pull-right"
    )
  }

  # Add title
  if (!is.null(title)) {
    if (side == "left")
      titleClass <- "pull-right"
    else
      titleClass <- "pull-left"

    content$children[[1]] <- htmltools::tagAppendChild(content$children[[1]],
      tags$li(class = paste("header", titleClass), title)
    )
  }

  div(class = paste0("col-sm-", width), content)
}
