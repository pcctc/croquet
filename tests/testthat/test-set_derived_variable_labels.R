test_that("set_derived_variable_labels() works", {
  iris2 <- iris

  # no error with standard use
  expect_error(
    iris2_labelled <-
      iris2 |>
      set_derived_variable_labels(
        "iris2",
        path = fs::path_package("croquet", "derived-variables-example.csv")
      ),
    NA
  )
  expect_equal(attr(iris2_labelled, "label"), "Base R Iris Data Frame")

  # expect errors/warnings/notes
  expect_snapshot(
    iris2 |>
      set_derived_variable_labels(
        path = fs::path_package("croquet", "derived-variables-example.csv")
      ),
    error = TRUE
  )

  expect_snapshot(
    iris2 |>
      set_derived_variable_labels(
        "iris2",
        path = fs::path_package("croquet", "derived-variables-example-bad-structure.csv")
      ),
    error = TRUE
  )

  expect_snapshot(
    iris2_labelled2 <-
      iris2 |>
      set_derived_variable_labels(
        "iris2",
        path = fs::path_package("croquet", "derived-variables-example-inconsistent-df-label.csv")
      ) |>
      dplyr::as_tibble()
  )
  expect_equal(attr(iris2_labelled2, "label"), "Base R Iris Data Frame")
})
