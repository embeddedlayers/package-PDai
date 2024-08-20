#' Aggregate Large Datasets
#'
#' This function iterates over a list of datasets and aggregates them based on a specified row threshold.
#' It is particularly useful for reducing larger datasets into a more manageable size by averaging over specific intervals.
#'
#' @param datasets A list of data frames, each representing a dataset to potentially be aggregated.
#' @param threshold An integer, the minimum number of rows a dataset must have to be considered for aggregation.
#' @return A list of datasets where datasets exceeding the specified threshold are aggregated.
#' @export
#' @examples
#' \dontrun{
#'   data_list <- list(dataset1 = data.frame(date = as.Date('2020-01-01') + 0:150, value = rnorm(151)),
#'                     dataset2 = data.frame(date = as.Date('2020-01-01') + 0:50, value = rnorm(51)))
#'   aggregated_data <- datasets.aggregate(data_list, threshold = 100)
#'   print(aggregated_data)
#' }
datasets.aggregate <- function (datasets, threshold = 200)
{
  for (name in names(datasets)) {
    dataset <- datasets[[name]]

    if (nrow(dataset) > threshold) {
      # Try to find a date column
      date_columns <- names(dataset)[sapply(dataset, function(col) inherits(col, c("Date", "POSIXct", "POSIXt")))]
      if (length(date_columns) > 0) {
        # If a date column exists, use it for time series aggregation
        date_name <- date_columns[1]
        includeColumns <- names(dataset)[sapply(dataset, is.numeric)]
        aggregated_data <- PDai::ts.aggregate(dataset, date_name = date_name,
                                              includeColumns = includeColumns, outputLength = threshold,
                                              metric = "mean")
        datasets[[name]] <- aggregated_data
      } else {
        # If no date column, sample evenly spaced rows
        sample_indices <- seq(1, nrow(dataset), length.out = threshold)
        datasets[[name]] <- dataset[round(sample_indices), ]
      }
    }
  }
  return(datasets)
}

