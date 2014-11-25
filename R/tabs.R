#' @export
tabItems <- function(...) {
  div(class = "tab-content", ...)
}

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
