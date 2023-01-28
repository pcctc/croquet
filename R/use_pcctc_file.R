#' Write PCCTC Project File
#'
#' You may use `use_pcctc_file()` to write a single file from the PCCTC project template.
#' The functions `use_pcctc_gitignore()` and friends are shortcuts for
#' `use_pcctc_file("gitignore")`.
#'
#' @inheritParams create_pcctc_project
#' @inheritParams starter::use_project_file
#' @name use_pcctc_file
#' @seealso [`create_pcctc_project()`]
#' @examplesIf FALSE
#' # create gitignore file
#' use_bst_file("gitignore")
#' use_bst_gitignore()
#'
#' # create README.md file
#' use_bst_file("readme")
#' use_bst_readme()
NULL

#' @rdname use_pcctc_file
#' @export
use_pcctc_file <- function(name, filename, open = interactive()) {
  starter::use_project_file(
    name = name, filename = filename, template = purrr::flatten(project_templates), open = open)
}

#' @rdname use_pcctc_file
#' @export
use_pcctc_gitignore <- function(filename = NULL) {
  use_pcctc_file(name = "gitignore", filename = filename)
}

#' @rdname use_pcctc_file
#' @export
use_pcctc_setup <- function(filename = NULL) {
  use_pcctc_file(name = "setup", filename = filename)
}

#' @rdname use_pcctc_file
#' @export
use_pcctc_analysis <- function(filename = NULL) {
  use_pcctc_file(name = "analysis", filename = filename)
}

#' @rdname use_pcctc_file
#' @export
use_pcctc_report <- function(filename = NULL) {
  use_pcctc_file(name = "report", filename = filename)
}
