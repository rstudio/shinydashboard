#' The main body of a dashboard page.
#'
#' The main body typically contains [box()]es. Another common use
#' pattern is for the main body to contain [tabItems()].
#'
#' @param ... Items to put in the dashboard body.
#'
#' @seealso [tabItems()], [box()], [valueBox()].
#'
#' @export
dashboardBody <- function(...) {
  div(class = "content-wrapper", tags$section(class = "content", ...))
}
