#' Given the name of an icon
#'
#' Given the name of an icon, like "fa-dashboard" or "glyphicon-user",
#' @param give the name of the icon
#' @return CSS classnames, like "fa fa-dashboard" or "glyphicon glyphicon-user".
#' @export
getIconClass <- function(icon) {
  iconGroup <- sub("^((glyphicon)|(fa))-.*", "user", icon)
  paste(iconGroup, icon)
}


# Returns TRUE if a color is a valid color defined in AdminLTE, throws error
# otherwise.
validateColor <- function(color) {
  if (color %in% validColors) {
    return(TRUE)
  }

  stop("Invalid color: ", color, ". Valid colors are: ",
       paste(validColors, collapse = ", "), ".")
}

#' Valid colors
#'
#' These are valid colors for various dashboard components. Valid colors are
#' listed below.
#'
#' \itemize{
#'   \item \code{red}
#'   \item \code{yellow}
#'   \item \code{aqua}
#'   \item \code{blue}
#'   \item \code{light-blue}
#'   \item \code{green}
#'   \item \code{navy}
#'   \item \code{teal}
#'   \item \code{olive}
#'   \item \code{lime}
#'   \item \code{orange}
#'   \item \code{fuchsia}
#'   \item \code{purple}
#'   \item \code{maroon}
#'   \item \code{black}
#' }
#'
#' @usage NULL
#' @format NULL
#'
#' @keywords internal
validColors <- c("red", "yellow", "aqua", "blue", "light-blue", "green",
                 "navy", "teal", "olive", "lime", "orange", "fuchsia",
                 "purple", "maroon", "black")


# Returns TRUE if a status is valid; throws error otherwise.
validateStatus <- function(status) {

  if (status %in% validStatuses) {
    return(TRUE)
  }

  stop("Invalid status: ", status, ". Valid statuses are: ",
       paste(validStatuses, collapse = ", "), ".")
}


#' Valid statuses
#'
#' These status strings correspond to colors as defined in Bootstrap's CSS.
#' Although the colors can vary depending on the particular CSS selector, they
#' generally appear as follows:
#'
#' \itemize{
#'   \item \code{primary} Blue (sometimes dark blue)
#'   \item \code{success} Green
#'   \item \code{info} Blue
#'   \item \code{warning} Orange
#'   \item \code{danger} Red
#' }
#'
#' @usage NULL
#' @format NULL
#'
#' @keywords internal
validStatuses <- c("primary", "success", "info", "warning", "danger")


"%OR%" <- function(a, b) if (!is.null(a)) a else b

# Return TRUE if a shiny.tag object has a CSS class, FALSE otherwise.
hasCssClass <- function(tag, class) {
  if (is.null(tag$attribs) || is.null(tag$attribs$class))
    return(FALSE)

  classes <- strsplit(tag$attribs$class, " +")[[1]]
  return(class %in% classes)
}

"%OR%" <- function(a, b) if (!is.null(a)) a else b


kpi_metric_box_UI <- function(id) {
  ns <- NS(id)



}

kpi_metric_service <-
  function (input,
            output,
            session,
            data_source) {

  }




#' Create a tabular box UI
#'
#' @param Id is the unique id of the HTML elemnt.
#' @param Title is the name of the box.
#' @param ColumnWidth is the width of the box.
#' @param offset is to set the offset of box.
#' @return <div class="col-sm-6">
#' <div class="box box-primary " style="background-color: #F8F8FF;">
#'  <div class="box-header">
#'  <strong>Enter Title</strong>
#'  </div>
#'  <div class="box-body">
#'  <div id="tableBox-tab_box" class="shiny-html-output"></div>
#'  </div>
#'  </div>
#'  </div>
#' @export
measure_box_tabular_UI <-
  function(id,
           title = "",
           column_width = 4,
           offset = 0) {
    ns <- NS(id)
    column(
      width = column_width,
      offset = 0,
      div(
        class = "box box-primary ",
        style = "background-color: #F8F8FF;",
        div(class = "box-header", strong(title)),
        div(class = "box-body", uiOutput(ns("tab_box")))
      )



    )

  }

