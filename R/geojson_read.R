#' Read geojson from a local file or a URL
#'
#' @export
#'
#' @param x Path to a local file or a URL.
#' @param method One of web or local. Matches on partial strings.
#' @param parse (logical) To parse geojson to data.frame like structures if possible. 
#' Default: \code{FALSE}
#' @param ... Ignored
#' @details Uses \code{\link{file_to_geojson}} internally.
#'
#' @examples \dontrun{
#' # From a file
#' file <- system.file("examples", "california.geojson", package = "geojsonio")
#' out <- geojson_read(file)
#'
#' # From a URL
#' url <- "https://raw.githubusercontent.com/glynnbird/usstatesgeojson/master/california.geojson"
#' geojson_read(url, method = "local")
#' 
#' # Use as.location first if you want
#' geojson_read(as.location(file))
#' 
#' # use jsonlite to parse to data.frame structures where possible
#' url <- "https://raw.githubusercontent.com/glynnbird/usstatesgeojson/master/california.geojson"
#' geojson_read(url, method = "local", parse = TRUE)
#' }
geojson_read <- function(x, method = "web", parse = FALSE, ...) {
  UseMethod("geojson_read")
}

#' @export
geojson_read.character <- function(x, method = "web", parse = FALSE, ...) { 
  read_json(as.location(x), method, parse, ...)
}

#' @export
geojson_read.location <- function(x, method = "web", parse = FALSE, ...) {
  read_json(x, method, parse, ...)
}

read_json <- function(x, method, parse, ...) {
  file_to_geojson(x, method, output = ":memory:", parse)
}
