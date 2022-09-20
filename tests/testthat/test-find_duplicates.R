test_that("find_duplicates_works", {

  x <- data.frame(subject = c("a", "a", "b", "c", "c"))
  y <- data.frame(subject = LETTERS[1:5])

  expect_error(
    find_duplicates(x, subject),
    NA
  )

  expect_equal(
    nrow(find_duplicates(x, subject)),
    2
  )

  expect_equal(
    nrow(find_duplicates(y, subject)),
    0
  )


})
