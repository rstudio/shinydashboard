#' @export
dashboardBody <- function(...) {

  tags$section(class = "content",
    div(class = "row",
      ...
    )
  )

}
