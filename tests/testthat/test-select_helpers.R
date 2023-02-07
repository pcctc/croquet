test_that("select_helpers() works", {
  df <- data.frame(ONE = 1, two = 2)

  expect_equal(
    df |> select(all_uppercase()) |> names(),
    "ONE"
  )

  expect_equal(
    df |> select(all_lowercase()) |> names(),
    "two"
  )
})
