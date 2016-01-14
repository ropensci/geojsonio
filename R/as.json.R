#' Convert inputs to JSON
#'
#' @export
#' @param x Input
#' @param ... Further args passed on to \code{\link[jsonlite]{toJSON}}
#' @examples \dontrun{
#' (res <- geojson_list(us_cities[1:2,], lat='lat', lon='long'))
#' as.json(res)
#' as.json(res, pretty = TRUE)
#' 
#' vec <- c(-99.74,32.45)
#' as.json(geojson_list(vec))
#' as.json(geojson_list(vec), pretty = TRUE)
#' }
as.json <- function(x, ...) {
  UseMethod("as.json")
}

#' @export
as.json.list <- function(x, ...) to_json(x, ...)

#' @export
as.json.geo_list <- function(x, ...) to_json(unclass(x), ...)

#' @export
as.json.geojson <- function(x, ...) {
  res <- as.SpatialPolygonsDataFrame(x, ...)
  to_json(unclass(spdftogeolist(res)))
}

#' @export
as.json.character <- function(x, ...) {
  res <- as.SpatialPolygonsDataFrame(x, ...)
  to_json(unclass(spdftogeolist(res)))
}
