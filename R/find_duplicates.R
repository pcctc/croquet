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


