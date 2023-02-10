test_that("prepare_raw_medidata() works", {
  expect_error(
    mtcars |> prepare_raw_medidata()
  )
  expect_error(
    list(mtcars) |> prepare_raw_medidata(rename_fn = LETTERS)
  )
})
