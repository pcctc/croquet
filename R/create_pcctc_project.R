#' Create PCCTC Project
#'
#' @inheritParams starter::create_project
#' @param name name of directory to add to project folder.
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
    template = croquet::project_templates[["subdirectory"]][c("setup", "data_date", "rproj", "rprofile", "readme")],
    git = FALSE,
    renv = renv,
    open = FALSE
  )

  cli::cli_alert_success("Navigate to {.path {path}}")
}

#' @export
#' @rdname create_pcctc_project
add_project_subdirectory <- function(name, renv = TRUE, open = TRUE, overwrite = NA) {
  # TODO: add checks that the parent dir exists, has a git repo, name is a string, anything else?

  # TODO: add a question to user confirming directory placement!
  path <- file.path(here::here(), name)

  starter::create_project(
    path = path,
    template = croquet::project_templates[["subdirectory"]][!names(project_templates[["subdirectory"]]) %in% c("setup")],
    git = FALSE,
    renv = renv,
    open = open
  )
}
