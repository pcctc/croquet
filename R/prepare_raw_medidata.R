#' Prepare Raw Medidata
#'
#' Function performs initial cleaning of a list of Medidata data frames.
#' - Convert empty strings to `NA`.
#' - Convert all date-time columns to dates.
#' - Any dates imputed to the year 1900 are made `NA`.
#' - All variables are made upper/lower case (depending on the function passed in `rename_fn=`).
#'
#' @param x list of Medidata data frames, often imported with `read_sas_batch()`
#' @param rename_fn function passed to `dpylr::rename_with(.fn=)`. Default is `toupper`.
#' @param retain_datetime character vector of column names that will not be converted to dates.
#'
#' @return list of data frames
#' @export
#'
#' @examplesIf FALSE
#' read_sas_batch(x) |>
#'   prepare_raw_medidata()
prepare_raw_medidata <- function(x, rename_fn = toupper, retain_datetime = NULL) {
  if (!rlang::is_list(x) || purrr::some(x, Negate(is.data.frame)))
    cli::cli_abort("Argument {.code x} must be a list of data frames.")
  if (!rlang::is_function(x))
    cli::cli_abort("Argument {.code rename_fn} must be a function.")

  x |>
    # convert empty character strings to NA
    lapply(\(x) x |> dplyr::mutate(dplyr::across(where(is.character), ~dplyr::na_if(., "")))) |>
    # convert all date-time variables to dates only
    lapply(\(x) x |> dplyr::mutate(dplyr::across(where(lubridate::is.POSIXct), lubridate::as_date))) |>
    # convert all date fields stored as unknown / 1900 to missing |>
    lapply(\(x) x |> dplyr::mutate(dplyr::across(c(where(lubridate::is.Date), -dplyr::all_of(retain_datetime)), ~dplyr::case_when(lubridate::year(.) == 1900 ~ NA_Date_, TRUE ~ .)))) |>
    # make all RAW variables uppercase (or whatever transformation is passed by user)
    lapply(\(x) dplyr::rename_with(x, .fn = rename_fn, .cols = dplyr::everything()))
}
