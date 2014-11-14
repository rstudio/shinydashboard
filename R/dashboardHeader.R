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
    messages = icon("envelope"),
    notifications = icon("warning"),
    tasks = icon("tasks"),
    user = icon("user", lib = "glyphicon")
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
        tags$small(icon("clock-o"), time)
      ),
      p(message)
    )
  )
}


#' @export
notificationItem <- function(text, item, icon = icon("warning"),
    status = "success")
{
  tagAssert(icon, type = "i")
  validateStatus(status)

  # Add the status as another HTML class to the icon
  icon <- tagAppendAttributes(icon, class = status)

  tags$li(
    a(href = "#", icon, text)
  )
}


#' @export
progressItem <- function(text, value = 0, color = "aqua") {
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


