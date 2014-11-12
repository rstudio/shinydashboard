#!/usr/bin/env Rscript

# This script downloads the appropriate CSS resource files and writes out R
# files in the R/ subdir, which list the valid CSS icons.
# It should be run from the top level of the package directory (shinydashboard/)

# @param depname The name of a dependency.
# @param regex An optional regex for filtering icon names.
findValidIcons <- function(depname, regex = NULL) {
  # Get all the dependencies from a dashboardPage
  allDeps <-findDependencies(
    dashboardPage(dashboardHeader(), dashboardSidebar(), dashboardBody())
  )

  # Grab the specified html dependency
  dep <- Filter(function(dep) dep$name == depname, allDeps)[[1]]
  if (!is.null(dep$src$file)) {
    # We have a local copy of the file
    cssfile <- file.path(dep$src$file, dep$stylesheet)
  } else {
    # Need to download remote file
    url <- paste0(dep$src$href, dep$stylesheet)
    # Download CSS file
    cssfile <- tempfile(pattern = depname, fileext = ".css")
    download.file(url, cssfile)
  }

  # Parse contents
  contents <- readChar(cssfile, nchars = 1e7)
  contents <- gsub("/\\*.*?\\*/", "", contents)
  contents <- strsplit(contents, "}", fixed = TRUE)[[1]]
  lines <- paste0(contents, "}")

  # Keep only lines with '{content:".*"}'
  lines <- lines[grepl('\\{content:".*"\\}', lines)]
  # Remove the stuff in curly braces
  lines <- sub("(.*)\\{.*$", "\\1", lines)
  icons <- unlist(strsplit(lines, ",", fixed = TRUE))
  icons <- sub("^\\.(.*):before$", "\\1", lines)

  # Apply optional filter
  if (!is.null(regex)) {
    icons <- icons[grepl(regex, icons)]
  }
  icons
}

writeValidIconsFile <- function(abbrev, depname, regex = NULL) {
  icons <- findValidIcons(depname, regex)

  # Write an R file that puts all the valid names into a variable
  cmd <- paste(capture.output(dput(icons)), collapse = "\n")
  cmd <- paste0("validIcons[['", abbrev, "']] <- ", cmd)
  writeLines(cmd, paste0("R/valid-", abbrev, ".R"))
}

writeValidIconsFile("glyphicon", "bootstrap", "^glyphicon-")
writeValidIconsFile("fa", "font-awesome", "fa-")
writeValidIconsFile("ion", "ionicons", "^ion-")
