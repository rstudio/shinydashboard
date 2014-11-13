#' Create a small box for the main body of a dashboard.
#' @examples
#' smallBox("150", "New Orders", icon = "fa-credit-card")
#'
#' # Can use tag objects for value
#' smallBox(tagList("60", tags$sup(style="font-size: 20px", "%")),
#'          "Approval Rating", icon = "fa-line-chart", color = "green")
#'
#' @export
smallBox <- function(value, subtitle, icon, color = "aqua", width = 3) {
  validateColor(color)
  validateIcon(icon)
  iconClass <- getIconClass(icon)

  div(class = paste0("col-sm-", width),
    div(class = paste0("small-box bg-", color),
      div(class = "inner",
        h3(value),
        p(subtitle)
      ),
      div(class = "icon", tags$i(class = iconClass)),
      a(href = "#", class = "small-box-footer",
        "More info", tags$i(class = "fa fa-arrow-circle-right")
      )
    )
  )
}

#' Create a box for the main body of a dashboard
#' @examples
#' box("Title here", p("Text in the box"))
#' @export
box <- function(title, ..., footer = NULL, status = "none", solid = FALSE,
                width = 4) {

  boxClass <- "box"
  if (solid) boxClass <- paste(boxClass, "box-solid")
  if (status != "none") {
    validateStatus(status)
    boxClass <- paste0(boxClass, " box-", status)
  }

  div(class = paste0("col-md-", width),
    div(class = boxClass,
      div(class = "box-header",
        h3(class = "box-title", title),
        div(class = "box-tools pull-right",
          tags$button(class = "btn btn-default btn-sm",
            `data-widget` = "collapse", `data-toggle` = "tooltip",
            title = "Collapse",
            tags$i(class = "fa fa-minus")
          )
        )
      ),
      div(class = "box-body", ...),
      if (!is.null(footer)) div(class = "box-footer", footer)
    )
  )
}
