# select_helpers() works

    Code
      dplyr::summarize(df, dplyr::across(all_uppercase(), mean))
    Output
        ONE
      1   1

