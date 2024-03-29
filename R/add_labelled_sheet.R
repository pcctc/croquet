#' Adds a sheet to an excel workbook with with both variable names and labels.
#'
#' Row 1 contains variable labels; row 2 contains variable names, freeze panes,
#' and filters. Header styling is applied.  You can add additional styling
#' options to sheet with the openxlsx::add functions after executed.
#'
#' @param data labelled data to add to sheet
#' @param sheet_name optional sheet name; if none provided, sheet will be assigned name
#' of input data set
#' @param wrkbk expects a workbook object created from `openxlsx::createWorkbook()`, if not supplied by user, function will search for an object called 'wb' in the calling environment.
#' @param start_row integer row position where the labels must be placed, `data` is placed at start_row+1, defaults to 1L

#' @return a workbook object
#' @export
#'
#' @examples
#' \dontrun{
#' library(openxlsx)
#' library(croquet)
#' options("openxlsx.dateFormat" = "yyyy-mm-dd")
#'
#' # example 1: single data frame ----
#' dat1 <- tibble::tibble(
#'   var_1 = 1:3,
#'   var_2 = LETTERS[1:3],
#'   var_3 = Sys.Date() - 0:2
#'   ) %>%
#'   labelled::set_variable_labels(
#'     var_1 = "Variable 1 (numeric)",
#'     var_2 = "Variable 2 (character)",
#'     var_3 = "Variable 3 (date)"
#'   )
#' wb <- createWorkbook()
#' add_labelled_sheet(dat1)
#' add_labelled_sheet(dat1, sheet_name = "example sheet")
#' saveWorkbook(wb, "checkwb.xlsx")
#'
#'
#' # example 2: list of data frames ----
#' dat2 <- tibble::tibble(
#'   var_1 = 4:6,
#'   var_2 = LETTERS[4:6],
#'   var_3 = Sys.Date() - 0:2
#'   ) %>%
#'   labelled::set_variable_labels(
#'     var_1 = "Variable 1 (numeric)",
#'     var_2 = "Variable 2 (character)",
#'     var_3 = "Variable 3 (date)"
#'   )
#'
#' out <- tibble::lst(dat1, dat2)
#' wb <- createWorkbook()
#' add_labelled_sheet(out)
#' saveWorkbook(wb, "checkwb.xlsx")
#'}
#'
add_labelled_sheet <- function(data, sheet_name = NULL, wrkbk, start_row = 1L){

  # check for input workbook in the environment
  if (missing(wrkbk) && exists("wb", envir = rlang::caller_env())) {
    wrkbk <- get("wb", envir = rlang::caller_env())
  }
  else if (missing(wrkbk)) {
    paste(
      "The {.code wrkbk} argument has not been specified,",
      "and the default object {.field wb} does not exist in the calling environment."
    ) |>
      cli::cli_abort()
  }

  # character name of input data
  data_chr <- rlang::as_label(rlang::ensym(data))

  # if sheet name not supplied, use name of input data
  if(is.null(sheet_name)) sheet_name <- data_chr

  # exporting when list of data frames supplied
  if("list" %in% class(data))   purrr::imap(data, ~labelled_sheet(.x, .y, wrkbk, start_row))

  # exporting when single data frame supplied
  if("data.frame" %in% class(data))  labelled_sheet(data, sheet_name, wrkbk, start_row)
}
