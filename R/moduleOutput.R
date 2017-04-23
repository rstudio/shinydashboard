#' Create a dynamic module output for shinydashboard (client side)
#'
#' This can be used as a placeholder for dynamically-generated
#' \code{\link{dashboardUser}}, \code{\link{dashboardFooter}}.
#' If called directly, you must make sure to supply the correct
#' type of tag. It is simpler to use the wrapper functions if
#' present; for example, \code{\link{userOutput}} and
#' \code{\link{footerOutput}}.
#'
#' @param outputId Output variable name.
#' @param tag A tag function, like \code{tags$li} or \code{tags$ul}.
#'
#' @family module outputs
#' @seealso \code{\link{renderUI}} for the corresponding server side function
#'   and examples.
#' @seealso \code{\link{userOutput}} and \code{\link{footerOutput}}
#'   as wrapper function of \code{\link{moduleOutput}}.
#'
#' @export
moduleOutput <- function(outputId, tag = tags$li) {
  tag(id = outputId, class = "shinydashboard-module-output")
}

