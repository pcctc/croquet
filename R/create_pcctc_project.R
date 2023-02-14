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
#' ├── 04-trial-aims
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
    new = list("croquet.name" = "data-setup"),
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
add_project_directory <- function(overwrite = NA) {
  # TODO: add checks that the parent dir exists, has a git repo, dir_name is a string, anything else?

  # adding entries to the _env.yaml file
  .add_env_file()

  file_to_include <-
    names(croquet::project_templates[["subdirectory"]]) %>%
    setdiff(c("setup", "setup_medidata", "derived_vars", "derived_vars_medidata"))

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

