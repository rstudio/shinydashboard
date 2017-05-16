This branch of AdminLTE contains the following changes from the stock version, to make it work better with Shiny.

* The box collapse function triggers 'shown' and 'hidden' events, so that Shiny knows when outputs are visible or not. See https://github.com/rstudio/shinydashboard/issues/42 for a test app (must re-apply commit 73f6027 when updating to newer version of Admin LTE).

* In AdminLTE.css, the fonts are fetched from the local host, instead of from Google fonts (must re-apply commits e9e63d1 and 9ccb12d when updating to newer version of Admin LTE).

* Add the following code chunk to app.js (see commit c3a0c59):

```js
var shinyOutput = checkElement.find('.shiny-bound-output');
if (shinyOutput.length !== 0 && shinyOutput.first().html().length === 0) {
  shinyOutput.first().html('<br/>');
}
```

This is inserted in the event listener for clicks on the sidebar menu items (right before app.js does a `slideDown()` on the clicked menuItem). The point is to enter a blank line (if there is no other content) inside the outputs, so the `slideDown()` animation looks reasonable.
