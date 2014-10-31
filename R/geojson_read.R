#' Read a geojson file
#'
#' @export
#'
#' @param x Path to a local file or a URL.
#' @param ... Further args passed on to \code{\link[rgdal]{readOGR}}
#'
#' @examples \dontrun{
#' # From a file
#' geojson_read("~/zillow_or.geojson")
#'
#' # From a URL
#' url <- "https://gist.githubusercontent.com/sckott/5353e9522a4866729e63/raw/820939552c9dd7cfb7a4dab806e37ee973771533/pleiades245e5de1a252.geojson"
#' geojson_read(url)
#' }

geojson_read <- function(...) UseMethod("geojson_read")

#' @export
#' @rdname geojson_read
geojson_read.character <- function(x, ...) read_geojson(as.location(x), ...)

#' @export
#' @rdname geojson_read
geojson_read.location <- function(x, ...) read_geojson(as.location(x), ...)

read_geojson <- function(x, ...) readOGR(x, ogrListLayers(x), ...)
