# set_derived_variable_labels() works

    Code
      set_derived_variable_labels(iris2, path = fs::path_package("croquet",
        "derived-variables-example.csv"))
    Condition
      Error in `set_derived_variable_labels()`:
      x Arguments "data", "df_name", and "path" must be specified.

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

