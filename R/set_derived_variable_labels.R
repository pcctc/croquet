#' Apply variable labels to data frame
#'
#' Takes labels from the Derived Variables CSV file and applies them to the
#' passed data frame.
#' The excel sheet must have columns `"df_name"`, `"df_label"`, `"var_name"`, and `"var_label"`.
#' The returned data frame is also labelled with the value in `"df_label"`.
#'
#' @param data Data frame
#' @param path Path to CSV file
#' @param df_name string indicating the name of the data frame to apply labels to.
#' If not specified, we'll do our best to determine the name of the passed data frame.
#' @param drop Logical indicating whether to drop unlabeled variables
#' @export
#' @examplesIf FALSE
#' trial %>%
#'   set_derived_variable_labels("derived_variables_sjoberg.csv")
set_derived_variable_labels <- function(data, df_name, path, drop = TRUE) {
  # grabbing function call, and trying to parse the passed data object name ----
  if (missing(df_name)) {
    df_name <-
      tryCatch(
        match.call() |>
          as.list() |>
          purrr::pluck("data") |>
          as.character() |>
          setdiff("."),
        error = function(e) NULL
      )

    if (rlang::is_empty(df_name)) {
      c("x" = paste("Could not determine the name of the passed data frame.",
                    "Specify the {.code set_derived_variable_labels(df_name)} argument.")) |>
        cli::cli_abort()
    }
  }
  if (!rlang::is_string(df_name)) {
    cli::cli_abort("The {.code set_derived_variable_labels(df_name)} argument must be a string.")
  }

  # check inputs ---------------------------------------------------------------
  if (missing(data) || missing(path)) {
    required_args <- c("data", "path")
    cli::cli_abort(c("x" = "Arguments {.val {required_args}} must be specified."))
  }
  if (stringr::str_ends(string = path, pattern = "xlsx|xls")) {
    cli::cli_abort(c("x" = "The file specified in {.code path} argument must be a CSV: Excel files no longer accepted."))
  }

  # import ---------------------------------------------------------------------
  # reading in excel file of Derived Variables
  df_derived_variables <-
    readr::read_csv(file = path, show_col_types = FALSE)
  required_columns <- c("df_name", "df_label", "var_name", "var_label")
  if (!all(required_columns %in% names(df_derived_variables))) {
    cli::cli_abort(
      c("x" = "CSV file {.path {basename(path)}} is not expected structure.",
        "!" = "Expecting columns {.val {required_columns}}.")
    )
  }
  if (!df_name %in% df_derived_variables$df_name) {
    c("x" = "The data name {.val {df_name}} does not appear in the derived variables file.",
      "i" = "Specify one of {.val {unique(df_derived_variables$df_name)}}") |>
      cli::cli_abort()
  }

  # subset df_derived_variables ------------------------------------------------
  df_derived_variables <-
    df_derived_variables |>
    dplyr::filter(.data$df_name %in% .env$df_name) |>
    dplyr::select(dplyr::all_of(required_columns))
  if (length(unique(df_derived_variables$df_label)) > 1L) {
    cli::cli_inform(
      c("!" = "Data frame label is not consistent for all rows: {.val {unique(df_derived_variables$df_label)}}.",
        "i" = "The first label will be used.")
    )
  }

  # messaging about potential errors -------------------------------------------
  colnames_bad_merge <- colnames(data) |> purrr::keep(~grepl(pattern = "\\.x$|\\.y$", x = .))
  if (!rlang::is_empty(colnames_bad_merge)) {
    cli::cli_warn(
      c("!" = "The following columns end in {.val .x} or {.val .y}, which is likely an error: {.val {colnames_bad_merge}}")
    )
  }

  # assign variable labels -----------------------------------------------------
  # convert labels into named list
  lst_variable_labels <-
    df_derived_variables[c("var_name", "var_label")] %>%
    {as.list(.$var_label) |> stats::setNames(.$var_name)} %>%
    # keep labels with columns in the data frame
    {.[intersect(names(.), names(data))]}
  data <- labelled::set_variable_labels(data, .labels = lst_variable_labels)

  # drop -----------------------------------------------------------------------
  # dropping unlabelled data (ie variables not specified in file)
  if (isTRUE(drop)) {
    colnames_drop_lowercase <-
      dplyr::select(
        data,
        all_lowercase(),
        -dplyr::any_of(names(lst_variable_labels))
      ) |>
      names()
    colnames_drop_uppercase <-
      dplyr::select(
        data,
        all_uppercase(),
        -dplyr::any_of(names(lst_variable_labels))
      ) |>
      names()
    colnames_drop_other <-
      dplyr::select(
        data,
        -dplyr::any_of(c(names(lst_variable_labels), colnames_drop_lowercase, colnames_drop_uppercase))
      ) |>
      names()
    if (!rlang::is_empty(colnames_drop_lowercase)) {
      cli::cli_inform(c("i" = "The following {.strong lowercase} columns have been removed: {.val {colnames_drop_lowercase}}"))
    }
    if (!rlang::is_empty(colnames_drop_uppercase)) {
      cli::cli_inform(c("i" = "The following {.strong uppercase} columns have been removed: {.val {colnames_drop_uppercase}}"))
    }
    if (!rlang::is_empty(colnames_drop_other)) {
      cli::cli_inform(c("i" = "The following {.strong  mixed-case} columns have been removed: {.val {colnames_drop_other}}"))
    }

    data <- dplyr::select(data, dplyr::all_of(names(lst_variable_labels)))
  }

  # return ---------------------------------------------------------------------
  # returning labelled data frame
  attr(data, "label") <- df_derived_variables$df_label[1]
  data
}
