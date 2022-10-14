test_that("read_labelled_sheet gives same output as input data", {
  options("openxlsx.dateFormat" = "yyyy-mm-dd")
  input_df <- tibble::tibble(
    var_1 = 1:3,
    var_2 = LETTERS[1:3],
    var_3 = Sys.Date() - 0:2
  ) %>%
    labelled::set_variable_labels(
      var_1 = "Variable 1 (numbers)",
      var_2 = "Variable 2 (letters)",
      var_3 = "Variable 3 (date)"
    )
  wb <- openxlsx::createWorkbook()
  add_labelled_sheet(input_df, wb, sheet_name = "example sheet")
  openxlsx::saveWorkbook(wb, "checkwb.xlsx", overwrite = TRUE)

  output_df <- read_labelled_sheet("checkwb.xlsx", sheet = "example sheet")
  unlink("checkwb.xlsx")

  # Column Names are same
  expect_equal(colnames(input_df),colnames(output_df))

  # Labels are same
  expect_equal(unname(labelled::var_label(input_df, unlist = TRUE)),
               unname(labelled::var_label(output_df, unlist = TRUE)))

  # To test that labels starting from rows other than 1 also works
  wb <- openxlsx::createWorkbook()
  add_labelled_sheet(input_df, wb, sheet_name = "example sheet", start_row = 2L)
  openxlsx::saveWorkbook(wb, "checkwb2.xlsx", overwrite = TRUE)

  output_df <- read_labelled_sheet("checkwb2.xlsx", sheet = "example sheet", start_row = 2L)
  unlink("checkwb2.xlsx")

  # Column Names are same
  expect_equal(colnames(input_df),colnames(output_df))

  # Labels are same
  expect_equal(unname(labelled::var_label(input_df, unlist = TRUE)),
               unname(labelled::var_label(output_df, unlist = TRUE)))

})