measure_box_tabular_service <- function(input,
                                        output,
                                        session,
                                        data_source,column_names) {


  output$tab_box <- renderUI({
    dta <- data_source()
    if (ncol(dta) < 2) {
      stop('Not enough columns')
    } else {
      dta <- dta[, 1:2]
    }

    ftab <- formattable(dta)

    tagList(HTML(format_table(dta)))
  })

}


 kpi_tab_box <- function(data,title="",bar_score = NULL,column_width=4,col_names) {
#  message("kpi_tab_box")

  if (ncol(data) < 2) {
    stop('Not enough columns')
  } else {
    data <- data[, 1:2]
  }
  if(!missing(col_names)){
    names(data) <- col_names
  }
  column(
    width = column_width,
    height = 250,
    offset = 0,
    div(
      class = "box box-primary ",
     # style = "background-color: #F8F8FF;",
      div(class = "box-header", strong(title)),
      div(class = "box-body",
          tagList(HTML(format_table(data))))))



}




kpi_star_box <-
  function(data,
           title = "",
           bar_score = NULL,
           column_width = 4,
           col_names=c("Year","Stars")) {
   # message("kpi_star_box")
    star_list <- function(index) { sapply(index,function(x) { rep("star",x)})}

    if (ncol(data) < 2) {
      stop('Not enough columns')
    } else {
      data <- data[, 1:2]
    }
    if (!missing(col_names)) {
      names(data) <- col_names
    }
    column(
      width = column_width,
      offset = 0,
      height = 100,
      div(
        class = "box box-primary ",
        div(class = "box-header", strong(title)),
        div(
          class = "box-body",

          hc <- highchart(height = 115) %>%
            hc_xAxis(categories = data[,1]) %>%
            hc_add_series(data =data[,2],showInLegend = FALSE) %>%
            hc_chart(type = "bar")

        )
      )
    )

  }

kpi_trend_box <-
  function(data,
           title = "",
           bar_score = NULL,
           column_width = 4,
           col_names) {
   # message("kpi_trend_box")

    if (ncol(data) < 2) {
      stop('Not enough columns')
    } else {
      data <- data[, 1:2]
    }
    if (!missing(col_names)) {
      names(data) <- col_names
    }
 #   message("trend box data:")
   # str(data)
    x_data <- c(2014,2015,2016)
  #  message(paste(x_data,collapse = ", "))

     y_data <- data[col_names[2]]
   #  message(paste(y_data,collapse = ", "))

    column(
      width = column_width,
      offset = 0,
      height = 100,
      div(
        class = "box box-primary ",
      #  style = "background-color: #F8F8FF;",
        div(class = "box-header", strong(title)),
        div(
          class = "box-body",
          hc <- highchart(height = 115) %>%
          hc_xAxis(categories = data[,1]) %>%
            hc_add_series(data =data[,2],showInLegend = FALSE) #%>%
           #hc_chart(type = "bar")

        )
      )
    )

  }


#' Create a Matrix Box
#'
#' @param id is the unique id of html elemnt.
#' @param title is the title of the Table box.
#' @param footer is the footer of the table box.
#' @param Status is the status of the box.
#' @param Info is the information about the matrix box.
#' @param solidheader is the header of the table box.
#' @param background is the backgroundcolor of box.
#' @param width id the width of the box.
#' @param height is the heigth of the box.
#' @param collapsible is the box should be collapsibe.
#' @param collapsed is the box is collapsed.
#' @return <div class="col-sm-6">
#' <div class="box">
#'  <div class="box-header">
#'  <div class="box-tools pull-right">
#'  <button class="btn btn-box-tool" data-widget="collapse">
#'  <i class="fa fa-minus"></i>
#'  </button>
#'  </div>
#'  </div>
#'  <div class="box-body">
#'  <div class="row">Matrix box</div>
#'  </div>
#'  </div>
#'  </div>
#' @export
kpi_metric_box <- function(..., id = NULL, title = NULL, footer = NULL, status = NULL,info,
                                                                                solidHeader = FALSE, background = NULL, width = 12,
                                                                                height = NULL, collapsible = TRUE, collapsed = FALSE) {

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
    titleTag <- actionLink(id,h3(class = "box-title", title  #, #style="text-decoration: underline;"
                                 ))
  }

  collapseTag <- NULL
  if (collapsible) {
    buttonStatus <- status %OR% "default"

    collapseIcon <- if (collapsed) "plus" else "minus"

    collapseTag <-
                       tags$button(class = paste0("btn btn-box-tool"),
                                   `data-widget` = "collapse",
                                   shiny::icon(collapseIcon)

    )
  }

  infoTag <- NULL
  if (!missing(info)) {
    buttonStatus <- status %OR% "default"

    infoIcon <- "info-circle"

    infoTag <-
                       tags$button(class = paste0("btn btn-default fa-2x"),
                                   shiny::icon(infoIcon)

    )
  }
  headerTag <- NULL
  if (!is.null(titleTag) || !is.null(collapseTag) || !is.null(infoTag)) {
    headerTag <- div(class = "box-header",
                     titleTag,
                      div(class = "box-tools pull-right",infoTag ,
                      collapseTag))

  }

  div(class = if (!is.null(width)) paste0("col-sm-", width),
      div(class = boxClass,
          style = if (!is.null(style)) style,
          headerTag,
          div(class = "box-body", fluidRow(...)),
          if (!is.null(footer)) div(class = "box-footer", footer)
      )
  )
}


