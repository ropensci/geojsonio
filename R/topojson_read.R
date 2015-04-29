#' Read topojson from a local file or a URL
#'
#' @export
#'
#' @param x Path to a local file or a URL.
#' @param ... Further args passed on to \code{\link[rgdal]{readOGR}}
#' 
#' @return A Spatial Class, varies depending on input
#' 
#' @details Returns a Spatial class (e.g., SpatialPolygonsDataFrame), but 
#' you can easily and quickly get this to geojson, see examples
#'
#' @examples \dontrun{
#' # From a file
#' file <- system.file("examples", "us_states.topojson", package = "geojsonio")
#' topojson_read(file)
#'
#' # From a URL
#' url <- "https://raw.githubusercontent.com/shawnbot/d3-cartogram/master/data/us-states.topojson"
#' topojson_read(url)
#'
#' # Use as.location first if you want
#' topojson_read(as.location(file))
#' 
#' # quickly convert to geojson as a list
#' file <- system.file("examples", "us_states.topojson", package = "geojsonio")
#' tmp <- topojson_read(file)
#' geojson_list(tmp)
#' }

topojson_read <- function(x, ...) {
  UseMethod("topojson_read")
}

#' @export
topojson_read.character <- function(x, ...) {
  read_topojson(x, ...)
}

#' @export
topojson_read.location <- function(x, ...) {
  read_topojson(x, ...)
}

read_topojson <- function(x, ...) {
  x <- path.expand(x)
  stopifnot(ftype(x) == "topojson" || ftype(x) == "url")
  my_layer <- ogrListLayers(x)
  readOGR(x, layer = my_layer[1], drop_unsupported_fields = TRUE, ...)
}
