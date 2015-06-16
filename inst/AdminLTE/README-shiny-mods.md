This branch of AdminLTE contains the following changes from the stock version, to make it work better with Shiny.

* Attached collapse click event handler to document, instead of to each collapse button. This is the same fix as https://github.com/almasaeed2010/AdminLTE/pull/304; if that is merged, then it should be possible to go to the stock version. Also see https://github.com/rstudio/shinydashboard/issues/17 for a test app.
* The box collapse function triggers 'shown' and 'hidden' events, so that Shiny knows when outputs are visible or not. See https://github.com/rstudio/shinydashboard/issues/42 for a test app.
* For treeviews (that is sidebar menu itmes with sub-items), the click event handler is attached to the menu DOM object instead of the individual items. See https://github.com/rstudio/shinydashboard/issues/54 for a test app.
* In AdminLTE.css, the fonts are fetched from the local host, instead of from Google fonts.