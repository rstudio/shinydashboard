#' @param tag A tag object.
#' @param type The type of a tag, like "div", "a", "span".
#' @param class An HTML class.
#' @keywords internal
tagAssert <- function(tag, type = NULL, class = NULL) {
  if (!inherits(tag, "shiny.tag")) {
    stop("Expected an object with class 'shiny.tag'.")
  }

  if (!missing(type) && tag$name != type) {
    stop("Expected tag to be of type ", name)
  }

  if (!missing(class)) {
    if (is.null(tag$attribs$class)) {
      stop("Expected tag to have class '", class, "'")

    } else {
      tagClasses <- strsplit(tag$attribs$class, " ")[[1]]
      if (!(class %in% tagClasses)) {
        stop("Expected tag to have class '", class, "'")
      }
    }
  }
}

# Given the name of an icon, like "fa-dashboard" or "glyphicon-user",
# return CSS classnames, like "fa fa-dashboard" or "glyphicon glyphicon-user".
getIconClass <- function(icon) {
  iconGroup <- sub("^((glyphicon)|(fa))-.*", "\\1", icon)
  paste(iconGroup, icon)
}

# Validate an icon name
validateIcon <- function(icon) {
  res <- vapply(validIcons, function(x) icon %in% x, logical(1))

  if (!any(res)) {
    stop("Icon named ", icon, " not found in list of valid icons.\n",
         "Run `shinydashboard:::validIcons` for a full list of valid icons.\n",
         "Icons are also listed at:\n",
         "  http://fortawesome.github.io/Font-Awesome/icons/\n",
         "  http://ionicons.com/\n",
         "  http://getbootstrap.com/components/#glyphicons\n"
    )
  }
}


# Returns TRUE if a color is a valid color defined in AdminLTE, throws error
# otherwise.
validateColor <- function(color) {
  validColors <- c("red", "yellow", "aqua", "blue", "light-blue", "green",
                   "navy", "teal", "olive", "lime", "orange", "fuchsia",
                   "purple", "maroon", "black")

  if (color %in% validColors) {
    return(TRUE)
  }

  stop("Invalid color: ", color, ". Valid colors are: ",
       paste(validColors, collapse = ", "), ".")
}

# Returns TRUE if a status is valid; throws error otherwise.
validateStatus <- function(status) {
  validStatuses <- c("success", "info", "warning", "danger")

  if (status %in% validStatuses) {
    return(TRUE)
  }

  stop("Invalid status: ", status, ". Valid statuses are: ",
       paste(validStatuses, collapse = ", "), ".")
}
