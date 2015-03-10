#' Convert inputs to JSON
#'
#' @export
#' @param x Input
#' @param ... Further args passed on to \code{\link[jsonlite]{toJSON}}
as.json <- function(x, ...) UseMethod("as.json")

#' @export
as.json.geo_list <- function(x, ...) to_json(unclass(x), ...)

#' @export
as.json.geojson <- function(x, ...) {
  res <- as.SpatialPolygonsDataFrame(x, ...)
  to_json(spdftogeolist(res))
}

#' @export
as.json.character <- function(x, ...) {
  res <- as.SpatialPolygonsDataFrame(x, ...)
  to_json(spdftogeolist(res))
}
