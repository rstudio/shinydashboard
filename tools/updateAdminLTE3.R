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

src <- download_gh_release("ColorlibHQ/AdminLTE", "3.0.5")
target <- find_package_root_file("inst", basename(src))
unlink(target, recursive = TRUE)
dir.create(target)
file.copy(
  file.path(src, "dist", "js", "adminlte.js"),
  file.path(target, "adminlte.js")
)

scss_home <- file.path(target, "scss")
dir.create(scss_home)
file.rename(file.path(src, "build", "scss"), scss_home)

# No need for the different builds of AdminLTE
# TODO: how will different skins work?
file.remove(
  dir(scss_home, pattern = "AdminLTE-.*\\.scss$", full.names = TRUE)
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

withr::with_dir(
  "inst/AdminLTE-3.0.5/scss/",
  sass_partial(
    sass_file("AdminLTE.scss"),
    bslib::bs_theme(),
    output = "../adminlte.css",
    cache = NULL,
    write_attachments = FALSE
  )
)

