test_that("create_pcctc_project() works", {
  temp_project_dir <- file.path(tempdir(), "c12-3456-trial")
  unlink(temp_project_dir, recursive = TRUE)

  expect_error(
    create_pcctc_project(
      path = temp_project_dir,
      renv = FALSE,
      overwrite = TRUE
    ),
    NA
  )

  expect_setequal(
    list.files(temp_project_dir, recursive = TRUE),
    c(
      "c12-3456-trial.Rproj", "data-setup/c12-3456-trial-data-setup.Rproj",
      "data-setup/data-setup/setup1-c12-3456-trial-data-setup.qmd", "data-setup/data_date.txt",
      "data-setup/README.md", "README.md"
    )
  )
})