#' Create a table Box
#'
#' @param id is the unique id of html elemnt.
#' @param title is the title of the Table box.
#' @param metriclist is list of matrix.
#' @param footer is the footer of the table box.
#' @param solidheader is the header of the table box.
#' @param background is the backgroundcolor of box.
#' @param width id the width of the box.
#' @param height is the heigth of the box.
#' @param collapsible is the box should be collapsibe.
#' @param collapsed is the box is collapsed.
#' @return <div class="col-sm-6">
#' <div class="box box-solid box-primary">
#'  <div class="box-body">
#'  <div class="row">
#'  tableBox
#'Enter Title
#'</div>
#'  </div>
#'  </div>
#'  </div>
#' @export
kpi_table_box <- function(..., id = NULL, title = NULL, metric_list = NULL,footer = NULL, status = "primary",info,
                           solidHeader = TRUE, background = NULL, width = 6,
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
    titleTag <- actionLink(id,h3(class = "box-title", title,style = "margin-left:10px;"))
  }

  collapseTag <- NULL
  if (collapsible) {
    buttonStatus <- status %OR% "default"

    collapseIcon <- if (collapsed) "plus" else "minus"

    collapseTag <-
      tags$button(class = paste0("btn btn-box-tool"),
                  `data-widget` = "collapse",
                  shiny::icon(collapseIcon)

      )
  }

  infoTag <- NULL
  if (!missing(info)) {
    buttonStatus <- status %OR% "default"

    infoIcon <- "info-circle"

    infoTag <-
      tags$button(class = paste0("btn btn-primary fa-2x"),
                  shiny::icon(infoIcon)

      )
  }
  headerTag <- NULL
  if (!is.null(titleTag) || !is.null(collapseTag) || !is.null(infoTag)) {
    headerTag <- div(class = "box-header",
                     titleTag,
                     div(class = "box-tools pull-right",infoTag ,
                         collapseTag))

  }

  div(class = if (!is.null(width)) paste0("col-sm-", width),
      div(class = boxClass,
          style = if (!is.null(style)) style,
          headerTag,
          div(class = "box-body", fluidRow(style = "margin-left: 6px;", ...)),
          if (!is.null(footer)) div(class = "box-footer", footer)
      )
  )
}

panel_box <- function(..., id = NULL, title = NULL, metric_list = NULL,footer = NULL, status = NULL,info=NULL,
                      solidHeader = TRUE, background = "blue", width = 6,
                      height = NULL, collapsible = FALSE, collapsed = FALSE){
  boxClass <- "box"
  if (solidHeader || !is.null(background)) {
    boxClass <- paste(boxClass, "box-")
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

    collapseTag <-
      tags$button(class = paste0("btn btn-box-tool"),
                  `data-widget` = "collapse",
                  shiny::icon(collapseIcon)

      )
  }

  infoTag <- NULL
  if (!is.null(info)) {
    buttonStatus <- status %OR% "default"

    infoIcon <- "info-circle"

    infoTag <-
      tags$button(class = paste0("btn btn-primary fa-2x"),
                  shiny::icon(infoIcon)

      )
  }
  headerPanel() <- NULL
  if (!is.null(titleTag) || !is.null(collapseTag) || !is.null(infoTag)) {
    headerTag <- div(class = "box-header",
                     titleTag,
                     div(class = "box-tools pull-right",infoTag ,
                         collapseTag))

  }

  div(class = if (!is.null(width)) paste0("col-sm-", width),
      div(class = boxClass,
          style = if (!is.null(style)) style,
          headerTag,
          div(class = "box-body", fluidRow(...)),
          if (!is.null(footer)) div(class = "box-footer", footer)
      )
  )

}


