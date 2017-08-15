#' GeoJSON to TopoJSON and back
#' 
#' @export
#' @param x GeoJSON or TopoJSON as a character string, json, a file path, or url
#' @param ... for \code{topo2geo} args passed  on to 
#' \code{\link[rgdal]{readOGR}}
#' @return An object of class \code{json}, of either GeoJSON or TopoJSON
#' @seealso \code{\link{topojson_write}}, \code{\link{topojson_read}}
#' @examples
#' # geojson to topojson
#' x <- '{"type": "LineString", "coordinates": [ [100.0, 0.0], [101.0, 1.0] ]}'
#' z <- geo2topo(x)
#' jsonlite::prettify(z)
#' \dontrun{
#' library(leaflet)
#' leaflet() %>% 
#'   addProviderTiles(provider = "Stamen.Terrain") %>% 
#'   addTopoJSON(z)
#' }
#' 
#' # topojson to geojson
#' w <- topo2geo(z)
#' jsonlite::prettify(w)
#' 
#' ## larger examples
#' file <- system.file("examples", "us_states.topojson", package = "geojsonio")
#' topo2geo(file)
geo2topo <- function(x) {
  UseMethod("geo2topo")
}

#' @export
geo2topo.default <- function(x) {
  stop("no 'geo2topo' method for ", class(x), call. = FALSE)
}

#' @export
geo2topo.character <- function(x) {
  geo_to_topo(x)
}

#' @export
geo2topo.json <- function(x) {
  geo_to_topo(unclass(x))
}

#' @export
#' @rdname geo2topo
topo2geo <- function(x, ...) {
  UseMethod("topo2geo")
}

#' @export
topo2geo.default <- function(x, ...) {
  stop("no 'topo2geo' method for ", class(x), call. = FALSE)
}

#' @export
topo2geo.character <- function(x, ...) {
  topo_to_geo(x, ...)
}

#' @export
topo2geo.json <- function(x, ...) {
  topo_to_geo(unclass(x), ...)
}

# helpers  --------------------------
geo_to_topo <- function(x) {
  topo$eval(sprintf("var output = JSON.stringify(topojson.topology({foo: %s}))", x))
  structure(topo$get("output"), class = "json")
}

topo_to_geo <- function(x, ...) {
  res <- readOGR(x, rgdal::ogrListLayers(x)[1], ...)
  geojson_json(res)
}
