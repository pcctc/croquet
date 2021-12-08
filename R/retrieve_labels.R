#' Retrieve labels from labelled data
#'
#' @param data labelled data frame
#' @param wide format of return: wide (default) returns a tibble with a single row
#' that contains the variable labels; otherwise, the full data dictionary is returned
#'
#' @return a tibble
#' @export
#'
#' @examples
#'
#'dat_labelled <- tibble::tibble(
#'   var_1 = 1:3,
#'   var_2 = LETTERS[1:3],
#'   var_3 = Sys.Date() - 0:2
#'   ) %>%
#'   labelled::set_variable_labels(
#'     var_1 = "Variable 1 (numbers)",
#'     var_2 = "Variable 2 (letters)",
#'     var_3 = "Variable 3 (date)"
#'   )
#'
#' retrieve_labels(dat_labelled)
#' retrieve_labels(dat_labelled, wide = FALSE)
#'
retrieve_labels <- function(data, wide = TRUE){

  dictionary <- labelled::generate_dictionary(data)

  # for wide format, return a tibble with variable names and single row
  # that contains variable labels
  if (wide){
    out <- dictionary %>%
      dplyr::select(.data$variable, .data$label) %>%
      tidyr::pivot_wider(
        names_from = "variable",
        values_from = "label"
      )
  }

  # for long format, return full dictionary
  if (!wide) out <- tibble::as_tibble(dictionary)

  return(out)
}
