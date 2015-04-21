This branch of AdminLTE contains the following changes from the stock version, to make it work better with Shiny.

* Attached collapse click event handler to document, instead of to each collapse button. This is the same fix as https://github.com/almasaeed2010/AdminLTE/pull/304; if that is merged, then it should be possible to go to the stock version.
* In AdminLTE.css, the fonts are fetched from the local host, instead of from Google fonts.