#' Convert a path or URL to a location object.
#'
#' @export
#'
#' @param x Input.
#' @param ... Ignored.
#' @examples \dontrun{
#' # A file
#' file <- system.file("examples", "zillow_or.geojson", package = "geojsonio")
#' as.location(file)
#'
#' # A URL
#' url <- "https://raw.githubusercontent.com/glynnbird/usstatesgeojson/master/california.geojson"
#' as.location(url)
#' }

as.location <- function(x, ...) UseMethod("as.location")

#' @export
as.location.character <- function(x, ...) check_location(x, ...)

#' @export
as.location.location <- function(x, ...) x

check_location <- function(x, ...){
  if (is.url(x)) {
    as_location(x, "url")
  } else {
    if (!file.exists(x)) stop("File does not exist. Create it, or fix the path.", call. = FALSE)
    as_location(path.expand(x), "file")
  }
}

as_location <- function(x, type){
  structure(x, class = "location", type = type)
}

#' @export
print.location <- function(x, ...){
  cat("<location>", "\n")
  cat("   Type: ", attr(x, "type"), "\n")
  cat("   Location: ", x[[1]], "\n")
}

is.url <- function(x, ...){
  grepl("https?://", x)
}
