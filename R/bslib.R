tagFunctionVersion <- function(three = default, four = default, default, args = list()) {
  stopifnot(is.function(four))
  stopifnot(is.function(three))
  stopifnot(is.function(default))
  stopifnot(is.list(args))

  tagFunction(function() {
    switch(
      theme_version(get_current_theme()),
      "4" = do.call(four, args),
      "3" = do.call(three, args),
      do.call(default, args)
    )
  })
}


is_bs_theme <- function(x) {
  if (!"bslib" %in% loadedNamespaces()) return(FALSE)
  bslib::is_bs_theme(x)
}

theme_version <- function(x) {
  if (is_bs_theme(x)) {
    bslib::theme_version(x)
  } else {
    "3"
  }
}

get_current_theme <- function() {
  get_theme <- asNamespace("shiny")$getCurrentTheme
  if (is.function(get_theme)) get_theme() else NULL
}
