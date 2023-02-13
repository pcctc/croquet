#' Path to Data Directory
#'
#' @param ... Path components below the project root, can be empty.
#' Each argument should be a string containing one or more path components.
#'
#' @return a path
#' @name here_data
NULL

#' @export
#' @rdname here_data
here_data <- function(...) {
  # import and check settings --------------------------------------------------
  data_date <- get_data_date()

  env_yaml <- yaml::yaml.load_file(input = here::here("metadata", "_env.yaml"))
  path_data <- env_yaml[["path-data"]]
  if (rlang::is_empty(path_data) || !dir.exists(path_data)) {
    paste("Cannot use the {.code here_data()} function without the {.field path-data: data-date} field set",
          "in {.path metadata/_env.yaml} AND this path must exist.") %>%
      cli::cli_abort()
  }

  path_data_date <- file.path(path_data, data_date) |> normalizePath(winslash = "/", mustWork = FALSE)
  if (!dir.exists(path_data_date)) {
    paste("The data date directory does not exist: {.path {path_data_date}}") %>%
      cli::cli_alert_danger()
  }

  # return constructed path ----------------------------------------------------
  final_path <- file.path(path_data_date, ...) |> normalizePath(winslash = "/", mustWork = FALSE)
  .notify_dir_exist(final_path)
  final_path
}

#' @export
#' @rdname here_data
get_data_date <- function() {
  if (!file.exists(here::here("metadata", "_env.yaml"))) {
    cli::cli_abort("Cannot use the {.code here_data()} function without the {.path metadata/_env.yaml} file in the project root directory.")
  }
  env_yaml <- yaml::yaml.load_file(input = here::here("metadata", "_env.yaml"))

  data_date <- env_yaml[["data-date"]]
  if (rlang::is_empty(data_date)) {
    paste("Cannot use the {.code here_data()} function without the {.field data-date} field set",
          "in {.path metadata/_env.yaml}.") %>%
      cli::cli_abort()
  }
  data_date
}


.notify_dir_exist <- function(path) {
  if (basename(path) |> stringr::str_detect(stringr::fixed("."))) {
    path <- dirname(path)
  }
  if (!dir.exists(path)) {
    cli::cli_alert_info("Path {.path {path}} does not exist.")

    if (interactive()) {
      create_dir <-
        utils::menu(c("Yes", "No"), title = "Do you want to create it?") %>%
        dplyr::recode("1" = TRUE, "2" = FALSE)

      if (isTRUE(create_dir)) {
        dir.create(path = path)
      }
    }

  }
  invisible()
}
