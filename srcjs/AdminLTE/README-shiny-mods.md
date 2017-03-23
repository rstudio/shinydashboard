This branch of AdminLTE contains the following changes from the stock version, to make it work better with Shiny.

* The box collapse function triggers 'shown' and 'hidden' events, so that Shiny knows when outputs are visible or not. See https://github.com/rstudio/shinydashboard/issues/42 for a test app (must re-apply commit 73f6027 when updating to newer version of Admin LTE).

* In AdminLTE.css, the fonts are fetched from the local host, instead of from Google fonts (must re-apply commits e9e63d1 and 9ccb12d when updating to newer version of Admin LTE).
