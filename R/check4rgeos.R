check4rgeos <- function() {
  if (!requireNamespace("rgeos", quietly = TRUE)) {
    stop("Please install rgeos", call. = FALSE)
  }  
}
