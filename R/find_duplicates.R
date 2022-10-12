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
find_duplicates <- function(data, id) {

  # alert user if variable is not in data set ----
  #if (!({{id}} %in% names(data))){
  #  usethis::ui_stop("{id} is not in the data set.")
  #}

  # data |>
  #   dplyr::group_by({{id}}) |>
  #   dplyr::add_count() |>
  #   dplyr::ungroup() |>
  #   dplyr::filter(n > 1) |>
  #   dplyr::select({{id}}, num_obs = n) |>
  #   dplyr::distinct()

  data %>%
    dplyr::add_count({{id}}, name = "n") %>%
    dplyr::filter(n > 1) %>%
    dplyr::select({{id}}, num_obs = n) %>%
    dplyr::distinct()
}


