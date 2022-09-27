#' Adds a sheet to an excel workbook with with both variable names and labels.
#'
#' Row 1 contains variable labels; row 2 contains variable names, freeze panes,
#' and filters. Header styling is applied.  You can add additional styling
#' options to sheet with the openxlsx::add functions after executed.
#'
#' @param data labelled data to add to sheet. can accept named list or data frame.
#' @param sheet_name optional sheet name; if none provided, sheet will be assigned name
#' of input data set
#' @param wrkbk workbook object, defaults to wb
#'
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
add_labelled_sheet <- function(data, sheet_name = NULL, wrkbk = wb){

  # character name of input data
  data_chr <- rlang::as_label(rlang::ensym(data))

  # if sheet name not supplied, use name of input data
  if(is.null(sheet_name)) sheet_name <- data_chr

  # exporting when list of data frames supplied
  if("list" %in% class(data))   purrr::imap(data, ~labelled_sheet(.x, .y, wrkbk))

  # exporting when single data frame supplied
  if("data.frame" %in% class(data))  labelled_sheet(data, sheet_name, wrkbk)
}
