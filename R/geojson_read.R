#' Read geojson from a local file or a URL
#'
#' @export
#'
#' @param x Path to a local file or a URL.
#' @param ... Further args passed on to \code{\link[rgdal]{readOGR}}
#'
#' @examples \donttest{
#' # From a file
#' file <- system.file("examples", "california.geojson", package = "togeojson")
#' out <- geojson_read(file)
#' plot(out)
#'
#' # From a URL
#' url <- "https://raw.githubusercontent.com/glynnbird/usstatesgeojson/master/california.geojson"
#' geojson_read(url)
#' geojson_read(url, stringsAsFactors=FALSE)
#' 
#' # Use as.location first if you want
#' geojson_read(as.location(file))
#' }
geojson_read <- function(x, ...) {
  UseMethod("geojson_read")
}

#' @export
geojson_read.character <- function(x, ...) { 
  read_json(as.location(x), ...)
}

#' @export
geojson_read.location <- function(x, ...) {
  read_json(x, ...)
}

read_json <- function(x, ...) {
  readOGR(x, ogrListLayers(x), ...)
}
