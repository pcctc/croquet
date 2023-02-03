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
create_pcctc_project <- function(path, path_data, renv = TRUE, overwrite = NA) {
  if (missing(path) || missing(path_data)){
    cli::cli_abort("Arguments {.code path} and {.code path_data} must be specified.")
  }

  # build the base directory
  starter::create_project(
    path = path,
    path_data = path_data,
    template = croquet::project_templates[["base"]],
    git = TRUE,
    symlink = FALSE,
    renv = renv,
    overwrite = overwrite,
    open = FALSE
  )

  # add subdirectory with data setup folder
  starter::create_project(
    path = file.path(path, "data-setup"),
    template = croquet::project_templates[["subdirectory"]][setup_directory_files()],
    git = FALSE,
    symlink = FALSE,
    renv = FALSE,
    open = FALSE
  )

  cli::cli_ul("Navigate to {.path {path}}")
}

setup_directory_files <- function() {
  file_to_include <- c("setup", "data_date", "rproj", "rprofile", "readme")
  if (interactive() && isTRUE(is_medidata())) file_to_include <- c("setup_medidata", file_to_include)
  file_to_include
}

is_medidata <- function() {
  utils::menu(c("Yes", "No"), title = "Is the source data housed within Medidata Rave?") %>%
    dplyr::recode("1" = TRUE, "2" = FALSE)
}

#' @export
#' @rdname create_pcctc_project
add_project_directory <- function(name, overwrite = NA) {
  # TODO: add checks that the parent dir exists, has a git repo, name is a string, anything else?

  # adding entries to the _env file
  .add_env_file()
  .add_env_directory_entry(name = name, list(list("data-date"= stringr::str_glue("{Sys.Date()}"))) %>% stats::setNames(name))

  # TODO: add a question to user confirming directory placement!
  path <- file.path(here::here(), name)

  file_to_include <-
    names(croquet::project_templates[["subdirectory"]]) %>%
    setdiff(c("setup", "setup_medidata"))

  starter::create_project(
    path = path,
    template =
      croquet::project_templates[["subdirectory"]][file_to_include],
    git = FALSE,
    symlink = FALSE,
    renv = FALSE,
    open = FALSE
  )
}

#' @export
#' @rdname create_pcctc_project
add_project_setup_directory <- function(renv = TRUE, open = TRUE, overwrite = NA) {
  # add subdirectory with data setup folder
  name <- "data-setup"
  .add_env_file()
  path <- file.path(here::here(), name)
  starter::create_project(
    path = file.path(path, name),
    template = croquet::project_templates[["subdirectory"]][setup_directory_files()],
    git = FALSE,
    renv = renv,
    open = open
  )
}

.add_env_file <- function(path = ".") {
  if (file.exists("_env.yaml")) return(invisible())

  cli::cli_alert_info("The {.path _env.yaml} was not found. Adding it now...")
  path_data <- readline("Enter the path to the data: ")

  starter::create_project(
    path = path,
    path_data = path_data,
    template = croquet::project_templates[["base"]]["env_yaml"],
    git = TRUE,
    symlink = FALSE,
    renv = FALSE,
    overwrite = NA,
    open = FALSE
  )
}

.add_env_directory_entry <- function(name, entry = list("data-setup" = list("data-date"= Sys.Date()))) {
  if (identical(name, "data-setup")) return(invisible())
  cli::cli_alert_success("Adding directory entry to {.path _env.yaml}.")

  lst_env <- yaml::yaml.load_file(input = "_env.yaml")

  lst_env[["directory"]] <- c(lst_env[["directory"]], entry)

  yaml::write_yaml(x = lst_env, file = "_env.yaml")
  return(invisible())
}
