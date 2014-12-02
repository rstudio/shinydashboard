#' The main body of a dashboard page.
#'
#' The main body typically contains \code{\link{box}}es. Another common use
#' pattern is for the main body to contain \code{\link{tabItems}}.
#'
#' @param ... Items to put in the dashboard body.
#'
#' @seealso \code{\link{box}}, \code{\link{tabItems}},
#'
#' @export
dashboardBody <- function(...) {
  tags$section(class = "content",
    ...
  )
}
