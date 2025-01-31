
#' Build data cleaning report
#'
#' @param original The original input data.
#' @param modified A data frame that has been altered or modified as a result of
#'  the most recent data cleaning operation.
#' @param state The name of the current data cleaning operation.
#' @param report A  list. This could be a report object
#'    generated from a previous data cleaning step.
#'
#' @return A list  with the details about the cleaning
#'    operations
#' @keywords internal
#' @noRd
#'
report_cleaning <- function(original, modified,
                            state = "current", report = NULL) {
  if (is.null(report)) {
    report <- list()
  }
  report <- switch(state,
                   "remove_empty" = report_remove_empty(report, state, original, modified), # nolint: keyword_quote_linter
                   "remove_constant" = report_remove_constant(state, original, modified, # nolint: keyword_quote_linter
                                                              report),
                   "remove_dupliates" = report_remove_dups(report, state, original, modified), # nolint: keyword_quote_linter
                   "standardize_date" = report_dates(report, state, original, modified) # nolint: keyword_quote_linter
  )
  report
}

#' Generate report after the removal of empty rows
#'
#' @param report A list  containing the details of data cleaning report.
#' @param state The name of the current cleaning operation.
#' @param original The original data set.
#' @param modified A data frame that has been altered or modified as a result of
#'  the most recent data cleaning operation.
#'
#' @return A list. This is the input report object with the
#'    additional report made from the current operation.
#' @keywords internal
#' @noRd
#'
report_remove_empty <- function(report, state, original, modified) {
  cols <- rows <- NULL
  idx <- which(!(names(original) %in% names(modified)))
  if (length(idx) > 0L) {
    cols <- names(original)[idx]
  }

  if (nrow(summary(arsenal::comparedf(original, modified))[["obs.table"]]) > 0L) { # nolint: line_length_linter
    rows <-
      summary(arsenal::comparedf(original, modified))[["obs.table"]][["observation"]] # nolint: line_length_linter
  }

  if (!is.null(cols)) {
    report[[state]] <- list()
    report[[state]][["columns"]] <- cols
  }
  if (!is.null(rows)) {
    if (state %in% names(report)) {
      report[[state]][["rows"]] <- rows
    } else {
      report[[state]] <- list()
      report[[state]][["rows"]] <- rows
    }
  }

  report
}

#' Generate report after constant columns and rows removal
#'
#' @param report A list  containing the details of data cleaning report.
#' @param state The name of the current cleaning operation.
#' @param original The original data set. This can be the dataset obtained from
#'    a previous cleaning operation.
#' @param modified A data frame that has been altered or modified as a result of
#'  the most recent data cleaning operation.
#'
#' @return an object of type `list`. This is the input report object with the
#'    additional report made from the current operation.
#' @keywords internal
#' @noRd
#'
report_remove_constant <- function(state, original, modified, report) {
  report[[state]] <- list()
  report[[state]][["constant_columns"]] <- NULL
  idx <- which(!(names(original) %in% names(modified)))
  if (length(idx) > 0L) {
    report[[state]][["constant_columns"]] <- names(original)[idx]
  }

  if (is.null(report[[state]][["constant_columns"]])) {
    report[[state]] <- NULL
  }
  report
}

#' Generate report after the duplicates removal
#'
#' @param report A list  containing the details of the data cleaning report.
#' @param state The name of the current cleaning operation.
#' @param original The original data set. This can be the dataset obtained from
#'    a previous cleaning operation
#' @param modified A data frame that has been altered or modified as a result of
#'  the most recent data cleaning operation.
#'
#' @return A list. This is the input report object with the
#'    additional report made from the current operation.
#' @keywords internal
#' @noRd
#'
report_remove_dups <- function(report, state, original, modified) {
  report[[state]] <- list()
  report[[state]][["duplicates"]] <- NULL

  if (nrow(summary(arsenal::comparedf(original, modified))[["obs.table"]]) > 0L) { # nolint: line_length_linter
    report[[state]][["duplicates"]] <-
      summary(arsenal::comparedf(original, modified))[["obs.table"]][["observation"]] # nolint: line_length_linter
  }

  if (is.null(report[[state]][["duplicates"]])) {
    report[[state]] <- NULL
  }

  report
}

#' Generate report after the date standardization operation
#'
#' @param report A list  containing the details of the data cleaning report.
#' @param state The name of the current cleaning operation.
#' @param original The original data set. This can be the dataset obtained from
#'    a previous cleaning operation
#' @param modified A data frame that has been altered or modified as a result of
#'  the most recent data cleaning operation.
#'
#' @return A list. This is the input report object with the
#'    additional report made from the current operation.
#' @keywords internal
#' @noRd
#'
report_dates <- function(report, state, original, modified) {
  if (!(state %in% names(report))) {
    report[[state]] <- list()
    report[[state]][["standardized_date"]] <- NULL
  }

  if (nrow(summary(arsenal::comparedf(original, modified))[["vars.nc.table"]]) > 0L) { # nolint: line_length_linter
    report[[state]][["standardized_date"]] <-
      unique(summary(arsenal::comparedf(original,
                                        modified))[["vars.nc.table"]][["var.x"]]) # nolint: line_length_linter
  }

  if (is.null(report[[state]][["standardized_date"]])) {
    report[[state]] <- NULL
  }
  report
}
