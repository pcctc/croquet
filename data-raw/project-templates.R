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
        filename = "_env.yaml",
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
      ))
  )

# Deliverable PCCTC folder template --------------------------------------------
sub_directory_template <-
  list(
    readme =
      rlang::expr(list(
        template_filename = fs::path_package("project-templates/readme_subdir.md", package = "croquet"),
        filename = "README.md",
        glue = TRUE
      )),
    setup_medidata =
      rlang::expr(list(
        template_filename = fs::path_package("project-templates/setup-medidata.qmd", package = "croquet"),
        filename = stringr::str_glue("setup0_{basename(dirname(path))}_medidata.qmd"),
        glue = TRUE
      )),
    setup =
      rlang::expr(list(
        template_filename = fs::path_package("project-templates/setup.qmd", package = "croquet"),
        filename = stringr::str_glue("setup1_{basename(dirname(path))}_{folder_name}.qmd"),
        glue = TRUE
      )),
    analysis =
      rlang::expr(list(
        template_filename = fs::path_package("project-templates/analysis.qmd", package = "croquet"),
        filename = stringr::str_glue("analysis1_{basename(dirname(path))}_{folder_name}.qmd"),
        glue = TRUE
      )),
    report =
      rlang::expr(list(
        template_filename = fs::path_package("project-templates/report.qmd", package = "croquet"),
        filename = stringr::str_glue("report1_{basename(dirname(path))}_{folder_name}.qmd"),
        glue = TRUE
      )),
    derived_vars =
      rlang::expr(list(
        template_filename = fs::path_package("project-templates/derived_variables.xlsx", package = "croquet"),
        filename = stringr::str_glue("derived_variables-{basename(dirname(path))}-{folder_name}.xlsx"),
        glue = FALSE
      )),
    doc_template =
      rlang::expr(list(
        template_filename = fs::path_package("project-templates/doc_template.docx", package = "croquet"),
        filename = "templates/doc_template.docx",
        glue = FALSE
      )),
    references =
      rlang::expr(list(
        template_filename = fs::path_package("project-templates/references.bib", package = "croquet"),
        filename = stringr::str_glue("templates/references.bib"),
        glue = FALSE
      )),
    csl =
      rlang::expr(list(
        template_filename = fs::path_package("project-templates/european-urology.csl", package = "croquet"),
        filename = "templates/european-urology.csl",
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
