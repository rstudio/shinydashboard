# Add an html dependency, without overwriting existing ones
addDependencies <- function(x, value) {
  if (inherits(value, "html_dependency"))
    value <- list(value)

  old <- attr(x, "html_dependencies", TRUE)

  htmlDependencies(x) <- c(old, value)
  x
}


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

# Given the name of an icon, like "fa-dashboard", "glyphicon-user", or
# "ion-checkmark", return CSS classnames, like "fa fa-dashboard" or
# "glyphicon glyphicon-user".
getIconClass <- function(icon) {
  iconGroup <- sub("^((glyphicon)|(fa)|(ion))-.*", "\\1", icon)
  paste(iconGroup, icon)
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
