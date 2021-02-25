#' Create a header for a dashboard page
#'
#' A dashboard header can be left blank, or it can include dropdown menu items
#' on the right side.
#'
#' @param title An optional title to show in the header bar.. By default, this
#'   will also be used as the title shown in the browser's title bar. If you
#'   want that to be different from the text in the dashboard header bar, set
#'   the \code{title} in \code{\link{dashboardPage}}.
#' @param titleWidth The width of the title area. This must either be a number
#'   which specifies the width in pixels, or a string that specifies the width
#'   in CSS units.
#' @param disable If \code{TRUE}, don't display the header bar.
#' @param ... Items to put in the header. Should be \code{\link{dropdownMenu}}s.
#' @param .list An optional list containing items to put in the header. Same as
#'   the \code{...} arguments, but in list format. This can be useful when
#'   working with programmatically generated items.
#'
#' @seealso \code{\link{dropdownMenu}}
#'
#' @examples
#' ## Only run this example in interactive R sessions
#' if (interactive()) {
#' library(shiny)
#'
#' # A dashboard header with 3 dropdown menus
#' header <- dashboardHeader(
#'   title = "Dashboard Demo",
#'
#'   # Dropdown menu for messages
#'   dropdownMenu(type = "messages", badgeStatus = "success",
#'     messageItem("Support Team",
#'       "This is the content of a message.",
#'       time = "5 mins"
#'     ),
#'     messageItem("Support Team",
#'       "This is the content of another message.",
#'       time = "2 hours"
#'     ),
#'     messageItem("New User",
#'       "Can I get some help?",
#'       time = "Today"
#'     )
#'   ),
#'
#'   # Dropdown menu for notifications
#'   dropdownMenu(type = "notifications", badgeStatus = "warning",
#'     notificationItem(icon = icon("users"), status = "info",
#'       "5 new members joined today"
#'     ),
#'     notificationItem(icon = icon("warning"), status = "danger",
#'       "Resource usage near limit."
#'     ),
#'     notificationItem(icon = icon("shopping-cart", lib = "glyphicon"),
#'       status = "success", "25 sales made"
#'     ),
#'     notificationItem(icon = icon("user", lib = "glyphicon"),
#'       status = "danger", "You changed your username"
#'     )
#'   ),
#'
#'   # Dropdown menu for tasks, with progress bar
#'   dropdownMenu(type = "tasks", badgeStatus = "danger",
#'     taskItem(value = 20, color = "aqua",
#'       "Refactor code"
#'     ),
#'     taskItem(value = 40, color = "green",
#'       "Design new layout"
#'     ),
#'     taskItem(value = 60, color = "yellow",
#'       "Another task"
#'     ),
#'     taskItem(value = 80, color = "red",
#'       "Write documentation"
#'     )
#'   )
#' )
#'
#' shinyApp(
#'   ui = dashboardPage(
#'     header,
#'     dashboardSidebar(),
#'     dashboardBody()
#'   ),
#'   server = function(input, output) { }
#' )
#' }
#' @export
dashboardHeader <- function(..., title = NULL, titleWidth = NULL, disable = FALSE, .list = NULL) {
  items <- c(list(...), .list)
  lapply(items, tagAssert, type = "li", class = "dropdown")
  titleWidth <- validateCssUnit(titleWidth)

  tagFunctionVersion(
    three = bs3_header,
    default = bs4_header, # hopefully this works for BS5, too
    args = list(items, title, titleWidth, disable)
  )
}

