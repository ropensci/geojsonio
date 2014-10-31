#' Read a geojson file
#'
#' @export
#'
#' @param file Path to a local file or a URL.
#' @param ... Further args passed on to \code{\link[jsonlite]{toJSON}}
#'
#' @examples \dontrun{
#' # From a file
#' geojson_read("~/asdfafaf")
#'
#' # From a URL
#' geojson_read('<URL>')
#' }

geojson_read <- function(...) UseMethod("geojson_read")

#' @export
#' @rdname geojson_read
geojson_read.file <- function(input, ...) read_geojson(as.path(input))

#' @export
#' @rdname geojson_read
geojson_read.url <- function(input, ...) read_geojson(as.path(input))
