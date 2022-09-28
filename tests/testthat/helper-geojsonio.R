gdel <- function(x) {
  invisible(gistr::delete(x))
}

supw <- function(x) suppressWarnings(x)

# functions for precision testing
# modified from https://stat.ethz.ch/pipermail/r-help/2012-July/317676.html
decimalnumcount <- function(x) {
  stopifnot(is.character(x))
  vec <- vector("numeric", length = length(x))
  for (i in seq_along(x)) {
    if (!grepl("\\.", x[i])) {
      vec[i] <- 0
    } else {
      w <- strsplit(x[i], "\\.")[[1]][2]
      w <- gsub("(.*)(\\.)|([0]*$)", "", w)
      vec[i] <- nchar(w)
    }
  }
  return(vec)
}
num_digits <- function(x) {
  z <- jsonlite::fromJSON(unclass(x)[[1]])
  if ("features" %in% names(z)) w <- unlist(z$features$geometry$coordinates)
  if ("geometries" %in% names(z)) w <- unlist(z$geometries$coordinates)
  decimalnumcount(as.character(w))
}

supp_invis <- function(x) suppressMessages(invisible(x))
