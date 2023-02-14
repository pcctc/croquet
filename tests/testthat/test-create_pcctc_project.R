test_that("create_pcctc_project() works", {
  temp_project_dir <- file.path(tempdir(), "c12-3456-trial")
  unlink(temp_project_dir, recursive = TRUE)

  expect_error(
    create_pcctc_project(
      path = temp_project_dir,
      path_data = tempdir(),
      renv = FALSE,
      overwrite = TRUE,
      open = FALSE
    ),
    NA
  )

  expect_setequal(
    list.files(temp_project_dir, recursive = TRUE),
    c(
      "_metadata/_env.yaml",
      "_metadata/european-urology.csl",
      "_metadata/references.bib",
      "01-data-setup/derived-variables_c12-3456-trial.xlsx",
      "01-data-setup/README.md",
      "01-data-setup/setup1_c12-3456-trial.qmd",
      "c12-3456-trial.Rproj",
      "README.md"
    )
  )
})
