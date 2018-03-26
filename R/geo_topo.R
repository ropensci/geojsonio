#' GeoJSON to TopoJSON and back
#'
#' @export
#' @param x GeoJSON or TopoJSON as a character string, json, a file path, or 
#' url
#' @param object_name (character) name to give to the TopoJSON object created. 
#' Default: "foo"
#' @param ... for \code{geo2topo} args passed  on to
#' \code{\link[jsonlite]{fromJSON}}, and for \code{topo2geo} args passed  on to
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
#' geo2topo(x, object_name = "HelloWorld")
#' geo2topo(x, object_name = "4")
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
geo2topo <- function(x, object_name = "foo", ...) {
  UseMethod("geo2topo")
}

#' @export
geo2topo.default <- function(x, object_name = "foo", ...) {
  stop("no 'geo2topo' method for ", class(x), call. = FALSE)
}

#' @export
geo2topo.character <- function(x, object_name = "foo", ...) {
  if (!inherits(object_name, "character")) stop("'object_name' must be of class character")
  if (length(object_name) > 1) {
    if (length(x) != length(object_name)) {
      stop("length of `x` and `object_name` must be equal, unless `object_name` length == 1")
    }
    Map(function(z, w) geo_to_topo(unclass(z), w, ...), x, object_name)
  } else {
    geo_to_topo(x, object_name)
  }
}

#' @export
geo2topo.json <- function(x, object_name = "foo", ...) {
  if (!inherits(object_name, "character")) 
    stop("'object_name' must be of class character")
  geo_to_topo(unclass(x), object_name, ...)
}

#' @export
geo2topo.list <- function(x, object_name = "foo", ...) {
  Map(function(z, w) geo_to_topo(unclass(z), w, ...), x, object_name)
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
geo_to_topo <- function(x, object_name, ...) {
  topo$eval(
    sprintf("var output = JSON.stringify(topojson.topology({%s: %s}))", 
      object_name, x))
  structure(topo$get("output"), class = "json")
}

topo_to_geo <- function(x, ...) {
  res <- sf::st_read(x, quiet = TRUE, stringsAsFactors = FALSE, ...)
  geojson_json(res)
}
