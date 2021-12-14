#' Splits data frame by groups into a named list
#'
#' Behaves similarly to dplyr::group_split(), with the addition of
#' named list elements. Borrowed from Romain Francois in this dplyr issue:
#' https://github.com/tidyverse/dplyr/issues/4223
#'
#' @param .tbl a data frame
#' @param ... Grouping specification, forwarded to group_by()
#'
#' @return a named list
#' @export
#'
#' @examples
#' \dontrun{
#' mtcars %>% group_split_named(am)
#' mtcars %>% group_split_named(cyl, am)
#' }
#'
#'
group_split_named <- function(.tbl,...) {

  # copied from this issue
  # https://github.com/tidyverse/dplyr/issues/4223

  grouped <- dplyr::group_by(.tbl, ...)
  names <- rlang::eval_bare(rlang::expr(paste(!!!dplyr::group_keys(grouped), sep = "_")))

  grouped %>%
    dplyr::group_split() %>%
    rlang::set_names(names)
}

