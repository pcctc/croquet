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
  expect_equal(names(iris2_labelled), c("Sepal.Length", "Species"))

  # repeating without specifying the df_name argument (to ensure the name can be found)
  expect_error(
    iris2_labelled <-
      iris2 |>
      set_derived_variable_labels(
        path = fs::path_package("croquet", "derived-variables-example.csv")
      ),
    NA
  )
  expect_equal(attr(iris2_labelled, "label"), "Base R Iris Data Frame")
  expect_equal(names(iris2_labelled), c("Sepal.Length", "Species"))

  expect_equal(
    iris2 |>
      set_derived_variable_labels(
        "iris2",
        path = fs::path_package("croquet", "derived-variables-example.csv"),
        drop = FALSE
      ) |>
      names(),
    names(iris2)
  )

  # expect errors/warnings/notes
  expect_snapshot(
    iris2[1:3,] %>%
      dplyr::mutate(
        UPPERCASE_VAR = TRUE,
        lowercase_var = TRUE,
        MiXeDcase_vAr = TRUE,
        bad_merge_var.x = TRUE,
        bad_merge_var.y = TRUE
      ) %>%
      set_derived_variable_labels(
        df_name = "iris2",
        path = fs::path_package("croquet", "derived-variables-example.csv")
      )
  )

  expect_snapshot(
    iris2 %>%
      set_derived_variable_labels(
        path = fs::path_package("croquet", "derived-variables-example.csv")
      ),
    error = TRUE
  )

  expect_snapshot(
    iris2 |>
      set_derived_variable_labels(
        df_name = letters,
        path = fs::path_package("croquet", "derived-variables-example.csv")
      ),
    error = TRUE
  )

  expect_snapshot(
    iris2 |>
      set_derived_variable_labels(
        df_name = "iris2",
        path = "not_a_real_file.xlsx"
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

  expect_snapshot(
    iris2 |>
      set_derived_variable_labels(
        "not_a_data_frame_name",
        path = fs::path_package("croquet", "derived-variables-example.csv")
      ),
    error = TRUE
  )
})
