#' Select Helpers
#'
#' - `all_uppercase()` select all columns with upper case names
#' - `all_lowercase()` select all columns with lower case names
#' - `all_labelled()` select all columns with a label attribute
#' @name select_helpers
#'
#' @examples
#' df <- data.frame(ONE = 1, two = 2)
#'
#' df |> select(all_uppercase())
#' df |> select(all_lowercase())
#' df |>
#'   labelled::set_variable_labels(ONE = "First Column") |>
#'   select(all_labelled())
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

#' @rdname select_helpers
#' @export
all_labelled <- function() {
  data <- tidyselect::peek_data()

  which(
    !lapply(seq_len(ncol(data)), \(x) attr(data[[x]], "label") |> is.null()) |> unlist()
  )
}
