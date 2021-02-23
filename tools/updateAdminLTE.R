library(sass)
library(brio)

target <- rprojroot::find_package_root_file("inst/AdminLTE")

download_gh_release <- function(repo, version) {
  src_zip <- paste0("https://github.com/", repo, "/archive/v", version, ".zip")
  tmp_zip <- tempfile(fileext = ".zip")
  download.file(src_zip, tmp_zip)
  tmp_dir <- tempfile()
  dir.create(tmp_dir)
  unzip(tmp_zip, exdir = tmp_dir)
  file.path(tmp_dir, paste0(basename(repo), "-", version))
}

# This port of AdminLTE's less to sass implicitly assumes AdminLTE 2.4.10
src <- download_gh_release("onkbear/admin-lte-2-sass", "0.0.2")

# Remove old scss source files
target_scss <- file.path(target, "scss")
unlink(target_scss, recursive = TRUE)
dir.create(target_scss)

# Copy over to package, then patch the entrypoint to make it so scss can be
# compiled "standalone" (i.e., just with BS3 headers as we do below)
file.copy(
  dir(file.path(src, "assets/scss"), recursive = TRUE, full.names = TRUE),
  target_scss
)
f <- file.path(target_scss, "AdminLTE.scss")
adminlte <- read_lines(f)
adminlte[[grep("bootstrap-sass", adminlte)]] <- ".clearfix { @include clearfix; }"
write_lines(adminlte, f)

# Pre-compile with BS3 headers
withr::with_dir(target_scss, {
  sass_partial(
    sass_file("AdminLTE.scss"),
    bundle = bslib::bs_theme(version = 3),
    output = "../AdminLTE.css",
    cache = NULL, write_attachments = FALSE
  )
})

# Now grab the corresponding JavaScript
src <- download_gh_release("ColorlibHQ/AdminLTE", "2.4.10")
file.copy(
  file.path(src, "dist/js/adminlte.js"),
  rprojroot::find_package_root_file("srcjs/AdminLTE/app.js"),
  overwrite = TRUE
)
