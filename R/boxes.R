#' @examples
#' smallBox("150", "New Orders", icon = "ion-bag")
#'
#' # Can use tag objects for value
#' smallBox(tagList("60", tags$sup(style="font-size: 20px", "%")),
#'          "Approval Rating", icon = "ion-bag", color = "green")
#'
#' @export
smallBox <- function(value, subtitle, icon, color = "aqua") {
  validateColor(color)
  validateIcon(icon)
  iconClass <- getIconClass(icon)

  div(class = "col-lg-3 col-xs-6",
    div(class = paste0("small-box bg-", color),
      div(class = "inner",
        h3(value, p(subtitle))
      ),
      div(class = "icon", tags$i(class = iconClass)),
      a(href = "#", class = "small-box-footer",
        "More info", tags$i(class = "fa fa-arrow-circle-right")
      )
    )
  )
}
