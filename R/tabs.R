#' A container for tab items
#'
#' @param ... Items to put in the container. Each item should be a
#'   \code{\link{tabItem}}.
#'
#' @seealso \code{\link{menuItem}}, \code{\link{menuSubItem}},
#'   \code{\link{tabItem}}. See \code{\link{sidebarMenu}} for a usage example.
#' @export
tabItems <- function(...) {
  lapply(list(...), tagAssert, class = "tab-pane")

  div(class = "tab-content", ...)
}

#' One tab to put inside a tab items container
#'
#' @param tabName The name of a tab. This must correspond to the \code{tabName}
#'   of a \code{\link{menuItem}} or \code{\link{menuSubItem}}.
#' @param ... Contents of the tab.
#'
#' @seealso \code{\link{menuItem}}, \code{\link{menuSubItem}},
#'   \code{\link{tabItems}}. See \code{\link{sidebarMenu}} for a usage example.
#' @export
tabItem <- function(tabName = NULL, ...) {
  if (is.null(tabName))
    stop("Need tabName")

  div(
    role = "tabpanel",
    class = "tab-pane",
    id = paste0("shiny-tab-", tabName),
    ...
  )
}
