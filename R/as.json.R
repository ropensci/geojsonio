#' Convert inputs to JSON
#'
#' @export
#' @param x Input
#' @param ... Further args passed on to [jsonlite::toJSON()]
#' @details when the output of [topojson_list()] is given to 
#' this function we use a special internal fxn `astjl()` to
#' parse the object - see that fxn and let us know if any
#' problems you run in to
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
as.json.list <- function(x, ...) {
  if ("arcs" %in% names(x)) return(astjl(x))
  to_json(x, ...)
}

#' @export
as.json.geo_list <- function(x, ...) to_json(unclass(x), ...)

#' @export
as.json.geojson_file <- function(x, ...) {
  res <- as.SpatialPolygonsDataFrame(x, ...)
  to_json(unclass(spdftogeolist(res)), ...)
}

#' @export
as.json.character <- function(x, ...) {
  res <- as.SpatialPolygonsDataFrame(x, ...)
  to_json(unclass(spdftogeolist(res)), ...)
}

astjl <- function(x) {
  for (i in seq_along(x$objects[[1]]$geometries)) {
    if ('arcs' %in% names(x$objects[[1]]$geometries[[i]])) {
      x$objects[[1]]$geometries[[i]]$arcs <- 
        jsonlite::toJSON(x$objects[[1]]$geometries[[i]]$arcs,
          digits = 7, auto_unbox = FALSE, force = TRUE)
    }
  }
  jsonlite::toJSON(x, digits = 7, auto_unbox = TRUE, force = TRUE,
    json_verbatim = TRUE)
}
