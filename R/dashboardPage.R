#' Dashboard page
#'
#' This creates a dashboard page for use in a Shiny app.
#'
#' @param header A header created by \code{dashboardHeader}.
#' @param sidebar A sidebar created by \code{dashboardSidebar}.
#' @param body A body created by \code{dashboardBody}.
#' @param title A title to display in the browser's title bar. If no value is
#'   provided, it will try to extract the title from the \code{dashboardHeader}.
#' @param skin A color theme. One of \code{"blue"}, \code{"black"},
#'   \code{"purple"}, \code{"green"}, \code{"red"}, or \code{"yellow"}.
#' @param theme One of the following:
#'   * `NULL` (the default), which implies a "stock" build of Bootstrap 3.
#'   * A [bslib::bs_theme()] object. This can be used to replace a stock
#'   build of Bootstrap 3 with a customized version of Bootstrap 3.
#'   * A character string pointing to an alternative Bootstrap stylesheet
#'   (normally a css file within the www directory, e.g. `www/bootstrap.css`).
#'
#'  @inheritParams shiny::bootstrapPage
#'
#' @seealso \code{\link{dashboardHeader}}, \code{\link{dashboardSidebar}},
#'   \code{\link{dashboardBody}}.
#' @examples
#' ## Only run this example in interactive R sessions
#' if (interactive()) {
#' # Basic dashboard page template
#' library(shiny)
#' shinyApp(
#'   ui = dashboardPage(
#'     dashboardHeader(),
#'     dashboardSidebar(),
#'     dashboardBody(),
#'     title = "Dashboard example"
#'   ),
#'   server = function(input, output) { }
#' )
#' }
#' @export
dashboardPage <- function(header, sidebar, body, title = NULL,
  skin = c("blue", "black", "purple", "green", "red", "yellow"),
  theme = NULL, lang = NULL) {

  tagAssert(header, type = "header", class = "main-header")
  tagAssert(sidebar, type = "aside", class = "main-sidebar")
  tagAssert(body, type = "div", class = "content-wrapper")
  skin <- match.arg(skin)
  if (is_bs_theme(theme)) {
    if (!identical(bslib::theme_version(theme), "4")) {
      stop(
        "Using `bslib::bs_theme()` with `dashboardPage()`, ",
        "currently requires Bootstrap 4; that is, ",
        "`bslib::bs_theme(version = 4, ...)`"
      )
    }
  }

  headerTitle <- tagFunctionVersion(
    three = bs3_extract_title,
    default = bs4_extract_title,
    args = list(header)
  )

  title <- title %OR% headerTitle

  content <- div(class = "wrapper",
    header,
    sidebar,
    body
  )

  # if the sidebar has the attribute `data-collapsed = "true"`, it means that
  # the user set the `collapsed` argument of `dashboardSidebar` to TRUE
  # TODO: handle this in JS?
  #collapsed <- findAttribute(sidebar, "data-collapsed", "true")

  tags$body(
    # the "sidebar-collapse" class on the body means that the sidebar should
    # the collapsed (AdminLTE code)
    class = paste0("skin-", skin),
    #class = if (collapsed) " sidebar-collapse"),
    style = "min-height: 611px;",
    shiny::bootstrapPage(content, title = title, theme = theme, lang = lang),
    if (is_bs_theme(theme)) bslib::bs_dependency_defer(dashboard_dependencies) else dashboard_dependencies()
  )
}

bs3_extract_title <- function(header) {
  x <- as.tags(header)$children[[2]]
  if (x$name == "span" &&
      !is.null(x$attribs$class) &&
      x$attribs$class == "logo" &&
      length(x$children) != 0)
  {
    x$children[[1]]
  } else {
    ""
  }
}

bs4_extract_title <- function(header) {

}
