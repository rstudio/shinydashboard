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
      img(src = "foo.png",  class = "img-circle", alt = "User Image")
    ),
    div(class = "pull-left info",
      p(paste("Hello,", name)),
      a(href = "#", tags$i(class = "fa fa-circle text-success"), "Online")
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
          tags$i(class = "fa fa-search")
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
#' @param badgeLabel A label for an optional badge. Usually a number or a short
#'   word like "new".
#' @param items A character vector or list of names for subitems.
#' @export
menuItem <- function(text, icon, badgeLabel = NULL, badgeColor = "green",
                     items = NULL) {
  if (!is.null(badgeLabel) && !is.null(items)) {
    stop("Can't have both badge and items")
  }
  validateColor(badgeColor)
  validateIcon(icon)

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
  if (is.null(items)) {
    return(
      tags$li(
        a(href = "#",
          tags$i(class = getIconClass(icon)),
          span(text),
          badgeTag
        )
      )
    )
  }

  # Generate subitems
  itemTags <- lapply(items, function(item) {
    tags$li(
      a(href = "#",
        tags$i(class = "fa fa-angle-double-right"),
        item
      )
    )
  })

  tags$li(class = "treeview",
    a(href = "#",
      tags$i(class = getIconClass(icon)),
      span(text),
      tags$i(class = "fa fa-angle-left pull-right")
    ),
    tags$ul(class = "treeview-menu",
      itemTags
    )
  )
}
