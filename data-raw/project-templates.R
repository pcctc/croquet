## code to prepare project template goes here

# Base PCCTC project template --------------------------------------------------
base_directory_template <-
  list(
    rproj_base =
      rlang::expr(list(
        template_filename = fs::path_package("project-templates/default_rproj.Rproj", package = "croquet"),
        filename = stringr::str_glue("{folder_name}.Rproj"),
        copy = TRUE
      )),
    env_yaml =
      rlang::expr(list(
        template_filename = fs::path_package("project-templates/_env.yaml", package = "croquet"),
        filename = "_env.yaml",
        copy = FALSE
      )),
    readme_base =
      rlang::expr(list(
        template_filename = fs::path_package("project-templates/readme.md", package = "croquet"),
        filename = "README.md",
        copy = FALSE
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
        copy = TRUE
      ))
  )

# Deliverable PCCTC folder template --------------------------------------------
sub_directory_template <-
  list(
    readme =
      rlang::expr(list(
        template_filename = fs::path_package("project-templates/readme_subdir.md", package = "croquet"),
        filename = "README.md",
        copy = FALSE
      )),
    setup_medidata =
      rlang::expr(list(
        template_filename = fs::path_package("project-templates/setup-medidata.qmd", package = "croquet"),
        filename = stringr::str_glue("setup0-{basename(dirname(path))}-medidata.qmd"),
        copy = FALSE
      )),
    setup =
      rlang::expr(list(
        template_filename = fs::path_package("project-templates/setup.qmd", package = "croquet"),
        filename = stringr::str_glue("setup1-{basename(dirname(path))}-{folder_name}.qmd"),
        copy = FALSE
      )),
    analysis =
      rlang::expr(list(
        template_filename = fs::path_package("project-templates/analysis.qmd", package = "croquet"),
        filename = stringr::str_glue("analysis1-{basename(dirname(path))}-{folder_name}.qmd"),
        copy = FALSE
      )),
    report =
      rlang::expr(list(
        template_filename = fs::path_package("project-templates/report.qmd", package = "croquet"),
        filename = stringr::str_glue("report1-{basename(dirname(path))}-{folder_name}.qmd"),
        copy = FALSE
      )),
    derived_vars =
      rlang::expr(list(
        template_filename = fs::path_package("project-templates/derived_variables.xlsx", package = "croquet"),
        filename = stringr::str_glue("derived_variables.xlsx"),
        copy = TRUE
      )),
    doc_template =
      rlang::expr(list(
        template_filename = fs::path_package("project-templates/doc_template.docx", package = "croquet"),
        filename = "templates/doc_template.docx",
        copy = TRUE
      )),
    references =
      rlang::expr(list(
        template_filename = fs::path_package("project-templates/references.bib", package = "croquet"),
        filename = stringr::str_glue("templates/references.bib"),
        copy = TRUE
      )),
    csl =
      rlang::expr(list(
        template_filename = fs::path_package("project-templates/european-urology.csl", package = "croquet"),
        filename = "templates/european-urology.csl",
        copy = TRUE
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
