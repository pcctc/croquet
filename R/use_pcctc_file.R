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
#' use_pcctc_file("gitignore")
#' use_pcctc_gitignore()

NULL

#' @rdname use_pcctc_file
#' @export
use_pcctc_file <- function(name = NULL, filename = NULL, open = interactive()) {
  # combine the primary and subdirectory templates into one list
  template <- purrr::flatten(croquet::project_templates)

  # set name and suddirectory as needed
  if (is.null(name)) {
    cli::cli_abort("Argument {.code name} cannot be NULL. Choose one of {.val {names(template)}}")
  }
  if (name %in% names(croquet::project_templates$subdirectory) && interactive()) {
    subdirs <-
      list.dirs(path = here::here(), full.names = TRUE, recursive = FALSE) |>
      stringr::str_remove(pattern = here::here("")) |>
      stringr::str_remove(stringr::fixed("/")) |>
      purrr::discard(~startsWith(., "."))

    cli::cli_alert_info("Which subdirectory would you like to place this file in?")
    dir_name <- subdirs[utils::menu(subdirs)]
  }

  withr::with_options(
    new = list("croquet.name" = dir_name),
    starter::use_project_file(
      name = name, filename = filename, template = template, open = open)
  )
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
