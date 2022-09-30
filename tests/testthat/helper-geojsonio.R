supm <- function(x) invisible(suppressMessages(x))
supw <- function(x) invisible(suppressWarnings(x))

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

## temporary gist helpers

local_gist_temp_file <- function(envir = parent.frame()) {
  withr::local_tempfile(
    pattern = "geojsonio_test_",
    fileext = ".geojson",
    .local_envir = envir
  )
}

temp_map_gist <- function(..., envir = parent.frame()) {
  g <- supm(map_gist(...))
  withr::defer(
    supm(gistr::delete(g)),
    envir = envir
  )
  g
}
