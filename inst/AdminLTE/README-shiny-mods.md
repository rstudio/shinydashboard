This branch of AdminLTE contains the following changes from the stock version, to make it work better with Shiny.

* The box collapse function triggers 'shown' and 'hidden' events, so that Shiny knows when outputs are visible or not. See https://github.com/rstudio/shinydashboard/issues/42 for a test app.
* In AdminLTE.css, the fonts are fetched from the local host, instead of from Google fonts.
