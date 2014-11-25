#' @export
dashboardSidebar <- function(...) {
  tags$section(class = "sidebar",
    list(...)
  )
}

#' @export
sidebarUserPanel <- function(name) {
  div(class = "user-panel",
    div(class = "pull-left image",
      img(src = "foo.png", class = "img-circle", alt = "User Image")
    ),
    div(class = "pull-left info",
      p(paste("Hello,", name)),
      a(href = "#", icon("circle", class = "text-success"), "Online")
    )
  )
}

#' @export
sidebarSearchForm <- function(textId, buttonId, label = "Search...") {
  tags$form(class = "sidebar-form",
    div(class = "input-group",
      tags$input(id = textId, type = "text", class = "form-control",
        placeholder = label
      ),
      span(class = "input-group-btn",
        tags$button(id = buttonId, type = "button",
          class = "btn btn-flat action-button",
          icon("search")
        )
      )
    )
  )
}

#' @export
sidebarMenu <- function(...) {
  items <- list(...)

  # Make sure the items are li tags
  lapply(items, tagAssert, type = "li")

  tags$ul(class = "sidebar-menu",
    ...
  )
}

#' Create a dashboard sidebar menu item.
#'
#' @param icon An icon tag, created by \code{\link[shiny]{icon}}.
#' @param badgeLabel A label for an optional badge. Usually a number or a short
#'   word like "new".
#' @param items A character vector or list of names for subitems.
#' @export
menuItem <- function(text, icon = NULL, badgeLabel = NULL, badgeColor = "green",
                     href = NULL, tabName = NULL, subItems = NULL) {
  if (!is.null(icon)) tagAssert(icon, type = "i")
  if (!is.null(href) && !is.null(tabName)) {
    stop("Can't specify both href and tabName")
  }
  if (!is.null(badgeLabel) && !is.null(subItems)) {
    stop("Can't have both badge and subItems")
  }
  validateColor(badgeColor)

  # If there's a tabName, set up the correct href
  isTabItem <- FALSE
  if (!is.null(tabName)) {
    isTabItem <- TRUE
    href <- paste0("#shiny-tab-", tabName)
  } else if (is.null(href)) {
    href <- "#"
  }

  # Generate badge if needed
  if (!is.null(badgeLabel)) {
    badgeTag <- tags$small(
      class = paste0("badge pull-right bg-", badgeColor),
      badgeLabel
    )
  } else {
    badgeTag <- NULL
  }

  # If no subitems, return a pretty simple tag object
  if (is.null(subItems)) {
    return(
      tags$li(
        a(href = href,
          `data-toggle` = if (isTabItem) "tab",
          icon,
          span(text),
          badgeTag
        )
      )
    )
  }

  # Make sure the subItems are li tags
  lapply(subItems, tagAssert, type = "li")

  tags$li(class = "treeview",
    a(href = href,
      tags$i(class = getIconClass(icon)),
      span(text),
      icon("angle-left", class = "pull-right")
    ),
    tags$ul(class = "treeview-menu",
      subItems
    )
  )
}

#' @export
menuSubItem <- function(text, href = NULL, tabName = NULL) {

  if (!is.null(href) && !is.null(tabName)) {
    stop("Can't specify both href and tabName")
  }

  # If there's a tabName, set up the correct href
  isTabItem <- FALSE
  if (!is.null(tabName)) {
    isTabItem <- TRUE
    href <- paste0("#shiny-tab-", tabName)
  } else if (is.null(href)) {
    href <- "#"
  }


  tags$li(
    a(href = href,
      `data-toggle` = if (isTabItem) "tab",
      icon("angle-double-right"),
      text
    )
  )
}
