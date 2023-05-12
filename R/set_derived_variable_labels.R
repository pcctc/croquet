#' Apply variable labels to data frame
#'
#' Takes labels from the Derived Variables CSV file and applies them to the
#' passed data frame.
#' The excel sheet must have columns `"df_name"`, `"df_label"`, `"var_name"`, and `"var_label"`.
#' The returned data frame is also labelled with the value in `"df_label"`.
#'
#' @param data Data frame
#' @param path Path to CSV file
#' @param df_name string indicating the name of the data frame to apply labels to
#' @param drop Logical indicating whether to drop unlabeled variables
#' @author Daniel D. Sjoberg
#' @export
#' @examplesIf FALSE
#' trial %>%
#'   set_derived_variable_labels("derived_variables_sjoberg.xlsx")
set_derived_variable_labels <- function(data, df_name, path, drop = TRUE) {
  # check inputs ---------------------------------------------------------------
  if (missing(data) || missing(df_name) || missing(path)) {
    required_args <- c("data", "df_name", "path")
    cli::cli_abort(c("x" = "Arguments {.val {required_args}} must be specified."))
  }
  if (stringr::str_ends(string = path, pattern = "xlsx|xls")) {
    cli::cli_abort(c("x" = "The file specified in {.code path} argument must be a CSV: Excel files no longer accepted."))
  }

  # import ---------------------------------------------------------------------
  # reading in excel file of Derived Variables
  df_derived_variables <- readr::read_csv(file = path, show_col_types = FALSE)
  required_columns <- c("df_name", "df_label", "var_name", "var_label")
  if (!all(required_columns %in% names(df_derived_variables))) {
    cli::cli_abort(
      c("x" = "CSV file {.path {basename(path)}} is not expected structure.",
        "!" = "Expecting columns {.val {required_columns}}.")
    )
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
    data <- dplyr::select(data, dplyr::all_of(names(lst_variable_labels)))
  }

  # return ---------------------------------------------------------------------
  # returning labelled data frame
  attr(data, "label") <- df_derived_variables$df_label[1]
  data
}