bs3_header <- function(items, title, titleWidth, disable) {
  # Set up custom CSS for custom width.
  custom_css <- NULL
  if (!is.null(titleWidth)) {
    # This CSS is derived from the header-related instances of '230px' (the
    # default sidebar width) from inst/AdminLTE/AdminLTE.css. One change is that
    # instead making changes to the global settings, we've put them in a media
    # query (min-width: 768px), so that it won't override other media queries
    # (like max-width: 767px) that work for narrower screens.
    custom_css <- tags$head(tags$style(HTML(gsub("_WIDTH_", titleWidth, fixed = TRUE, '
      @media (min-width: 768px) {
        .main-header > .navbar {
          margin-left: _WIDTH_;
        }
        .main-header .logo {
          width: _WIDTH_;
        }
      }
    '))))
  }

  tags$header(class = "main-header",
    custom_css,
    style = if (disable) "display: none;",
    span(class = "logo", title),
    tags$nav(class = "navbar navbar-static-top", role = "navigation",
      # Embed hidden icon so that we get the font-awesome dependency
      span(shiny::icon("bars"), style = "display:none;"),
      # Sidebar toggle button
      a(href="#", class="sidebar-toggle", `data-toggle`="offcanvas",
        role="button",
        span(class="sr-only", "Toggle navigation")
      ),
      div(class = "navbar-custom-menu",
        tags$ul(class = "nav navbar-nav",
          items
        )
      )
    )
  )
}

bs4_header <- function(items, title, titleWidth, disable) {
  # TODO: do we need the custom css? disable option!
  tags$nav(
    # navbar-inverse is here because admintle defines it's own navbar-dark which doesn't know about bslib's $navbar-bg
    class = "main-header navbar navbar-expand navbar-inverse",
    tags$ul(
      class = "navbar-nav",
      tags$li(
        class = "nav-item",
        tags$a(
          class = "nav-link",
          `data-widget` = "pushmenu",
          href = "#",
          shiny::icon("bars")
        )
      )
    ),
    tags$ul(
      class = "navbar-nav ml-auto",
      items
    )
  )
}


#' Create a dropdown menu to place in a dashboard header
#'
#' @param type The type of menu. Should be one of "messages", "notifications",
#'   "tasks".
#' @param badgeStatus The status of the badge which displays the number of items
#'   in the menu. This determines the badge's color. Valid statuses are listed
#'   in \link{validStatuses}. A value of \code{NULL} means to not display a
#'   badge.
#' @param ... Items to put in the menu. Typically, message menus should contain
#'   \code{\link{messageItem}}s, notification menus should contain
#'   \code{\link{notificationItem}}s, and task menus should contain
#'   \code{\link{taskItem}}s.
#' @param icon An icon to display in the header. By default, the icon is
#'   automatically selected depending on \code{type}, but it can be overriden
#'   with this argument.
#' @param headerText An optional text argument used for the header of the
#'   dropdown menu (this is only visible when the menu is expanded). If none is
#'   provided by the user, the default is "You have \code{x} messages," where
#'   \code{x} is the number of items in the menu (if the \code{type} is
#'   specified to be "notifications" or "tasks," the default text shows "You
#'   have \code{x} notifications" or  "You have \code{x} tasks," respectively).
#' @param .list An optional list containing items to put in the menu Same as the
#'   \code{...} arguments, but in list format. This can be useful when working
#'   with programmatically generated items.
#'
#' @seealso \code{\link{dashboardHeader}} for example usage.
#'
#' @export
dropdownMenu <- function(...,
  type = c("messages", "notifications", "tasks"),
  badgeStatus = "primary", icon = NULL, headerText = NULL,
  .list = NULL)
{
  type <- match.arg(type)
  if (!is.null(badgeStatus)) validateStatus(badgeStatus) # TODO: validation needs to be different?
  items <- c(list(...), .list)

  # Make sure the items are li tags
  lapply(items, tagAssert, type = "li")

  dropdownClass <- paste0("dropdown ", type, "-menu")

  if (is.null(icon)) {
    icon <- switch(type,
      messages = shiny::icon("envelope"),
      notifications = shiny::icon("warning"),
      tasks = shiny::icon("tasks")
    )
  }

  numItems <- length(items)
  if (is.null(headerText)) {
    headerText <- paste("You have", numItems, type)
  }

  tagFunctionVersion(
    three = bs3_dropdown_menu,
    default = bs4_dropdown_menu, # hopefully this works for BS5, too
    args = list(items, icon, badgeStatus, numItems, headerText, dropdownClass)
  )
}


bs3_dropdown_menu <- function(items, icon, badgeStatus, numItems, headerText, dropdownClass) {
  tags$li(class = dropdownClass,
    a(href = "#", class = "dropdown-toggle", `data-toggle` = "dropdown",
      icon,
      if (!is.null(badgeStatus)) span(class = paste0("label label-", badgeStatus), numItems)
    ),
    tags$ul(class = "dropdown-menu",
      tags$li(class = "header", headerText),
      tags$li(
        tags$ul(class = "menu",
          items
        )
      )
      # TODO: This would need to be added to the outer ul
      # tags$li(class = "footer", a(href="#", "View all"))
    )
  )
}

bs4_dropdown_menu <- function(items, icon, badgeStatus, numItems, headerText, dropdownClass) {
  items <- lapply(items, function(x) {
    tagList(x, div(class = "dropdown-divider"))
  })

  tags$li(
    class = dropdownClass,
    class = "nav-item",
    a(
      href = "#", class = "nav-link",
      `data-toggle` = "dropdown", icon,
      if (!is.null(badgeStatus)) span(class = paste0("badge badge-", badgeStatus, " navbar-badge"), numItems)
    ),
    tags$ul(
      class = "dropdown-menu dropdown-menu-lg dropdown-menu-right",
      tags$span(class = "dropdown-item dropdown-header", headerText),
      div(class = "dropdown-divider"),
      items
    )
  )
}


#' Create a message item to place in a dropdown message menu
#'
#' @param from Who the message is from.
#' @param message Text of the message.
#' @param icon An icon tag, created by \code{\link[shiny]{icon}}.
#' @param time String representing the time the message was sent. Any string may
#'   be used. For example, it could be a relative date/time like "5 minutes",
#'   "today", or "12:30pm yesterday", or an absolute time, like "2014-12-01 13:45".
#'   If NULL, no time will be displayed.
#' @param href An optional URL to link to.
#'
#' @family menu items
#' @seealso \code{\link{dashboardHeader}} for example usage.
#' @export
messageItem <- function(from, message, icon = shiny::icon("user"), time = NULL,
  href = NULL)
{
  tagAssert(icon, type = "i")
  if (is.null(href)) href <- "#"

  tagFunctionVersion(
    three = bs3_message_item,
    default = bs4_message_item, # hopefully this works for BS5, too
    args = list(from, message, icon, time, href)
  )
}

bs3_message_item <- function(from, message, icon, time, href) {
  tags$li(
    a(href = href,
      icon,
      h4(
        from,
        if (!is.null(time)) tags$small(shiny::icon("clock-o"), time)
      ),
      p(message)
    )
  )
}

bs4_message_item <- function(from, message, icon, time, href) {
  a(
    href = href,
    class = "dropdown-item",
    div(
      class = "media",
      icon,
      div(
        class = "media-body",
        h3(class = "dropdown-item-title", from),
        p(class = "text-sm", message),
        p(
          class = "text-sm text-muted",
          shiny::icon("clock-o", class = "mr-1"),
          time
        )
      )
    )
  )
}


#' Create a notification item to place in a dropdown notification menu
#'
#' @param text The notification text.
#' @param icon An icon tag, created by \code{\link[shiny]{icon}}.
#' @param status The status of the item This determines the item's background
#'   color. Valid statuses are listed in \link{validStatuses}.
#' @param href An optional URL to link to.
#'
#' @family menu items
#' @seealso \code{\link{dashboardHeader}} for example usage.
#' @export
notificationItem <- function(text, icon = shiny::icon("warning"),
  status = "success", href = NULL)
{
  tagAssert(icon, type = "i")
  validateStatus(status)
  if (is.null(href)) href <- "#"

  # Add the status as another HTML class to the icon
  icon <- tagAppendAttributes(icon, class = paste0("text-", status), class = "mr-2")

  tagFunctionVersion(
    three = bs3_notification,
    default = bs4_notification, # hopefully this works for BS5, too
    args = list(text, icon, href)
  )
}

bs3_notification <- function(text, icon, href) {
  tags$li(a(href = href, icon, text))
}

bs4_notification <- function(text, icon, href) {
  a(class = "dropdown-item", href = href, icon, text)
}


#' Create a task item to place in a dropdown task menu
#'
#' @param text The task text.
#' @param value A percent value to use for the bar.
#' @param color A color for the bar. Valid colors are listed in
#'   \link{validColors}.
#' @param href An optional URL to link to.
#'
#' @family menu items
#' @seealso \code{\link{dashboardHeader}} for example usage.
#' @export
taskItem <- function(text, value = 0, color = "aqua", href = NULL) {
  validateColor(color)
  if (is.null(href)) href <- "#"

  tagFunctionVersion(
    three = bs3_task_item,
    default = bs4_task_item, # hopefully this works for BS5, too
    args = list(text, value, color, href)
  )
}


bs3_task_item <- function(text, value, color, href) {
  tags$li(
    a(href = href,
      h3(text,
         tags$small(class = "pull-right", paste0(value, "%"))
      ),
      div(class = "progress xs",
          div(
            class = paste0("progress-bar progress-bar-", color),
            style = paste0("width: ", value, "%"),
            role = "progressbar",
            `aria-valuenow` = value,
            `aria-valuemin` = "0",
            `aria-valuemax` = "100",
            span(class = "sr-only", paste0(value, "% complete"))
          )
      )
    )
  )
}

bs4_task_item <- function(text, value, color, href) {
    a(
      href = href,
      class = "dropdown-item",
      div(
        style = "display:flex; justify-content: space-between",
        div(text), div(class = "text-sm text-muted", paste0(value, "%"))
      ),
      div(class = "progress xs",
          div(
            class = paste0("progress-bar bg-", color),
            style = paste0("width: ", value, "%"),
            role = "progressbar",
            `aria-valuenow` = value,
            `aria-valuemin` = "0",
            `aria-valuemax` = "100",
            span(class = "sr-only", paste0(value, "% complete"))
          )
      )
    )
}

