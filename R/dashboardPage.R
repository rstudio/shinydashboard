#' Dashboard page
#'
#' @examples
#' library(shiny)
#' shinyApp(
#'   options = list(port = 9000),
#'   ui = dashboardPage(),
#'   server = function(input, output) {
#'   }
#' )
#' @export
dashboardPage <- function(...) {
  deps <- list(
    htmlDependency("font-awesome", "4.1.0",
      src = c(href = "//cdnjs.cloudflare.com/ajax/libs/font-awesome/4.1.0/css/"),
      stylesheet = "font-awesome.min.css"
    ),
    htmlDependency("ionicons", "1.5.2",
      src = c(href = "http://code.ionicframework.com/ionicons/1.5.2/css/"),
      stylesheet = "ionicons.min.css"
    ),
    htmlDependency("AdminLTE", "1.2",
      c(file = system.file("AdminLTE", package = "shinydashboard")),
      stylesheet = c("AdminLTE.css")
    )
  )


  page <- tagList(
    # Need to add classes to <body>. Shiny doesn't have a way of doing that
    # directly, so we'll do it with jQuery.
    tags$script(type="text/javascript",
      "$('body').addClass('skin-blue');
       $('body').css('min-height', '611px');"
    ),
    # Header navbar ------------------------------------
    tags$header(class = "header",
      a(href = "#", class = "logo", "ShinyDash"),
      tags$nav(class = "navbar navbar-static-top", role = "navigation",
        # Sidebar toggle button
        a(href="#", class="navbar-btn sidebar-toggle", `data-toggle`="offcanvas", role="button",
          span(class="sr-only", "Toggle navigation"),
          span(class="icon-bar"),
          span(class="icon-bar"),
          span(class="icon-bar")
        ),
        div(class = "navbar-right",
          tags$ul(class = "nav navbar-nav",
            # Messages
            dropdownMenu(type = "messages", badgeType = "success",
              # A message
              messageItem("Support Team",
                "Why not buy an awesome theme?",
                time = "5 mins"
              ),
              messageItem("Support Team",
                "Why not buy an awesome theme?",
                time = "2 hours"
              ),
              messageItem("Support Team",
                "Why not buy an awesome theme?",
                time = "Today"
              )
            ),
            # Notifications
            dropdownMenu(type = "notifications", badgeType = "warning",
              notificationItem(icon = "ion-ios7-people", type = "info",
                "5 new members joined today"
              ),
              notificationItem(icon = "fa-warning", type = "danger",
                "Very long description here that may not fit into the page and may cause design problems"
              ),
              notificationItem(icon = "fa-users", type = "warning",
                "5 new members joined"
              ),
              notificationItem(icon = "ion-ios7-cart", type = "success",
                "25 sales made"
              ),
              notificationItem(icon = "ion-ios7-person", type = "danger",
                "You changed your username"
              )
            ),
            # Tasks
            dropdownMenu(type = "tasks", badgeType = "danger",
              progressItem(value = 20, color = "aqua",
                "Create a nice theme"
              ),
              progressItem(value = 40, color = "green",
                "Design some buttons"
              ),
              progressItem(value = 60, color = "yellow",
                "Another task"
              ),
              progressItem(value = 80, color = "red",
                "And yet another task"
              )
            )
          )
        )
      )
    )
  )

  addDependencies(shiny::bootstrapPage(page), deps)
}


#' @export
dropdownMenu <- function(...,
  type = c("messages", "notifications", "tasks", "user"),
  badgeType = c("none", "success", "info", "warning", "danger"))
{
  type <- match.arg(type)
  badgeType <- match.arg(badgeType)
  items <- list(...)

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

  # TODO: make sure the items are li items


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

  iconClass <- sub("^((fa)|(ion))-.*", "\\1", icon)
  iconClass <- paste(iconClass, icon, type)

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



