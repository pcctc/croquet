#' A hidden function to add labelled data sheet to an excel workbook through openxlsx
#'
#' You can add additional styling options to sheet with the openxlsx::add functions
#' after executed.
#'
#' @param data labelled data to add to sheet
#' @param wb workbook name
#' @param sheet_name optional sheet name; if none provided, sheet will be assigned name
#' of input data set
#'
#' @return not sure... a workbook object or something
#'
#' @examples
#' \dontrun{
#' # this doesnt seem to work consistently for me
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
#' labelled_sheet(dat_labelled, "example sheet")
#' saveWorkbook(wb, "checkwb.xlsx")
#'}
labelled_sheet <- function(data, wb = wb, sheet_name = NULL){

  # ----------------------------------------------------------------------------
  # global settings and preferences - where should these go?
  # global options for date formatting
  # options("openxlsx.dateFormat" = "yyyy-mm-dd")

  # heading 1: light gray background, black text
  hs1 <- openxlsx::createStyle(fontColour = "#000000", fgFill = "#F2F2F2", textDecoration = "Bold" )

  # heading 2: black background, light gray text
  hs2 <- openxlsx::createStyle(fontColour = "#F2F2F2", fgFill = "#000000", textDecoration = "Bold" )

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
  openxlsx::addWorksheet(wb, sheetName = sheet_name)

  # export data without column names starting at row 3
  openxlsx::writeData(wb, sheet = sheet_name, x = data, colNames = FALSE, startRow = 3)

  # export variable names and labels to rows 1 and 2
  openxlsx::writeData(wb, sheet = sheet_name, x = var_labels, colNames = TRUE, headerStyle = hs1)

  # add freeze pane on rows 1 and 2
  openxlsx::freezePane(wb, sheet = sheet_name, firstActiveRow = 3)

  # add dark styling to variable labels
  openxlsx::addStyle(wb, sheet = sheet_name, style = hs2, rows = 2, cols = 1:length(var_labels))

  # add filter to variable labels
  openxlsx::addFilter(wb, sheet = sheet_name, rows = 2, cols = 1:length(var_labels))

}
