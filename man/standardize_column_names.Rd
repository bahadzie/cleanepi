% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/column_name_standardisation.R
\name{standardize_column_names}
\alias{standardize_column_names}
\title{Standardize column names of a data frame or linelist}
\usage{
standardize_column_names(data, keep = NULL)
}
\arguments{
\item{data}{The input data frame or linelist.}

\item{keep}{A vector of column names to maintain. The Default
is \code{NULL}.}
}
\value{
A data frame with easy to work with column names.
}
\description{
Standardize column names of a data frame or linelist
}
\examples{
cleaned_data <- standardize_column_names(
  data = readRDS(system.file("extdata", "test_df.RDS",
                             package = "cleanepi")),
  keep = c("Sex", "Country")
)

}
