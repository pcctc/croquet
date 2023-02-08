test_that("select_helpers() works", {
  df <- data.frame(ONE = 1, two = 2)

  expect_equal(
    df |> select(all_uppercase()) |> names(),
    "ONE"
  )

  expect_equal(
    df |>
      labelled::set_variable_labels(ONE = "First Column") |>
      select(all_labelled()) |>
      names(),
    "ONE"
  )

  expect_equal(
    df |> select(all_lowercase()) |> names(),
    "two"
  )

  expect_snapshot(
    df |> dplyr::summarize(dplyr::across(all_uppercase(), mean))
  )
})
