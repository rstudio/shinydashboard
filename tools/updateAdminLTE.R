library(sass)
library(rprojroot)

download_gh_release <- function(repo, version) {
  src_zip <- paste0("https://github.com/", repo, "/archive/v", version, ".zip")
  tmp_zip <- tempfile(fileext = ".zip")
  download.file(src_zip, tmp_zip)
  tmp_dir <- tempfile()
  dir.create(tmp_dir)
  unzip(tmp_zip, exdir = tmp_dir)
  file.path(tmp_dir, paste0(basename(repo), "-", version))
}

src <- download_gh_release("ColorlibHQ/AdminLTE", "2.3.11")
target <- find_package_root_file("inst/AdminLTE")

# Remove old scss source files
target_scss <- file.path(target, "scss")
unlink(target_scss, recursive = TRUE)
dir.create(target_scss)

# Grab less src files and convert to sass via node
# npm install -g less2sass
build <- file.path(src, "build", "less")
less <- dir(build, full.names = TRUE, recursive = TRUE)
invisible(lapply(less, function(file) {
  system(paste("less2sass", file))
}))
scss <- dir(build, pattern = "\\.scss$", full.names = TRUE)
# Don't need this source file
scss <- scss[basename(scss) != "AdminLTE-without-plugins.scss"]

# All the imports outside of AdminLTE.scss aren't needed
# (we include bootstrap headers via sass_partial())
remove_imports <- function(f) {
  txt <- brio::read_lines(f)
  txt <- txt[!grepl("^@import", txt)]
  invisible(brio::write_lines(txt, f))
}
invisible(lapply(
  scss[basename(scss) != "AdminLTE.scss"],
  remove_imports
))

# Copy scss source over to the package
file.copy(scss, target_scss)

file.copy(
  file.path(src, "dist", "js", "app.js"),
  find_package_root_file("srcjs/AdminLTE/app.js"),
  overwrite = TRUE
)

# Apply any patches to source files
patch_files <- list.files(
  find_package_root_file("tools/patches"),
  full.names = TRUE
)

for (patch in patch_files) {
  tryCatch(
    {
      message(sprintf("Applying %s", basename(patch)))
      rej_pre <- dir(pattern = "\\.rej$", recursive = TRUE)
      system(sprintf("git apply --reject --whitespace=fix '%s'", patch))
      rej_post <- dir(pattern = "\\.rej$", recursive = TRUE)
      if (length(rej_post) > length(rej_pre)) {
        stop(
          "Running `git apply --reject` generated `.rej` files.\n",
          "Please fix the relevant conflicts inside ", patch, "\n",
          "An 'easy' way to do this is to first `git add` the new source changes, ",
          "then manually make the relevant changes from the patch file,",
          "then `git diff` to get the relevant diff output and update the patch diff with the new diff."
        )
      }
    },
    error = function(e) {
      stop(conditionMessage(e))
      quit(save = "no", status = 1)
    }
  )
}

# Pre-compile with Bootstrap 3 headers
withr::with_dir(target_scss, {
  sass_partial(
    sass_file("AdminLTE.scss"),
    bundle = bslib::bs_theme(version = 3),
    output = "../AdminLTE.css",
    cache = NULL
  )
})
