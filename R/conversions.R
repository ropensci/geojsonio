#' Convert to various sp classes from geojson files
#' 
#' @export
#' @param x Input.
#' @param ... Further args passed on to \code{\link[rgdal]{readOGR}}
as.SpatialPolygonsDataFrame <- function(x, ...) UseMethod("as.SpatialPolygonsDataFrame")

#' @export
as.SpatialPolygonsDataFrame.geojson <- function(x, ...) {
  readOGR(x$path, "OGRGeoJSON", ...)
}

#' @export
as.SpatialPolygonsDataFrame.character <- function(x, ...) {
  readOGR(x, "OGRGeoJSON", ...)
}
