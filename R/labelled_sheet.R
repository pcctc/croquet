#' A hidden function to add labelled data sheet to an excel workbook through openxlsx
#'
#' You can add additional styling options to sheet with the openxlsx::add functions
#' after executed.
#'
#' @param data labelled data to add to sheet
#' @param sheet_name optional sheet name; if none provided, sheet will be assigned name
#' of input data set
#' @param wrkbk workbook name, defaults to wb
#' @param start_row integer row position where the labels must be placed, `data` is placed at start_row+1, defaults to 1L
#'
#' @return a workbook object
#'
#' @examples
#' \dontrun{
#' options("openxlsx.dateFormat" = "yyyy-mm-dd")
#' dat_labelled <- tibble::tibble(
#'   var_1 = 1:3,
#'   var_2 = LETTERS[1:3],
#'   var_3 = Sys.Date() - 0:2
#'   ) %>%
#'   labelled::set_variable_labels(
#'     var_1 = "Variable 1 (numbers)",
#'     var_2 = "Variable 2 (letters)",
#'     var_3 = "Variable 3 (date)"
#'   )
#' wb <- createWorkbook()
#' wb <- labelled_sheet(dat_labelled, sheet_name = "example sheet", wrkbk = wb)
#' saveWorkbook(wb, "checkwb.xlsx")
#'}
labelled_sheet <- function(data, sheet_name = NULL, wrkbk = wb, start_row = 1L){

  # ----------------------------------------------------------------------------
  # global settings and preferences - where should these go?
  # global options for date formatting
  # options("openxlsx.dateFormat" = "yyyy-mm-dd")

  # heading 1: Excel's "Explanatory Text" format
  hs1 <- openxlsx::createStyle(fontColour = "#7F7F7F", textDecoration = "italic", wrapText = TRUE )

  # highlighting option
  #hl <- createStyle(fontColour = "#000000", fgFill = "#FFFFE0")
  # ----------------------------------------------------------------------------

  # character vector of data name
  data_chr <- rlang::as_label(rlang::ensym(data))

  # if no sheet name provided, use name of input data set as sheet name
  if(is.null(sheet_name)) sheet_name <- data_chr

  # get variable labels to export
  var_labels <- retrieve_labels(data)

  # initialize
  openxlsx::addWorksheet(wrkbk, sheetName = sheet_name)

  # export data as an Excel-formatted Table starting at row 2
  openxlsx::writeDataTable(wrkbk, sheet = sheet_name, x = data, colNames = TRUE,
                           startRow = start_row + 1, withFilter=TRUE,
                           tableStyle = "TableStyleLight8") # This table style is default white rows with dark headers

  # export labels to start_row
  openxlsx::writeData(wrkbk, sheet = sheet_name, x = var_labels, colNames = FALSE, startRow = start_row )

  # add freeze pane on start_row and start_row + 1 rows
  openxlsx::freezePane(wrkbk, sheet = sheet_name, firstActiveRow = start_row+2)

  # add style to labels
  openxlsx::addStyle(wrkbk, sheet = sheet_name, rows = start_row, cols = 1:length(var_labels), style = hs1)

}
