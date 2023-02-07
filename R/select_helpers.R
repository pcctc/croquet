#' Select Helpers
#'
#' - `all_uppercase()` select all columns with names that are upper case
#' - `all_lowercase()` select all columns with names that are lower case
#' @name select_helpers
#'
#' @examples
#' df <- data.frame(ONE = 1, two = 2)
#'
#' df |> select(all_uppercase())
#' df |> select(all_lowercase())
NULL

#' @rdname select_helpers
#' @export
all_uppercase <- function() {
  varnames <- tidyselect::peek_vars()
  which(varnames == toupper(varnames))
}

#' @rdname select_helpers
#' @export
all_lowercase <- function() {
  varnames <- tidyselect::peek_vars()
  which(varnames == tolower(varnames))
}
