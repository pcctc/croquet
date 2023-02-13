## code to prepare project template goes here

# Base PCCTC project template --------------------------------------------------
base_directory_template <-
  list(
    rproj_base =
      rlang::expr(list(
        template_filename = fs::path_package("project-templates/default_rproj.Rproj", package = "croquet"),
        filename = stringr::str_glue("{folder_name}.Rproj"),
        glue = FALSE
      )),
    env_yaml =
      rlang::expr(list(
        template_filename = fs::path_package("project-templates/_env.yaml", package = "croquet"),
        filename = "metadata/_env.yaml",
        glue = TRUE
      )),
    readme_base =
      rlang::expr(list(
        template_filename = fs::path_package("project-templates/readme.md", package = "croquet"),
        filename = "README.md",
        glue = TRUE
      )),
    # only add Rprofile if renv was used
    rprofile =
      rlang::expr(switch(renv,
                         list(
                           template_filename =
                             fs::path_package(package = "starter", "project_templates/default_rprofile.R"),
                           filename = stringr::str_glue(".Rprofile"),
                           glue = TRUE
                         )
      )),
    gitignore =
      rlang::expr(list(
        template_filename = fs::path_package("project-templates/gitignore.txt", package = "croquet"),
        filename = ".gitignore",
        glue = FALSE
      )),
    references =
      rlang::expr(list(
        template_filename = fs::path_package("project-templates/references.bib", package = "croquet"),
        filename = "metadata/references.bib",
        glue = FALSE
      )),
    csl =
      rlang::expr(list(
        template_filename = fs::path_package("project-templates/european-urology.csl", package = "croquet"),
        filename = "metadata/european-urology.csl",
        glue = FALSE
      ))
  )

# Deliverable PCCTC folder template --------------------------------------------
sub_directory_template <-
  list(
    readme =
      rlang::expr(list(
        template_filename = fs::path_package("project-templates/readme_subdir.md", package = "croquet"),
        filename =
          do.call(
            'file.path',
            list(getOption("croquet.name"), "README.md") |> purrr::discard(rlang::is_empty)
          ),
        glue = TRUE
      )),
    setup_medidata =
      rlang::expr(list(
        template_filename = fs::path_package("project-templates/setup-medidata.qmd", package = "croquet"),
        filename =
          do.call(
            'file.path',
            list(getOption("croquet.name"), stringr::str_glue("setup0_{folder_name}_medidata.qmd")) |>
              purrr::discard(rlang::is_empty)
          ),
        glue = TRUE
      )),
    setup =
      rlang::expr(list(
        template_filename = fs::path_package("project-templates/setup.qmd", package = "croquet"),
        filename =
          do.call(
            'file.path',
            list(getOption("croquet.name"), stringr::str_glue("setup1_{folder_name}_{getOption('croquet.name')}.qmd")) |>
              purrr::discard(rlang::is_empty)
          ),
        glue = TRUE
      )),
    analysis =
      rlang::expr(list(
        template_filename = fs::path_package("project-templates/analysis.qmd", package = "croquet"),
        filename =
          do.call(
            'file.path',
            list(getOption("croquet.name"), stringr::str_glue("analysis1_{folder_name}_{getOption('croquet.name')}.qmd")) |>
              purrr::discard(rlang::is_empty)
          ),
        glue = TRUE
      )),
    report =
      rlang::expr(list(
        template_filename = fs::path_package("project-templates/report.qmd", package = "croquet"),
        filename =
          do.call(
            'file.path',
            list(getOption("croquet.name"), stringr::str_glue("report1_{folder_name}_{getOption('croquet.name')}.qmd")) |>
              purrr::discard(rlang::is_empty)
          ),
        glue = TRUE
      )),
    derived_vars =
      rlang::expr(list(
        template_filename = fs::path_package("project-templates/derived_variables.xlsx", package = "croquet"),
        filename =
          do.call(
            'file.path',
            list(getOption("croquet.name"), stringr::str_glue("derived_variables-{folder_name}_{getOption('croquet.name')}.xlsx")) |>
              purrr::discard(rlang::is_empty)
          ),
        glue = FALSE
      )),
    derived_vars_medidata =
      rlang::expr(list(
        template_filename = fs::path_package("project-templates/derived_variables_medidata.xlsx", package = "croquet"),
        filename =
          do.call(
            'file.path',
            list(getOption("croquet.name"), stringr::str_glue("derived_variables_medidata-{folder_name}.xlsx")) |>
              purrr::discard(rlang::is_empty)
          ),
        glue = FALSE
      ))
  )


attr(base_directory_template, "script_path") <-
  expression(fs::path_package("project-templates/script_phi_private.R", package = "croquet"))
attr(base_directory_template, "label") <- "PCCTC Project Template"
attr(sub_directory_template, "label") <- "PCCTC Project Subdirectory Template"

# Create template object -----

project_templates <- list()
project_templates[["base"]] <- base_directory_template
project_templates[["subdirectory"]] <- sub_directory_template

usethis::use_data(project_templates, overwrite = TRUE)
