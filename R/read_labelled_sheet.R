#' Reads an excel sheet with labelled data
#'
#' Assumes variable names are on row 1 and variable labels are on row 2.
#'
#' @param path to the xls/xlsx file, including data set name and extension
#' @param sheet name of sheet to import
#' @param date_detect regex expression indicating variables to be imported
#' as dates
#'
#' @return a tibble
#' @export
#'
#' @examples
#' \dontrun{
#' d1 <- read_labelled_sheet(
#'   path = here::here(path, dsn1),
#'   sheet = "ae_listings",
#'   date_detect = "cyc1_visdat|cyc2_visdat"
#')
#'}
read_labelled_sheet <- function(path, sheet, date_detect = NULL){

  # data frame with variable names and single row containing variable labels
  dat_header <- readxl::read_excel(path = path, sheet = sheet, n_max = 1)

  # list with variable names and variable labels
  # suppressing a warning is probably not a great idea, but this works
  dat_labels <- suppressWarnings(tibble::deframe(dat_header))

  # variable names
  dat_names <- names(dat_header)

  # when date detect strings are specified
  if (!is.null(date_detect)) {
    date_variables <- stringr::str_detect(dat_names, regex(date_detect))
    variable_types <- ifelse(date_variables, "date", "guess")
  }

  # when date detect strings are not specifed
  if (is.null(date_detect)) variable_types <- rep("guess", length(dat_names))

  # import data, skip headers, assign variable types, and variable names
  dat <- readxl::read_excel(
    path = path,
    sheet = sheet,
    skip = 2,
    col_names = dat_names,
    col_types = variable_types
  )

  labelled::var_label(dat) <- dat_labels

  return(dat)
}
