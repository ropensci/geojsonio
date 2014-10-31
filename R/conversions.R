#' Convert to various sp classes from geojson files
#' 
#' Bla bla
#' 
#' @param x Input.
#' @param ... Further args passed on to \code{\link[rgdal]{readOGR}}
#' @name conversions

#' @export
#' @rdname conversions
as.SpatialPolygonsDataFrame <- function(x, ...) UseMethod("as.SpatialPolygonsDataFrame")

#' @export
#' @rdname conversions
as.SpatialPolygonsDataFrame.geojson <- function(x, ...) {
  readOGR(x$path, "OGRGeoJSON", ...)
}
