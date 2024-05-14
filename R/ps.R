#' Parallel or Sequential Processing of Files
#'
#' This function processes a set of files either in parallel or sequentially based on the `use_background` flag.
#' It uses a list of keys from the result files to determine the processing strategy. The process can be executed
#' in parallel using multiple workers or sequentially.
#'
#' @param process_key A function that processes individual keys in `resultFiles` using `processingId` and a database connection `con`.
#' @param resultFiles A named list of files where each name corresponds to a key that `process_key` will process.
#' @param processingId A unique identifier used in the processing function to tag or identify the process.
#' @param con A database connection object, typically a connection created via DBI.
#' @param use_background Logical, if TRUE, processing is done in parallel using multiple sessions; if FALSE, it is done sequentially.
#'
#' @return A list of results from applying `process_key` function to each file.
#' @importFrom future plan multisession
#' @importFrom future.apply future_lapply
#' @export
#' @examples
#' \dontrun{
#'   # Define a processing function
#'   process_function <- function(key, files, id, con) {
#'     # hypothetical function to process files
#'     Sys.sleep(1)  # simulate processing time
#'     return(paste("Processed", key, "with ID", id))
#'   }
#'
#'   # Example files list
#'   files_to_process <- list(file1 = "path/to/file1", file2 = "path/to/file2")
#'
#'   # Processing ID and mock connection object
#'   process_id <- "12345"
#'   db_con <- NULL  # Assuming a real DBI connection object here
#'
#'   # Run processing in background
#'   results <- ps.llmNarrative(process_function, files_to_process, process_id, db_con, TRUE)
#'   print(results)
#' }
#' @seealso \code{\link[future]{plan}}, \code{\link[future.apply]{future_lapply}}
ps.llmNarrative <- function(process_key, resultFiles, processingId, con, use_background = FALSE) {
  keys <- names(resultFiles)
  plan(multisession, workers = length(keys))  # Set the number of parallel workers

  # Decide on parallel or sequential execution based on use_background flag
  if (use_background) {
    # Use future_lapply for parallel processing
    results <- future_lapply(keys, function(key) {
      process_key(key, resultFiles, processingId, con)
    })
  } else {
    # Use regular lapply for sequential processing
    results <- lapply(keys, function(key) {
      process_key(key, resultFiles, processingId, con)
    })
  }

  return(results)
}
