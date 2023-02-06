test_that("theme_gtsummary_pcctc() works", {
  expect_error(
    theme_gtsummary_pcctc(),
    NA
  )

  expect_snapshot(
    gtsummary::trial %>%
      gtsummary::tbl_summary(by = trt, include = age) %>%
      gtsummary::add_p() %>%
      gtsummary::as_tibble()
  )

  gtsummary::reset_gtsummary_theme()
})
