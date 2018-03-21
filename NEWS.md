shinydashboard 0.7.0
====================

## Full changelog

### New features

* Changed license from GPL-2 to GPL>=2 (meaning GPL version 2 or later). ([#258](https://github.com/rstudio/shinydashboard/issues/258))

### Bug fixes

* Fixed [shinytest/#167](https://github.com/rstudio/shinytest/issues/167): shinydashboard did not work properly with shinytest. (#256](https://github.com/rstudio/shinydashboard/pull/256))

* Fixed [#257](https://github.com/rstudio/shinydashboard/issues/257): Calling the `setValue()` method on `sidebarmenuExpandedInputBinding` did not cause the submenu to expand. This caused screenshots from shinytest to be incorrect.

* Fixed [#235](https://github.com/rstudio/shinydashboard/issues/235): make sure that the text input field and search button line up when using `sidebarSearchForm`. ([#243](https://github.com/rstudio/shinydashboard/pull/243))

* Fixed [#229](https://github.com/rstudio/shinydashboard/issues/229): only run `ensureActivatedTab()` after `renderMenu()` is called *_if_* the `el` in question has class `"sidebar-menu"`. Since this function is used for both `dropdownMenuOutput` and `sidebarMenuOutput`, we have to make sure that `ensureActivatedTab()` is only called if it's the latter case (otherwise, you get unexpected tab redirections when updating a dropdown menu). ([#233](https://github.com/rstudio/shinydashboard/pull/233))

shinydashboard 0.6.1
====================

This is a hotfix release of shinydashboard, meant to fix a few edge cases that have surfaced since the last release.

## Full changelog

* Fixed [#214](https://github.com/rstudio/shinydashboard/issues/214): make sure that the `data-value` attribute of `.sidebarMenuSelectedTabItem` is always set in the body of the `ensureActivatedTab()` function. ([#216](https://github.com/rstudio/shinydashboard/pull/216))

* Fixed [#217](https://github.com/rstudio/shinydashboard/issues/217): correct `input$sidebarCollapsed` value for edge cases by attaching the change event to the end of the sidebar CSS transitions (instead of when the toggle button is clicked). Also make sure that `input$sidebarCollapsed` is set to `FALSE` when the app starts up with the sidebar already collapsed. ([#222](https://github.com/rstudio/shinydashboard/pull/222))

shinydashboard 0.6.0
====================

This release of shinydashboard was aimed at both fixing bugs and also bringing the package up to speed with users' requests and Shiny itself (especially fully bringing [bookmarkable state](https://shiny.rstudio.com/articles/bookmarking-state.html) to shinydashboard's sidebar). In addition to the changes listed below, we also added a [new "Behavior" section to the shinydashboard website](https://rstudio.github.io/shinydashboard/behavior.html) to explain this release's two biggest new features.

## Full changelog

### New features

* Address [#179](https://github.com/rstudio/shinydashboard/issues/179) support for bookmarking the expanded/collapsed state of the whole sidebar. (commit [e71c93f](https://github.com/rstudio/shinydashboard/commit/e71c93fa7a71f229e725efd4a7867e431cd57679))

* Added Shiny input to keep track of which sidebar `menuItem` is expanded (if any), which makes bookmarking the exact state of the sidebar trivial. (commit [6901b90](https://github.com/rstudio/shinydashboard/commit/6901b90b8c866b89d02514cfc01fdfab88175602))

### Minor new features and improvements

* Addressed [#165](https://github.com/rstudio/shinydashboard/issues/165): added a new optional argument, called `headerText` to the `dropdownMenu()` function. If provided by the user, this text (instead of the default) will be shown on the header of the menu (only visible when the menu is expanded). See `?dropdownMenu` for more details. [#207](https://github.com/rstudio/shinydashboard/pull/207)

* Split JS files. (commit [ea91503](https://github.com/rstudio/shinydashboard/commit/ea915038ae2126f48c15e3aac41782a22b16c506)). More updates to Gruntfile and structure. (commit [4e80616](https://github.com/rstudio/shinydashboard/commit/4e80616c5b3aa0dc73022dc815288b5ba7c35be0))

* Better shown/hidden mechanic for Shiny inputs inside collapsible `menuItem`s. (commit [6901b90](https://github.com/rstudio/shinydashboard/commit/6901b90b8c866b89d02514cfc01fdfab88175602))

* Added hack on adminLTE/app.js in order to make the `slideUp`/`slideDown` css transitions look reasonable when its content is initially empty (use case is for hidden Shiny outputs that are not rendered until the first time the `menuItem` is expanded and reveal them -- i.e. first time that `trigger("shown")` is called). (commit [25725a6](https://github.com/rstudio/shinydashboard/commit/25725a67ce3dd841786dd82b0e46624c6a7d4722))

* Added manual tests for bookmarking and the shown/hidden events that happen on the sidebar. (commit [9e3e55d](https://github.com/rstudio/shinydashboard/commit/9e3e55de8cc63d4bdd179251cd53eeb845441d3d))

### Bug fixes

* Fixed [#71](https://github.com/rstudio/shinydashboard/issues/71) and [#87](https://github.com/rstudio/shinydashboard/issues/87): detect and enforce selected tab for dynamic sidebar menus by calling `ensureActivatedTab()` for these. (commit [9b88a79](https://github.com/rstudio/shinydashboard/commit/9b88a790df058432165ca3b483b5bbfe1d267326))

* Fixed [#127](https://github.com/rstudio/shinydashboard/issues/127) and [#177](https://github.com/rstudio/shinydashboard/issues/177): previously, if `dashboardSidebar()` was called with an explicit `width` parameter, mobile rendering would look weird (the sidebar wouldn't completely disappear when it was collapsed, and content in the dashboard body would be hidden under the still-visible sidebar). ([#204](https://github.com/rstudio/shinydashboard/pull/204))

* Fixed [#79](https://github.com/rstudio/shinydashboard/issues/79): Re-enable slight css transition when the sidebar is expanded/collapsed. ([#205](https://github.com/rstudio/shinydashboard/pull/205)).

* Fixed [#89](https://github.com/rstudio/shinydashboard/issues/89): We claimed that `dashboardPage()` would try to extract the page's title from `dashboardHeader()` (if the title is not provided directly to `dashboardPage()`); however, we were selecting the wrong child of the header tag object ([#203](https://github.com/rstudio/shinydashboard/pull/203))
	
* Fixed [#129](https://github.com/rstudio/shinydashboard/issues/129): Trigger shown/hidden event for Shiny outputs in the sidebar. ([#194](https://github.com/rstudio/shinydashboard/pull/194))
	
* Fixed [#73](https://github.com/rstudio/shinydashboard/issues/73): add `collapsed` argument to `dashboardSidebar()`, which allows it to start off collapsed. ([#186](https://github.com/rstudio/shinydashboard/pull/186))

* Fixed [#62](https://github.com/rstudio/shinydashboard/issues/62): make images resize when the sidebar collapses/expands. [#185](https://github.com/rstudio/shinydashboard/pull/185)

* Fixed [#176](https://github.com/rstudio/shinydashboard/issues/176) (making buttons look good on the sidebar) by giving Shiny action buttons and links some margin space. ([#182](https://github.com/rstudio/shinydashboard/pull/182))

### Library updates

* Update documentation to newest version of roxygen. (commit [#541d3c1](https://github.com/rstudio/shinydashboard/commit/541d3c13467446c8e89b178d95b0984729559059))

* Addressed [#178](https://github.com/rstudio/shinydashboard/issues/178): switch from `npm` to `yarn`. Also upgraded all yarn packages to the `latest` tag (all major changes). [#184](https://github.com/rstudio/shinydashboard/pull/184)

* Updated to AdminLTE 2.3.11. ([#181](https://github.com/rstudio/shinydashboard/pull/181))

shinydashboard 0.5.3
=========================

* Fixed ([#160](https://github.com/rstudio/shinydashboard/issues/160): Using a dynamically-created `sidebarMenu` without an `id` argument would cause the app to not start, when used with Shiny 0.14.

shinydashboard 0.5.2
====================

* Added ability to bookmark and restore tabs, when used with Shiny 0.14 and above. ([#152](https://github.com/rstudio/shinydashboard/issues/152), [#157](https://github.com/rstudio/shinydashboard/pull/157))

* Fixed issue with R CMD check and Shiny version 0.14.

* Updated to AdminLTE 2.3.2 (1ee281b).

shinydashboard 0.5.1
====================

* Logout panels from Shiny Server Pro were previously not visible, but now they are.

* If a `sidebarUserPanel` doesn't have an image, space for the image is no longer allocated.

* `tabNames` are now validated so that illegal characters result in an error early. (#66)

* `sidebarUserPanel` now displays properly. (#70)

* `radioButtons` did not wrap, but now they do. (#60)

shinydashboard 0.5.0
====================

* Updated to AdminLTE 2.1.2 (406de4e). Please note that some CSS selectors have changed, so if you are using custom CSS, it may require modification. The documentation at http://rstudio.github.io/shinydashboard/appearance.html has some updated examples.

* shinydashboard now respects the `shiny.minified` option.

* Collapse buttons on boxes trigger `shown` and `hidden` events. Previously they did not, which resulted in dynamic content not working for boxes that started collapsed. (#17, #42)

* Dynamic menuSubItems now work in the sidebar. (#54)

* Arbitrary content may now be used in a `sidebarMenu()`, not just `menuItem`s. (#44)

* Added options to set the width of `dashboardHeader()` and `dashboardSidebar()`. (#43, #45, #54)
