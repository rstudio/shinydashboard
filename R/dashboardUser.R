#' Create a dashboard user profile.
#'
#' @param name userName.
#' @param image user profile picture.
#'
#' @seealso \code{\link{userOutput}} and \code{\link{renderUser}} for dynamically-generating \code{\link{dashboardUser}}.
#' @export
dashboardUser <- function(name = "User",
                          image = paste0("shinydashboard", "-", as.character(utils::packageVersion("shinydashboard")), "/img/guang.jpg"),
                          description = "Alchemist",
                          sub_description = "Member since Aug. 2015",
                          stat1 = "100 Posts",
                          stat2 = "2048 Followers",
                          stat3 = "1024 Following",
                          btn1 = "Profile",
                          btn2 = "Sign Out") {

  # static HTML user account menu
  # HTML(paste0(
  #  '<!-- User Account Menu -->
  #   <li class="dropdown user user-menu">
  #     <!-- Menu Toggle Button -->
  #     <a href="#" class="dropdown-toggle" data-toggle="dropdown">
  #       <!-- The user image in the navbar-->
  #       <img src="', image ,'" class="user-image" alt="User Image">
  #       <!-- hidden-xs hides the username on small devices so only the image appears. -->
  #       <span class="hidden-xs">', name, '</span>
  #     </a>
  #     <ul class="dropdown-menu">
  #       <!-- The user image in the menu -->
  #       <li class="user-header">
  #         <img src="', image, '" class="img-circle" alt="User Image">
  #         <p>',
  #         name, ' - ', description,
  #         '<small>', sub_description, '</small>
  #         </p>
  #       </li>
  #       <!-- Menu Body -->
  #       <li class="user-body">
  #         <div class="row">
  #           <div class="col-xs-4 text-center">
  #             <a href="#">', stat1, '</a>
  #           </div>
  #           <div class="col-xs-4 text-center">
  #             <a href="#">', stat2, '</a>
  #           </div>
  #           <div class="col-xs-4 text-center">
  #             <a href="#">', stat3, '</a>
  #           </div>
  #         </div>
  #         <!-- /.row -->
  #       </li>
  #       <!-- Menu Footer-->
  #       <li class="user-footer">
  #         <div class="pull-left">
  #           <a href="#" class="btn btn-default btn-flat">', btn1, '</a>
  #         </div>
  #         <div class="pull-right">
  #           <a href="#" class="btn btn-default btn-flat">', btn2 ,'</a>
  #         </div>
  #       </li>
  #     </ul>
  #   </li>
  #  '))

  # create user account menu
  tags$li(
    class="dropdown user user-menu",
    # menu toggle button
    tags$a(
      href="#", class="dropdown-toggle", `data-toggle`="dropdown",
      # user img and name in navbar (controlbar - header)
      tags$img(src= image, class="user-image", alt="User Image"),
      tags$span(class="hidden-xs", name)
    ),
    # menu dropdown main
    tags$ul(
      class="dropdown-menu",
      # user img in the menu
      tags$li(
        class="user-header",
        tags$img(src= image, class="img-circle", alt="User Image"),
        tags$p(paste0(name, " - ", description), tags$small(sub_description))
      ),
      # menu body
      tags$li(
        class="user-body",
        tags$div(
          class="row",
          tags$div(
            class="col-xs-4 text-center",
            tags$a(href="#", stat1)
          ),
          tags$div(
            class="col-xs-4 text-center",
            tags$a(href="#", stat2)
          ),
          tags$div(
            class="col-xs-4 text-center",
            tags$a(href="#", stat3)
          )
        )
      ),
      # menu footer
      tags$li(
        class="user-footer",
        tags$div(
          class="pull-left",
          tags$a(id="left-uid-button",href="#", class="btn btn-default btn-flat", btn1)
        ),
        tags$div(
          class="pull-right",
          tags$a(id="right-uid-button",href="#", class="btn btn-default btn-flat", btn2)
        )
      )
    )
  )
}

#' Create a dynamic user output for shinydashboard (client side)
#'
#' This can be used as a placeholder for dynamically-generated \code{\link{dashboardUser}}.
#'
#' @param outputId Output variable name.
#' @param tag A tag function, like \code{tags$li} or \code{tags$ul}.
#'
#' @seealso \code{\link{renderUser}} for the corresponding server side function
#'   and examples.
#' @family user outputs
#' @export
userOutput <- function(outputId) {
  moduleOutput(outputId, tag = tags$li)
}

#' Create dynamic user output (server side)
#'
#' @inheritParams shiny::renderUI
#'
#' @seealso \code{\link{userOutput}} for the corresponding client side function
#'   and examples.
#' @family user outputs
#' @export
renderUser <- shiny::renderUI
