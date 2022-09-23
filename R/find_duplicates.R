#' Find duplicate observations in a data frame by a identifier.
#'
#' @param data a data frame
#' @param id a variable containing the supposedly unique identifier
#'
#' @return a tibble with non-uniquely identified rows
#' @export
#'
#' @examples
#' x <- data.frame(subject = c("a", "a", "b", "c", "c"))
#' y <- data.frame(subject = LETTERS[1:5])
#' find_duplicates(x, subject)
#' find_duplicates(y, subject)
find_duplicates <- function(data, ids = NULL) {

  # convert id character string ----
  ids_chr <-
    broom.helpers::.select_to_varnames(
      select = {{ ids }},
      data = data,
      arg_name = "ids"
    )

  # count & return duplicate observations
  data |>
    dplyr::group_by(dplyr::across({{ids}})) |>
    dplyr::add_count(name = "num_obs") |>
    dplyr::ungroup() |>
    dplyr::filter(num_obs > 1) |>
    dplyr::select(dplyr::all_of(ids_chr), num_obs) |>
    dplyr::distinct() |>
    dplyr::arrange(num_obs)
}




##' @inheritParams dplyr::count
##' @export
#find_duplicates <- function(x, ..., sort = FALSE, name = NULL) {
#  # count & return duplicate observations
#  dplyr::count(x = x, ..., sort = sort, name = name) |>
#    dplyr::filter(!!rlang::sym(rlang::`%||%`(name, "n")) > 1L)
#}
#mtcars |>
#  find_duplicates(cyl, mpg)
##>   cyl  mpg n
##> 1   4 22.8 2
##> 2   4 30.4 2
##> 3   6 21.0 2
##> 4   8 10.4 2
##> 5   8 15.2 2


