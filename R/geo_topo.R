#' GeoJSON to TopoJSON and back
#'
#' @export
#' @param x GeoJSON or TopoJSON as a character string, json, a file path, or 
#' url
#' @param name (character) name to give to the TopoJSON object created. 
#' Default: "foo"
#' @param ... for \code{topo2geo} args passed  on to
#' \code{\link[sf]{st_read}}
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
#' # geojson to topojson as a list
#' x <- list(
#'  '{"type": "LineString", "coordinates": [ [100, 0], [101, 1] ]}',
#'  '{"type": "LineString", "coordinates": [ [110, 0], [110, 1] ]}',
#'  '{"type": "LineString", "coordinates": [ [120, 0], [121, 1] ]}'
#' )
#' geo2topo(x)
#' 
#' # change the object name created
#' x <- '{"type": "LineString", "coordinates": [ [100.0, 0.0], [101.0, 1.0] ]}'
#' geo2topo(x, name = "HelloWorld")
#' geo2topo(x, name = "4")
#' 
#' x <- list(
#'  '{"type": "LineString", "coordinates": [ [100, 0], [101, 1] ]}',
#'  '{"type": "LineString", "coordinates": [ [110, 0], [110, 1] ]}',
#'  '{"type": "LineString", "coordinates": [ [120, 0], [121, 1] ]}'
#' )
#' geo2topo(x, "HelloWorld")
#' geo2topo(x, c("A", "B", "C"))
#' 
#'
#' # topojson to geojson
#' w <- topo2geo(z)
#' jsonlite::prettify(w)
#'
#' ## larger examples
#' file <- system.file("examples", "us_states.topojson", package = "geojsonio")
#' topo2geo(file)
geo2topo <- function(x, name = "foo") {
  UseMethod("geo2topo")
}

#' @export
geo2topo.default <- function(x, name = "foo") {
  stop("no 'geo2topo' method for ", class(x), call. = FALSE)
}

#' @export
geo2topo.character <- function(x, name = "foo") {
  if (!inherits(name, "character")) stop("'name' must be of class character")
  if (length(name) > 1) {
    if (length(x) != length(name)) {
      stop("length of `x` and `name` must be equal, unless `name` length == 1")
    }
    Map(function(z, w) geo_to_topo(unclass(z), w, ...), x, name)
  } else {
    geo_to_topo(x, name)
  }
}

#' @export
geo2topo.json <- function(x, name = "foo") {
  if (!inherits(name, "character")) stop("'name' must be of class character")
  geo_to_topo(unclass(x), name)
}

#' @export
geo2topo.list <- function(x, name = "foo", ...) {
  Map(function(z, w) geo_to_topo(unclass(z), w, ...), x, name)
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
geo_to_topo <- function(x, name) {
  topo$eval(
    sprintf("var output = JSON.stringify(topojson.topology({%s: %s}))", 
      name, x))
  structure(topo$get("output"), class = "json")
}

topo_to_geo <- function(x, ...) {
  # res <- readOGR(x, rgdal::ogrListLayers(x)[1], ...)
  res <- sf::st_read(x, quiet = TRUE, stringsAsFactors = FALSE, ...)
  geojson_json(res)
}
