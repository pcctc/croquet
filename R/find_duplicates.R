#' Find duplicate observations in a data frame by a identifier.
#'
#' @inheritParams dplyr::count
#' @export
#'
#' @examples
#' x <- data.frame(subject = c("a", "a", "b", "c", "c"))
#' find_duplicates(x, subject)
#' find_duplicates(mtcars, vs, am)
#'
find_duplicates <- function(x, ..., sort = FALSE, name = "n") {
  # count & return duplicate observations
  dplyr::count(x = x, ..., sort = sort, name = name) |>
    dplyr::filter(.data[[name]] > 1L)
}
