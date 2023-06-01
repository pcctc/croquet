# set_derived_variable_labels() works

    Code
      iris2[1:3, ] %>% dplyr::mutate(UPPERCASE_VAR = TRUE, lowercase_var = TRUE,
        MiXeDcase_vAr = TRUE, bad_merge_var.x = TRUE, bad_merge_var.y = TRUE) %>%
        set_derived_variable_labels(df_name = "iris2", path = fs::path_package(
          "croquet", "derived-variables-example.csv"))
    Condition
      Warning:
      ! The following columns end in ".x" or ".y", which is likely an error: "bad_merge_var.x" and "bad_merge_var.y"
    Message
      i The following lowercase columns have been removed: "lowercase_var", "bad_merge_var.x", and "bad_merge_var.y"
      i The following uppercase columns have been removed: "UPPERCASE_VAR"
      i The following mixed-case columns have been removed: "Sepal.Width", "Petal.Length", "Petal.Width", and "MiXeDcase_vAr"
    Output
        Sepal.Length Species
      1          5.1  setosa
      2          4.9  setosa
      3          4.7  setosa

---

    Code
      iris2 %>% set_derived_variable_labels(path = fs::path_package("croquet",
        "derived-variables-example.csv"))
    Condition
      Error in `set_derived_variable_labels()`:
      x Could not determine the name of the passed data frame. Specify the `set_derived_variable_labels(df_name)` argument.

---

    Code
      set_derived_variable_labels(iris2, df_name = letters, path = fs::path_package(
        "croquet", "derived-variables-example.csv"))
    Condition
      Error in `set_derived_variable_labels()`:
      ! The `set_derived_variable_labels(df_name)` argument must be a string.

---

    Code
      set_derived_variable_labels(iris2, df_name = "iris2", path = "not_a_real_file.xlsx")
    Condition
      Error in `set_derived_variable_labels()`:
      x The file specified in `path` argument must be a CSV: Excel files no longer accepted.

---

    Code
      set_derived_variable_labels(iris2, "iris2", path = fs::path_package("croquet",
        "derived-variables-example-bad-structure.csv"))
    Condition
      Error in `set_derived_variable_labels()`:
      x CSV file 'derived-variables-example-bad-structure.csv' is not expected structure.
      ! Expecting columns "df_name", "df_label", "var_name", and "var_label".

---

    Code
      iris2_labelled2 <- dplyr::as_tibble(set_derived_variable_labels(iris2, "iris2",
        path = fs::path_package("croquet",
          "derived-variables-example-inconsistent-df-label.csv")))
    Message
      ! Data frame label is not consistent for all rows: "Base R Iris Data Frame" and "Inconsistent DF label".
      i The first label will be used.
      i The following mixed-case columns have been removed: "Sepal.Width", "Petal.Length", and "Petal.Width"

---

    Code
      set_derived_variable_labels(iris2, "not_a_data_frame_name", path = fs::path_package(
        "croquet", "derived-variables-example.csv"))
    Condition
      Error in `set_derived_variable_labels()`:
      x The data name "not_a_data_frame_name" does not appear in the derived variables file.
      i Specify one of "iris2"

