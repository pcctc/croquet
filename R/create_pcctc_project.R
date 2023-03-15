#' Create PCCTC Project
#'
#' @description
#' A typical project directory will look like this:
#' ```
#' ├── .git
#' ├── README.md
#' ├── _metadata
#' │   ├── _env.yaml
#' │   ├── european-urology.csl
#' │   └── references.bib
#' ├── 01-data-setup
#' │   ├── README.md
#' │   ├── setup0_data-setup_medidata.qmd
#' │   ├── setup1_data-setup.qmd
#' │   ├── setup2_data-setup_progression.qmd
#' │   └── derived-variables_data-setup.xlsx
#' ├── 02-metrics
#' │   ├── README.md
#' │   ├── analysis1_metrics.qmd
#' │   └── report1_metrics.qmd
#' ├── 03-data-review
#' │   ├── README.md
#' │   └── analysis1_data-reviews-pointblank.qmd
#' ├── 04-visit-reports
#' │   ├── README.md
#' │   └── report1_visit-reports.qmd
#' ├── 05-trial-aims
#' │   ├── README.md
#' │   ├── analysis1_trial-aims-consort.qmd
#' │   ├── analysis2_trial-aims-safety.qmd
#' │   ├── analysis3_trial-aims-primary-aims.qmd
#' │   ├── report1_trial-aims-consort.qmd
#' │   ├── report2_trial-aims-safety.qmd
#' │   └── report3_trial-aims-primary-aims.qmd
#' ```
#'
#' @inheritParams starter::create_project
#' @param dir_name name of directory to add to project folder.
#'
#' @name create_pcctc_project
#' @author Daniel D. Sjoberg
#' @examplesIf FALSE
#' # add example
NULL

#' @export
#' @rdname create_pcctc_project
create_pcctc_project <- function(path, path_data, renv = TRUE,
                                 overwrite = NA, open = interactive()) {
  if (missing(path) || missing(path_data)){
    cli::cli_abort("Arguments {.code path} and {.code path_data} must be specified.")
  }

  # build the base directory
  withr::with_options(
    new = list("croquet.name" = "01-data-setup",
               "croquet.data_storage_type" = .data_storage_type()),
    code =
      starter::create_project(
        path = path,
        path_data = path_data,
        template =
          c(
            croquet::project_templates[["base"]],
            croquet::project_templates[["subdirectory"]][setup_directory_files()]
          ),
        git = TRUE,
        symlink = FALSE,
        renv = renv,
        overwrite = overwrite,
        open = open
      )
  )
}

setup_directory_files <- function() {
  file_to_include <- c("setup", "readme", "derived_vars")
  if (interactive() && isTRUE(is_medidata()))
    file_to_include <- c("setup_medidata", "derived_vars_medidata", file_to_include)
  file_to_include
}

is_medidata <- function() {
  utils::menu(c("Yes", "No"), title = "Is the source data housed within Medidata Rave?") %>%
    dplyr::recode("1" = TRUE, "2" = FALSE)
}

#' @export
#' @rdname create_pcctc_project
add_project_directory <- function(dir_name, overwrite = NA) {
  if (!interactive()) {
    cli::cli_inform(c("!" = "This function must be run interactively."))
    return(invisible())
  }

  # adding entries to the _env.yaml file
  .add_env_file()

  file_to_include <-
    names(croquet::project_templates[["subdirectory"]]) %>%
    setdiff(c("setup", "setup_medidata", "derived_vars", "derived_vars_medidata"))

  if (missing(dir_name)) {
    dir_name <- .select_dirname()
  }

  withr::with_options(
    new = list("croquet.name" = dir_name),
    starter::create_project(
      path = here::here(),
      template =
        croquet::project_templates[["subdirectory"]][file_to_include],
      overwrite = overwrite,
      git = FALSE,
      symlink = FALSE,
      renv = FALSE,
      open = FALSE
    )
  )
}

.select_dirname <- function() {
  # get vector of dir names that start with "01-", "02-", etc.
  dirs_that_exist <-
    list.dirs(path = here::here(), recursive = FALSE) |>
    purrr::keep(~stringr::str_detect(., "^\\d{2}-"))

  # assign the new dir name ID prefix
  folder_id <-
    dirs_that_exist |>
    stringr::str_remove("^\\d{2}") |>
    as.integer() %>%
    {ifelse(rlang::is_empty(.) || is.na(.), 0L, .)} %>%
    `+`(1L) |>
    stringr::str_pad(width = 2, pad = "0", side = "left")

  # get list of common dir names to suggest to user
  potential_dirnames <-
    c("data-setup", "metrics", "data-review", "visit-reports", "trial-aims",
      "<something_else>") |>
    setdiff(stringr::str_remove(dirs_that_exist, "^\\d{2}-")) %>%
    {paste(folder_id, ., sep = "-")}

  # ask the user which folder name they would like to use
  cli::cli_alert_info("What would you like to call the new directory?")
  final_dirname <- potential_dirnames[utils::menu(potential_dirnames)]

  if (stringr::str_detect(final_dirname, "-<something_else>$")) {
    final_dirname <- paste(folder_id, readline("Specify directory name (folder number will be prefixed): "), sep = "-")
  }

  # return new dir name
  final_dirname
}

.add_env_file <- function(path = ".") {
  if (file.exists(here::here("_metadata", "_env.yaml"))) return(invisible())

  cli::cli_alert_info("The {.path _metadata/_env.yaml} was not found. Adding it now...")
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


.data_storage_type <- function() {
  switch(
    interactive() %>% as.character(),
    "TRUE" =
      utils::menu(c("Local or Mapped Network Drive", "Sharepoint"),
                  title = "Where is the project data stored?") %>%
      dplyr::recode("1" = "local_data", "2" = "sharepoint"),
    "FALSE" = "local_data"
  )
}


