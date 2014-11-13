#!/usr/bin/env Rscript

# This script downloads the appropriate CSS resource files and writes out R
# files in the R/ subdir, which list the valid CSS icons.

library(htmltools)
library(shiny)
library(shinydashboard)

# Returns the file currently being sourced or run with Rscript
thisFile <- function() {
  cmdArgs <- commandArgs(trailingOnly = FALSE)
  needle <- "--file="
  match <- grep(needle, cmdArgs)
  if (length(match) > 0) {
    # Rscript
    return(normalizePath(sub(needle, "", cmdArgs[match])))
  } else {
    # 'source'd via R console
    return(normalizePath(sys.frames()[[1]]$ofile))
  }
}

# @param depname The name of a dependency.
# @param regex An optional regex for filtering icon names.
findValidIcons <- function(depname, regex = NULL) {
  # Get all the dependencies from a dashboardPage
  allDeps <-findDependencies(
    dashboardPage(
      dashboardHeader(),
      dashboardSidebar(),
      dashboardBody(icon("bar-chart-o"))
    )
  )

  # Grab the specified html dependency
  dep <- Filter(function(dep) dep$name == depname, allDeps)[[1]]
  if (!is.null(dep$src$file)) {
    # We have a local copy of the file
    cssfile <- file.path(dep$src$file, dep$stylesheet)
  } else {
    # Use href instead of file.
    if (grepl("^https?", dep$src$href)){
      # This is an absolute URL. Need to download remote file.
      url <- paste0(dep$src$href, dep$stylesheet)
      cssfile <- tempfile(pattern = depname, fileext = ".css")
      download.file(url, cssfile)
    } else {
      # href is a relative path. We probably have to get this from
      # the shiny www/ directory.
      cssfile <- file.path(
        system.file("www", package="shiny"),
        dep$src$href, dep$stylesheet
      )
    }
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
  icons <- sub("^\\.(.*):before$", "\\1", icons)

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

  destfile <- normalizePath(mustWork = FALSE, file.path(
    dirname(thisFile()),
    "../R",
    paste0("valid-icons-", abbrev, ".R")
  ))
  cat("Writing file", destfile)

  writeLines(cmd, destfile)
}

writeValidIconsFile("glyphicon", "bootstrap", "^glyphicon-")
writeValidIconsFile("fa", "font-awesome", "fa-")
