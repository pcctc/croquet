#' Create PCCTC Project
#'
#' @inheritParams starter::create_project
#'
#' @name create_pcctc_project
#' @examples
#' # add example
NULL

#' @export
#' @rdname create_pcctc_project
create_pcctc_project <- function(path, renv = TRUE, overwrite = NA) {
  # build the base directory
  starter::create_project(
    path = path,
    template = croquet::project_templates[["base"]],
    git = TRUE,
    renv = FALSE,
    open = FALSE
  )

  # add subdirectory with data setup folder
  starter::create_project(
    path = file.path(path, "data-setup"),
    template = croquet::project_templates[["subdirectory"]][c("setup", "data_date", "rproj", "rprofile")],
    git = FALSE,
    renv = renv,
    open = FALSE
  )

  cli::cli_alert_success("Navigate to {.path {path}}")
}

#' @export
#' @rdname create_pcctc_project
add_project_subdirectory <- function(path, renv = TRUE, open = TRUE, overwrite = NA) {
  # add checks that the parent dir exists, has a git repo, anything else?

  starter::create_project(
    path = path,
    template = croquet::project_templates[["subdirectory"]][!names(project_templates[["subdirectory"]]) %in% c("setup", "readme")],
    git = FALSE,
    renv = renv,
    open = open
  )
}
