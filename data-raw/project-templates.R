## code to prepare project template goes here

# Base PCCTC project template ------------------------------------------------------
project_template_default <-
  list(
    readme = rlang::expr(list(
      template_filename = fs::path_package("project-templates/readme.md", package = "croquet"),
      filename = "README.md",
      copy = FALSE
    )),
    gitignore = rlang::expr(list(
      template_filename = fs::path_package("project-templates/gitignore.txt", package = "croquet"),
      filename = ".gitignore",
      copy = TRUE
    )),
    data_date = rlang::expr(list(
      template_filename = fs::path_package("project-templates/data_date.txt", package = "croquet"),
      filename = "data_date.txt",
      copy = FALSE
    )),
    rproj = rlang::expr(list(
      template_filename = fs::path_package("project-templates/default_rproj.Rproj", package = "croquet"),
      filename = glue::glue("_rstudio_project.Rproj"),
      copy = TRUE
    )),
    derived_vars = rlang::expr(list(
      template_filename = fs::path_package("project-templates/derived_variables.xlsx", package = "croquet"),
      filename = glue::glue("data-setup/derived_variables.xlsx"),
      copy = TRUE
    )),
    setup = rlang::expr(list(
      template_filename = fs::path_package("project-templates/setup.qmd", package = "croquet"),
      filename = glue::glue("data-setup/10-setup_{folder_first_word}.qmd"),
      copy = FALSE
    )),
    analysis = rlang::expr(list(
      template_filename = fs::path_package("project-templates/analysis.qmd", package = "croquet"),
      filename = glue::glue("analysis/20-analysis_{folder_first_word}.qmd"),
      copy = FALSE
    )),
    report = rlang::expr(list(
      template_filename = fs::path_package("project-templates/report.qmd", package = "croquet"),
      filename = glue::glue("analysis/30-report_{folder_first_word}.qmd"),
      copy = FALSE
    )),
    doc_template = rlang::expr(list(
      template_filename = fs::path_package("project-templates/doc_template.docx", package = "croquet"),
      filename = "analysis/templates/doc_template.docx",
      copy = TRUE
    )),
    references = rlang::expr(list(
      template_filename = fs::path_package("project-templates/references.bib", package = "croquet"),
      filename = glue::glue("analysis/templates/references.bib"),
      copy = TRUE
    )),
    # only add Rprofile if renv was used
    rprofile =
      rlang::expr(switch(renv,
                         list(
                           template_filename =
                             fs::path_package(package = "starter", "project-templates/default_rprofile.R"),
                           filename = stringr::str_glue(".Rprofile"),
                           glue = TRUE
                         )
      )),
    csl = rlang::expr(list(
      template_filename = fs::path_package("project-templates/european-urology.csl", package = "croquet"),
      filename = "analysis/templates/european-urology.csl",
      copy = TRUE
    ))
  )

attr(project_template_default, "script_path") <-
  expression(fs::path_package("project-templates/script_phi_private.R", package = "croquet"))
attr(project_template_default, "label") <- "PCCTC Project Template (Quarto)"

# Create template object -----

project_templates <- list()
project_templates[["default"]] <- project_template_default

usethis::use_data(project_templates, overwrite = TRUE)
