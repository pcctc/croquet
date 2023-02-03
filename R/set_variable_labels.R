#' Apply variable labels to data frame
#'
#' Takes labels from the Derived Variables excel file and applies them to the
#' passed data frame.
#' The excel sheet must have columns `"varname"` and `"label"`.
#'
#' @param data Data frame
#' @param path Path to Derived Variables xls/xlsx file
#' @param drop Logical indicating whether to drop unlabelled variables
#' @inheritParams readxl::read_excel
#' @author Daniel D. Sjoberg
#' @export
#' @examplesIf FALSE
#' trial %>%
#'   set_variable_labels("derived_variables_sjoberg.xlsx")

set_variable_labels <- function(data, path, sheet = NULL, drop = TRUE) {
  # import ---------------------------------------------------------------------
  # reading in excel file of Derived Variables
  df_derived_variables <- readxl::read_excel(path = path, sheet = sheet)
  if (!c("varname", "label") %in% names(df_derived_variables) %>% any()) {
    stop("Expecting excel sheet to have columns 'varname' and 'label'.", call. = FALSE)
  }

  # variable labels ------------------------------------------------------------
  # converting imported derived variables into named list with labels
  lst_variable_labels <-
    dplyr::tibble(varname = names(data)) %>%
    dplyr::inner_join(df_derived_variables, by = "varname") %>%
    dplyr::select(.data$varname, .data$label) %>%
    tidyr::spread(.data$varname, .data$label) %>%
    purrr::map(I)

  # applying the labels
  labelled::var_label(data) <- lst_variable_labels

  # drop -----------------------------------------------------------------------
  # dropping unlabelled data
  if (isTRUE(drop)) {
    data <- dplyr::select(data, dplyr::all_of(names(lst_variable_labels)))
  }

  # moving ID variables to the front -------------------------------------------
  data <-
    data %>%
    dplyr::select(
      dplyr::any_of(c("mrn", "subject", "patient_id", "id", "subject", "subject_id", "instance_anme")),
      dplyr::everything()
    )

  # return ---------------------------------------------------------------------
  # returning labelled data frame
  data
}
