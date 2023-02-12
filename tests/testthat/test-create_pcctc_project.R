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
      "_env.yaml",
      "c12-3456-trial.Rproj",
      "data-setup/README.md",
      "data-setup/setup1_c12-3456-trial_data-setup.qmd",
      "README.md"
    )
  )
})
