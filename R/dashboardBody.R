#' The main body of a dashboard page.
#'
#' The main body typically contains \code{\link{box}}es. Another common use
#' pattern is for the main body to contain \code{\link{tabItems}}.
#'
#' @param ... Items to put in the dashboard body.
#'
#' @seealso \code{\link{tabItems}}, \code{\link{box}}, \code{\link{valueBox}}.
#'
#' @export
dashboardBody <- function(...) {
  div(class = "content-wrapper",
    tags$section(class = "content",
      ...
    )
  )
}
