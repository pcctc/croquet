% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/read_labelled_sheet.R
\name{read_labelled_sheet}
\alias{read_labelled_sheet}
\title{Reads an excel sheet with labelled data}
\usage{
read_labelled_sheet(path, sheet, date_detect = NULL, start_row = 1L)
}
\arguments{
\item{path}{to the xls/xlsx file, including data set name and extension}

\item{sheet}{name of sheet to import}

\item{date_detect}{regex expression indicating variables to be imported
as dates}

\item{start_row}{integer row position where labels are placed, defaults to 1L}
}
\value{
a tibble
}
\description{
Assumes variable labels are on row 1 and variable names are on row 2.
}
\examples{
\dontrun{
d1 <- read_labelled_sheet(
  path = here::here(path, dsn1),
  sheet = "ae_listings",
  date_detect = "cyc1_visdat|cyc2_visdat"
)
}
}
