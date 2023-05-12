dat1 <- tibble::tibble(
  var_1 = 1:3
) %>%
  labelled::set_variable_labels(
    var_1 = "Variable 1 (numeric)",
  )

dat2 <- dat1

test_that("labelled_sheet does not give an error when wb object exists in the calling environment", {

  wb <- openxlsx::createWorkbook()

  # To test that error is not given when wb is in the environment
  expect_error(labelled_sheet(data = dat1), NA)
  expect_error(add_labelled_sheet(data = dat2), NA)

})


test_that("labelled_sheet throw an error when no wb object found in the calling environment", {

  # To test that missing wrkbk argument throws an error
  expect_error(labelled_sheet(data = dat1))
  expect_error(add_labelled_sheet(data = dat2))

})

test_that("labelled_sheet wrkbk argument works with alternatively named workbook (not wb)", {

  meghans_wb <- openxlsx::createWorkbook()

  # To test that alternatively named wbs work
  expect_error(labelled_sheet(data = dat1, wrkbk = meghans_wb), NA)
  expect_error(add_labelled_sheet(data = dat2, wrkbk = meghans_wb), NA)

})
