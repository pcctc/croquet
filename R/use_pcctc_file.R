#' Write PCCTC Project File
#'
#' You may use `use_pcctc_file()` to write a single file from the PCCTC project template.
#' The functions `use_pcctc_gitignore()` and friends are shortcuts for
#' `use_pcctc_file("gitignore")`.
#'
#' @inheritParams create_pcctc_project
#' @inheritParams starter::use_project_file
#' @param filename Optional argument to specify the name of the file to be written.
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
  if (!interactive()) {
    cli::cli_inform(c("!" = "This function must be run interactively."))
    return(invisible())
  }

  # combine the primary and subdirectory templates into one list
  template <- purrr::flatten(croquet::project_templates)
  if (is.null(name)) {
    cli::cli_abort("Argument {.code name} cannot be NULL. Choose one of {.val {names(template)}}")
  }

  # set name and suddirectory as needed
  dirname <- .select_subdirectory(path = here::here())

  # select a filename
  filename <-
    filename %||%
    .select_filename(path = here::here(), template = template,
                     name = name, dir_name = dir_name)


  withr::with_options(
    new = list("croquet.name" = dirname),
    starter::use_project_file(name = name,
                              filename = fs::path(dirname, filename),
                              template = template,
                              open = open)
  )
}

.select_filename <- function(path, template, name, dir_name) {
  folder_name <- basename(path)
  default_filename <-
    withr::with_options(
      new = list("croquet.name" = dir_name),
      eval(template[[name]])$filename |> basename()
    )
  filename_stub <-
    basename(default_filename) |>
    stringr::word(1L, sep = "_") |>
    stringr::str_remove("\\d$")

  file_id <-
    list.files(path = fs::path(path, dir_name), pattern = paste0("^", filename_stub)) |>
    stringr::word(1L, sep = "_") |>
    stringr::str_extract("\\d$") |>
    as.integer() %>%
    `+`(1L)

  # updated filename
  basename(default_filename) |>
    stringr::str_replace(
      pattern = paste0("^", filename_stub, "1_"),
      replacement = paste0(filename_stub, file_id, "_")
    )
}

.select_subdirectory <- function(path) {
  # get a list of the directories that begin with two digits and a hyphen, eg '01-data-setup'
  dirs_that_exist <-
    list.dirs(path = path, full.names = FALSE, recursive = FALSE) |>
    purrr::keep(~stringr::str_detect(., "^\\d{2}-"))

  cli::cli_alert_info("Which subdirectory would you like to place this file in?")
  dirs_that_exist[utils::menu(dirs_that_exist)]
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
