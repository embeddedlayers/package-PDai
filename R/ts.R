#' Time Series Aggregation Function
#'
#' This function aggregates a time series data set based on a specified metric. It converts the data into
#' a data.table format, groups the data by calculated group sizes to ensure full coverage across the
#' specified output length, and applies a chosen aggregation function to the grouped data.
#'
#' @param ts A data frame or data.table containing the time series data.
#' @param date_name The name of the column in `ts` that contains the date information (defaults to 'ds').
#' @param includeColumns A character vector specifying which columns to include in the aggregation (defaults to 'trend').
#' @param outputLength The desired number of output groups (defaults to 100).
#' @param metric The aggregation metric to apply ('mean', 'median', 'mode', or 'weighted').
#' @return A list containing a description of the aggregation and a data.table summarizing the aggregated data.
#' @export
#' @importFrom data.table data.table
#' @importFrom data.table as.data.table
#' @importFrom data.table setkey
#' @examples
#' \dontrun{
#' ts_data <- data.table(ds = seq(as.Date("2020/1/1"), by = "day", length.out = 300),
#'                       trend = rnorm(300))
#' aggregated_data <- ts.aggregate(ts_data, date_name = 'ds', includeColumns = c('trend'), outputLength = 10, metric = "mean")
#' print(aggregated_data)
#' }
ts.aggregate <- function(ts, date_name = 'ds', includeColumns = c('trend'), outputLength = 100, metric = "mean") {
  # Ensure ts is a data.table
  if (!inherits(ts, "data.table")) {
    ts <- data.table::as.data.table(ts)
  }

  # Calculate number of rows per group
  n <- nrow(ts)
  group_size <- ceiling(n / outputLength)  # Adjust group size to ensure full coverage

  # Add a group column based on calculated size
  ts[, group_id := (seq_len(n) - 1) %/% group_size + 1]

  # Define function based on metric choice
  fun <- switch(metric,
                mean = function(x) mean(x, na.rm = TRUE),
                median = function(x) median(x, na.rm = TRUE),
                # mode = function(x) as.numeric(mlv(x, method = "mfv")$mode),  # Most Frequent Value as mode
                weighted = function(x) weighted.mean(x, w = !is.na(x)),  # Example: simple weighting
                stop("Invalid metric specified"))

  # Perform aggregation
  aggregated_data <- ts[, c(
    .(
      dateFrom = min(as.Date(get(date_name), origin = "1970-01-01")),
      dateTo = max(as.Date(get(date_name), origin = "1970-01-01")),
      dateN = .N
    ),
    lapply(.SD, fun)  # Apply chosen function
  ), by = group_id, .SDcols = includeColumns]

  # Optionally drop the group_id column if not needed
  aggregated_data[, group_id := NULL]

  # Return results in a structured list
  return(list(
    description = sprintf("Data aggregated into %d groups based on the %s of columns: %s.", outputLength, metric, toString(includeColumns)),
    data_summary = data.table::as.data.table(aggregated_data)
  ))
}

