#' Create a header for a dashboard page
#'
#' A dashboard header can be left blank, or it can include dropdown menu items
#' on the right side.
#'
#' @param title An optional title for the dashboard.
#' @param ... Items to put in the header. Should be \code{\link{dropdownMenu}}s..
#'
#' @seealso \code{\link{dropdownMenu}}
#'
#' @examples
#' \donttest{
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
dashboardHeader <- function(..., title = NULL) {
  items <- list(...)
  lapply(items, tagAssert, type = "li", class = "dropdown")

  tags$header(class = "header",
    a(href = "#", class = "logo", title),
    tags$nav(class = "navbar navbar-static-top", role = "navigation",
      # Sidebar toggle button
      a(href="#", class="navbar-btn sidebar-toggle", `data-toggle`="offcanvas",
        role="button",
        span(class="sr-only", "Toggle navigation"),
        span(class="icon-bar"),
        span(class="icon-bar"),
        span(class="icon-bar")
      ),
      div(class = "navbar-right",
        tags$ul(class = "nav navbar-nav",
          ...
        )
      )
    )
  )
}


#' Create a dropdown menu to place in a dashboard header
#'
#' @param type The type of menu. Should be one of "messages", "notifications",
#'   "tasks", or "user".
#' @param badgeStatus The status of the badge. This determines the badge's
#'   color. Valid statuses are listed in \code{shinydashboard:::validStatuses}.
#' @param ... Items to put in the menu. Typically, message menus should contain
#'   \code{\link{messageItem}}s, notification menus should contain
#'   \code{\link{notificationItem}}s, and task menus should contain
#'   \code{\link{taskItem}}s.
#'
#' @seealso \code{\link{dashboardHeader}} for example usage.
#'
#' @export
dropdownMenu <- function(...,
  type = c("messages", "notifications", "tasks", "user"),
  badgeStatus = "none")
{
  type <- match.arg(type)
  if (badgeStatus != "none") validateStatus(badgeStatus)
  items <- list(...)

  # Make sure the items are li tags
  lapply(items, tagAssert, type = "li")

  if (type == "user")
    dropdownClass <- "dropdown user user-menu"
  else
    dropdownClass <- paste0("dropdown ", type, "-menu")

  icon <- switch(type,
    messages = shiny::icon("envelope"),
    notifications = shiny::icon("warning"),
    tasks = shiny::icon("tasks"),
    user = shiny::icon("user", lib = "glyphicon")
  )

  numItems <- length(items)
  if (badgeStatus == "none") {
    badge <- NULL
  } else {
    badge <- span(class = paste0("label label-", badgeStatus), numItems)
  }

  tags$li(class = dropdownClass,
    a(href = "#", class = "dropdown-toggle", `data-toggle` = "dropdown",
      icon,
      badge
    ),
    tags$ul(class = "dropdown-menu",
      tags$li(class = "header", paste("You have", numItems, type)),
      tags$li(
        tags$ul(class = "menu",
          ...
        )
      )
      # TODO: This would need to be added to the outer ul
      # tags$li(class = "footer", a(href="#", "View all"))
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
#'
#' @family menu items
#' @seealso \code{\link{dashboardHeader}} for example usage.
#' @export
messageItem <- function(from, message, icon = shiny::icon("user"), time = NULL)
{
  tagAssert(icon, type = "i")

  tags$li(
    a(href = "#",
      icon,
      h4(
        from,
        if (!is.null(time)) tags$small(shiny::icon("clock-o"), time)
      ),
      p(message)
    )
  )
}


#' Create a notification item to place in a dropdown notification menu
#'
#' @param text The notification text.
#' @param icon An icon tag, created by \code{\link[shiny]{icon}}.
#' @param status The status of the item This determines the item's background
#'   color. Valid statuses are listed in \code{shinydashboard:::validStatuses}.
#'
#' @family menu items
#' @seealso \code{\link{dashboardHeader}} for example usage.
#' @export
notificationItem <- function(text, icon = shiny::icon("warning"), status = "success")
{
  tagAssert(icon, type = "i")
  validateStatus(status)

  # Add the status as another HTML class to the icon
  icon <- tagAppendAttributes(icon, class = status)

  tags$li(
    a(href = "#", icon, text)
  )
}


#' Create a task item to place in a dropdown task menu
#'
#' @param text The task text.
#' @param value A percent value to use for the bar.
#' @param color A color for the bar. Valid colors are listed in
#'   \code{shinydashboard:::validColors}.
#'
#' @family menu items
#' @seealso \code{\link{dashboardHeader}} for example usage.
#' @export
taskItem <- function(text, value = 0, color = "aqua") {
  validateColor(color)

  tags$li(
    a(href = "#",
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


