#' Create a dashboard sidebar.
#'
#' A dashboard sidebar typically contains a \code{\link{sidebarMenu}}, although
#' it may also contain a \code{\link{sidebarSearchForm}}, or other Shiny inputs.
#'
#' @param ... Items to put in the sidebar.
#' @param disable If \code{TRUE}, the sidebar will be disabled.
#' @param width The width of the sidebar. This must either be a number which
#'   specifies the width in pixels, or a string that specifies the width in CSS
#'   units.
#' @param collapsed If \code{TRUE}, the sidebar will be collapsed on app startup.
#'
#' @seealso \code{\link{sidebarMenu}}
#'
#' @examples
#' ## Only run this example in interactive R sessions
#' if (interactive()) {
#' header <- dashboardHeader()
#'
#' sidebar <- dashboardSidebar(
#'   sidebarUserPanel("User Name",
#'     subtitle = a(href = "#", icon("circle", class = "text-success"), "Online"),
#'     # Image file should be in www/ subdir
#'     image = "userimage.png"
#'   ),
#'   sidebarSearchForm(label = "Enter a number", "searchText", "searchButton"),
#'   sidebarMenu(
#'     # Setting id makes input$tabs give the tabName of currently-selected tab
#'     id = "tabs",
#'     menuItem("Dashboard", tabName = "dashboard", icon = icon("dashboard")),
#'     menuItem("Widgets", icon = icon("th"), tabName = "widgets", badgeLabel = "new",
#'              badgeColor = "green"),
#'     menuItem("Charts", icon = icon("bar-chart-o"),
#'       menuSubItem("Sub-item 1", tabName = "subitem1"),
#'       menuSubItem("Sub-item 2", tabName = "subitem2")
#'     )
#'   )
#' )
#'
#' body <- dashboardBody(
#'   tabItems(
#'     tabItem("dashboard",
#'       div(p("Dashboard tab content"))
#'     ),
#'     tabItem("widgets",
#'       "Widgets tab content"
#'     ),
#'     tabItem("subitem1",
#'       "Sub-item 1 tab content"
#'     ),
#'     tabItem("subitem2",
#'       "Sub-item 2 tab content"
#'     )
#'   )
#' )
#'
#' shinyApp(
#'   ui = dashboardPage(header, sidebar, body),
#'   server = function(input, output) { }
#' )
#' }
#' @export
dashboardSidebar <- function(..., disable = FALSE, width = NULL, collapsed = FALSE) {
  width <- validateCssUnit(width)

  # Set up custom CSS for custom width
  custom_css <- NULL
  if (!is.null(width)) {
    # This CSS is derived from the sidebar-related instances of '230px' (the
    # default sidebar width) from inst/AdminLTE/AdminLTE.css. One difference is
    # that instead making changes to the global settings, we've put them in a
    # media query (min-width: 768px), so that it won't override other media
    # queries (like max-width: 767px) that work for narrower screens.
    custom_css <- tags$head(tags$style(HTML(gsub("_WIDTH_", width, fixed = TRUE, '
      .main-sidebar, .left-side {
        width: _WIDTH_;
      }
      @media (min-width: 768px) {
        .content-wrapper,
        .right-side,
        .main-footer {
          margin-left: _WIDTH_;
        }
        .main-sidebar,
        .left-side {
          width: _WIDTH_;
        }
      }
      @media (max-width: 767px) {
        .sidebar-open .content-wrapper,
        .sidebar-open .right-side,
        .sidebar-open .main-footer {
          -webkit-transform: translate(_WIDTH_, 0);
          -ms-transform: translate(_WIDTH_, 0);
          -o-transform: translate(_WIDTH_, 0);
          transform: translate(_WIDTH_, 0);
        }
      }
      @media (max-width: 767px) {
        .main-sidebar,
        .left-side {
          -webkit-transform: translate(-_WIDTH_, 0);
          -ms-transform: translate(-_WIDTH_, 0);
          -o-transform: translate(-_WIDTH_, 0);
          transform: translate(-_WIDTH_, 0);
        }
      }
      @media (min-width: 768px) {
        .sidebar-collapse .main-sidebar,
        .sidebar-collapse .left-side {
          -webkit-transform: translate(-_WIDTH_, 0);
          -ms-transform: translate(-_WIDTH_, 0);
          -o-transform: translate(-_WIDTH_, 0);
          transform: translate(-_WIDTH_, 0);
        }
      }
    '))))
  }

  # If we're restoring a bookmarked app, this holds the value of whether or not the
  # sidebar was collapsed. If this is not the case, the default is whatever the user
  # specified in the `collapsed` argument.
  dataValue <- shiny::restoreInput(id = "sidebarCollapsed", default = collapsed)
  if (disable) dataValue <- TRUE # this is a workaround to fix #209
  dataValueString <- if (dataValue) "true" else "false"

  # The expanded/collapsed state of the sidebar is actually set by adding a
  # class to the body (not to the sidebar). However, it makes sense for the
  # `collapsed` argument to belong in this function. So this information is
  # just passed through (as the `data-collapsed` attribute) to the
  # `dashboardPage()` function
  tags$aside(
    id = "sidebarCollapsed",
    class = "main-sidebar", `data-collapsed` = dataValueString, custom_css,
    tags$section(
      id = "sidebarItemExpanded",
      class = "sidebar",
      `data-disable` = if (disable) 1 else NULL,
      list(...)
    )
  )
}

#' A panel displaying user information in a sidebar
#'
#' @param name Name of the user.
#' @param subtitle Text or HTML to be shown below the name.
#' @param image A filename or URL to use for an image of the person. If it is a
#'   local file, the image should be contained under the www/ subdirectory of
#'   the application.
#'
#' @family sidebar items
#'
#' @seealso \code{\link{dashboardSidebar}} for example usage.
#'
#' @export
sidebarUserPanel <- function(name, subtitle = NULL, image = NULL) {
  div(class = "user-panel",
    if (!is.null(image)) {
      div(class = "pull-left image",
        img(src = image, class = "img-circle", alt = "User Image")
      )
    },
    div(class = "pull-left info",
      # If no image, move text to the left: by overriding default left:55px
      style = if (is.null(image)) "left: 4px",
      p(name),
      subtitle
    )
  )
}

#' Create a search form to place in a sidebar
#'
#' A search form consists of a text input field and a search button.
#'
#' @param textId Shiny input ID for the text input box.
#' @param buttonId Shiny input ID for the search button (which functions like an
#'   \code{\link[shiny]{actionButton}}).
#' @param label Text label to display inside the search box.
#' @param icon An icon tag, created by \code{\link[shiny]{icon}}.
#'
#' @family sidebar items
#'
#' @seealso \code{\link{dashboardSidebar}} for example usage.
#'
#' @export
sidebarSearchForm <- function(textId, buttonId, label = "Search...",
                              icon = shiny::icon("search")) {
  tags$form(class = "sidebar-form",
    div(class = "input-group",
      tags$input(id = textId, type = "text", class = "form-control",
        placeholder = label, style = "margin: 5px;"
      ),
      span(class = "input-group-btn",
        tags$button(id = buttonId, type = "button",
          class = "btn btn-flat action-button",
          icon
        )
      )
    )
  )
}

#' Create a dashboard sidebar menu and menu items.
#'
#' A \code{dashboardSidebar} can contain a \code{sidebarMenu}. A
#' \code{sidebarMenu} contains \code{menuItem}s, and they can in turn contain
#' \code{menuSubItem}s.
#'
#' Menu items (and similarly, sub-items) should have a value for either
#' \code{href} or \code{tabName}; otherwise the item would do nothing. If it has
#' a value for \code{href}, then the item will simply be a link to that value.
#'
#' If a \code{menuItem} has a non-NULL \code{tabName}, then the \code{menuItem}
#' will behave like a tab -- in other words, clicking on the \code{menuItem}
#' will bring a corresponding \code{tabItem} to the front, similar to a
#' \code{\link[shiny]{tabPanel}}. One important difference between a
#' \code{menuItem} and a \code{tabPanel} is that, for a \code{menuItem}, you
#' must also supply a corresponding \code{tabItem} with the same value for
#' \code{tabName}, whereas for a \code{tabPanel}, no \code{tabName} is needed.
#' (This is because the structure of a \code{tabPanel} is such that the tab name
#' can be automatically generated.) Sub-items are also able to activate
#' \code{tabItem}s.
#'
#' Menu items (but not sub-items) also may have an optional badge. A badge is a
#' colored oval containing text.
#'
#' @param text Text to show for the menu item.
#' @param id For \code{sidebarMenu}, if \code{id} is present, this id will be
#'   used for a Shiny input value, and it will report which tab is selected. For
#'   example, if \code{id="tabs"}, then \code{input$tabs} will be the
#'   \code{tabName} of the currently-selected tab. If you want to be able to
#'   bookmark and restore the selected tab, an \code{id} is required.
#' @param icon An icon tag, created by \code{\link[shiny]{icon}}. If
#'   \code{NULL}, don't display an icon.
#' @param badgeLabel A label for an optional badge. Usually a number or a short
#'   word like "new".
#' @param badgeColor A color for the badge. Valid colors are listed in
#'   \link{validColors}.
#' @param href An link address. Not compatible with \code{tabName}.
#' @param tabName The name of a tab that this menu item will activate. Not
#'   compatible with \code{href}.
#' @param newtab If \code{href} is supplied, should the link open in a new
#'   browser tab?
#' @param selected If \code{TRUE}, this \code{menuItem} or \code{menuSubItem}
#'   will start selected. If no item have \code{selected=TRUE}, then the first
#'   \code{menuItem} will start selected.
#' @param expandedName A unique name given to each \code{menuItem} that serves
#'   to indicate which one (if any) is currently expanded. (This is only applicable
#'   to \code{menuItem}s that have children and it is mostly only useful for
#'   bookmarking state.)
#' @param startExpanded Should this \code{menuItem} be expanded on app startup?
#'   (This is only applicable to \code{menuItem}s that have children, and only
#'   one of these can be expanded at any given time).
#' @param ... For menu items, this may consist of \code{\link{menuSubItem}}s.
#' @param .list An optional list containing items to put in the menu Same as the
#'   \code{...} arguments, but in list format. This can be useful when working
#'   with programmatically generated items.
#'
#' @family sidebar items
#'
#' @seealso \code{\link{dashboardSidebar}} for example usage. For
#'   dynamically-generated sidebar menus, see \code{\link{renderMenu}} and
#'   \code{\link{sidebarMenuOutput}}.
#'
#' @export
sidebarMenu <- function(..., id = NULL, .list = NULL) {
  items <- c(list(...), .list)

  # Restore a selected tab from bookmarked state. Bookmarking was added in Shiny
  # 0.14.
  if (utils::packageVersion("shiny") >= "0.14" && !is.null(id)) {
    selectedTabName <- shiny::restoreInput(id = id, default = NULL)
    if (!is.null(selectedTabName)) {
      # Find the menuItem or menuSubItem with a `tabname` that matches
      # `selectedTab`. Then set `data-start-selected` to 1 for that tab and 0
      # for all others.

      # Given a menuItem and a logical value for `selected`, set the
      # data-start-selected attribute to the appropriate value (1 or 0).
      selectItem <- function(item, selected) {

        # in the cases that the children of menuItems are NOT menuSubItems
        if (is.atomic(item) || length(item$children) == 0) {
          return(item)
        }

        if (selected) value <- 1
        else          value <- NULL

        # Try to find the child <a data-toggle="tab"> tag and then set
        # data-start-selected="1". The []<- assignment is to preserve
        # attributes.
        item$children[] <- lapply(item$children, function(child) {

          # Find the appropriate <a> child
          if (tagMatches(child, name = "a", `data-toggle` = "tab")) {
            child$attribs[["data-start-selected"]] <- value
          }

          child
        })

        item
      }

      # Given a menuItem and a tabName (string), return TRUE if the menuItem has
      # that tabName, FALSE otherwise.
      itemHasTabName <- function(item, tabName) {
        # Must be a <li> tag
        if (!tagMatches(item, name = "li")) {
          return(FALSE)
        }

        # Look for an <a> child with data-value=tabName
        found <- FALSE
        lapply(item$children, function(child) {
          if (tagMatches(child, name = "a", `data-value` = tabName)) {
            found <<- TRUE
          }
        })

        found
      }

      # Actually do the work of marking selected tabs and unselected ones.
      items <- lapply(items, function(item) {
        if (tagMatches(item, name = "li", class = "treeview")) {
          # Search in menuSubItems
          item$children[] <- lapply(item$children[], function(subItem) {

            if (tagMatches(subItem, name = "ul", class = "treeview-menu")) {
              subItem$children[] <- lapply(subItem$children, function(subSubItem) {
                selected <- itemHasTabName(subSubItem, selectedTabName)
                selectItem(subSubItem, selected)
              })
            }
            subItem
          })

        } else {
          # Regular menuItems
          selected <- itemHasTabName(item, selectedTabName)
          item <- selectItem(item, selected)
        }

        item
      })
    }
    # This is a 0 height div, whose only purpose is to hold the tabName of the currently
    # selected menuItem in its `data-value` attribute. This is the DOM element that is
    # bound to tabItemInputBinding in the JS side.
    items[[length(items) + 1]] <- div(id = id,
      class = "sidebarMenuSelectedTabItem", `data-value` = selectedTabName %OR% "null")
  }

  # Use do.call so that we don't add an extra list layer to the children of the
  # ul tag. This makes it a little easier to traverse the tree to search for
  # selected items to restore.
  do.call(tags$ul, c(class = "sidebar-menu", items))
}

#' @rdname sidebarMenu
#' @export
menuItem <- function(text, ..., icon = NULL, badgeLabel = NULL, badgeColor = "green",
                     tabName = NULL, href = NULL, newtab = TRUE, selected = NULL,
                     expandedName = as.character(gsub("[[:space:]]", "", text)),
                     startExpanded = FALSE) {
  subItems <- list(...)

  if (!is.null(icon)) tagAssert(icon, type = "i")
  if (!is.null(href) + !is.null(tabName) + (length(subItems) > 0) != 1 ) {
    stop("Must have either href, tabName, or sub-items (contained in ...).")
  }

  if (!is.null(badgeLabel) && length(subItems) != 0) {
    stop("Can't have both badge and subItems")
  }
  validateColor(badgeColor)

  # If there's a tabName, set up the correct href and <a> target
  isTabItem <- FALSE
  target <- NULL
  if (!is.null(tabName)) {
    validateTabName(tabName)
    isTabItem <- TRUE
    href <- paste0("#shiny-tab-", tabName)
  } else if (is.null(href)) {
    href <- "#"
  } else {
    # If supplied href, set up <a> tag's target
    if (newtab)
      target <- "_blank"
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
  if (length(subItems) == 0) {
    return(
      tags$li(
        a(href = href,
          `data-toggle` = if (isTabItem) "tab",
          `data-value` = if (!is.null(tabName)) tabName,
          `data-start-selected` = if (isTRUE(selected)) 1 else NULL,
          target = target,
          icon,
          span(text),
          badgeTag
        )
      )
    )
  }

  # If we're restoring a bookmarked app, this holds the value of what menuItem (if any)
  # was expanded (this has be to stored separately from the selected menuItem, since
  # these actually independent in AdminLTE). If no menuItem was expanded, `dataExpanded`
  # is NULL. However, we want to this input to get passed on (and not dropped), so we
  # do `%OR% ""` to assure this.
  default <- if (startExpanded) expandedName else ""
  dataExpanded <- shiny::restoreInput(id = "sidebarItemExpanded", default) %OR% ""

  # If `dataExpanded` is not the empty string, we need to check that it is eqaul to the
  # this menuItem's `expandedName``
  isExpanded <- nzchar(dataExpanded) && (dataExpanded == expandedName)

  tags$li(class = "treeview",
    a(href = href,
      icon,
      span(text),
      shiny::icon("angle-left", class = "pull-right")
    ),
    # Use do.call so that we don't add an extra list layer to the children of the
    # ul tag. This makes it a little easier to traverse the tree to search for
    # selected items to restore.
    do.call(tags$ul, c(
      class = paste0("treeview-menu", if (isExpanded) " menu-open" else ""),
      style = paste0("display: ",     if (isExpanded) "block;" else "none;"),
      `data-expanded` = expandedName,
      subItems))
  )
}

#' @rdname sidebarMenu
#' @export
menuSubItem <- function(text, tabName = NULL, href = NULL, newtab = TRUE,
  icon = shiny::icon("angle-double-right"), selected = NULL)
{

  if (!is.null(href) && !is.null(tabName)) {
    stop("Can't specify both href and tabName")
  }

  # If there's a tabName, set up the correct href
  isTabItem <- FALSE
  target <- NULL
  if (!is.null(tabName)) {
    validateTabName(tabName)
    isTabItem <- TRUE
    href <- paste0("#shiny-tab-", tabName)
  } else if (is.null(href)) {
    href <- "#"
  } else {
    # If supplied href, set up <a> tag's target
    if (newtab)
      target <- "_blank"
  }


  tags$li(
    a(href = href,
      `data-toggle` = if (isTabItem) "tab",
      `data-value` = if (!is.null(tabName)) tabName,
      `data-start-selected` = if (isTRUE(selected)) 1 else NULL,
      target = target,
      icon,
      text
    )
  )
}
