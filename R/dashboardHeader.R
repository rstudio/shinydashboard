#' @export
dashboardHeader <- function(...) {
  items <- list(...)
  lapply(items, tagAssert, type = "li", class = "dropdown")

  tags$header(class = "header",
    a(href = "#", class = "logo", "Shiny Dashboard"),
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


#' @export
dropdownMenu <- function(...,
  type = c("messages", "notifications", "tasks", "user"),
  badgeType = c("none", "success", "info", "warning", "danger"))
{
  type <- match.arg(type)
  badgeType <- match.arg(badgeType)
  items <- list(...)

  # Make sure the items are li tags
  lapply(items, tagAssert, type = "li")

  if (type == "user")
    dropdownClass <- "dropdown user user-menu"
  else
    dropdownClass <- paste0("dropdown ", type, "-menu")

  iconClass <- switch(type,
    messages = "fa fa-envelope",
    notifications = "fa fa-warning",
    tasks = "fa fa-tasks",
    user = "glyphicon glyphicon-user"
  )

  numItems <- length(items)
  if (badgeType == "none") {
    badge <- NULL
  } else {
    badge <- span(class = paste0("label label-", badgeType), numItems)
  }

  tags$li(class = dropdownClass,
    a(href = "#", class = "dropdown-toggle", `data-toggle` = "dropdown",
      tags$i(class = iconClass),
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



#' @export
messageItem <- function(from, message, time, image = "foo.png")
{
  tags$li(
    a(href = "#",
      div(class = "pull-left",
        tags$img(src = "image", class = "img-circle", alt = "User Image")
      ),
      h4(
        from,
        tags$small(tags$i(class = "fa fa-clock-o"), time)
      ),
      p(message)
    )
  )
}


#' @export
notificationItem <- function(text, item,
    icon = c("ion-ios7-people", "fa-users", "fa-warning", "ion-ios7-cart", "ion-ios7-person"),
    type = c("success", "info", "warning", "danger"))
{
  icon <- match.arg(icon)
  type <- match.arg(type)

  validateIcon(icon)

  iconClass <- paste(getIconClass(icon), type)

  tags$li(
    a(href = "#",tags$i(class = iconClass), text)
  )
}


#' @export
progressItem <- function(text, value = 0,
    color = c("aqua", "green", "yellow", "red"))
{
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


