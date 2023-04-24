test_that("labelled_sheet wrkbk argument works", {

  dat1 <- tibble::tibble(
    var_1 = 1:3
    ) %>%
    labelled::set_variable_labels(
      var_1 = "Variable 1 (numeric)",
    )

  dat2 <- tibble::tibble(
    var_2 = LETTERS[1:3],
  ) %>%
    labelled::set_variable_labels(
      var_2 = "Variable 2 (character)",
    )

  wb <- openxlsx::createWorkbook()

  # To test that missing wrkbk argument throws an error
  expect_snapshot(labelled_sheet(data = dat1), NA)
  expect_snapshot(add_labelled_sheet(data = dat2), NA)

})



