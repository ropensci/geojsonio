#' GeoJSON to TopoJSON and back
#'
#' @export
#' @param x GeoJSON or TopoJSON as a character string, json, a file path, or
#' url
#' @param object_name (character) name to give to the TopoJSON object created.
#' Default: "foo"
#' @param quantization (numeric) quantization parameter, use this to
#' quantize geometry prior to computing topology. Typical values are powers of
#' ten (`1e4`, `1e5`, ...), default is `0` to not perform quantization.
#' For more information about quantization, see this by Mike Bostock
#' https://stackoverflow.com/questions/18900022/topojson-quantization-vs-simplification/18921214#18921214
#' @param ... for `geo2topo` args passed  on to
#' [jsonlite::fromJSON()], and for `topo2geo` args passed  on to
#' [sf::st_read()]
#' @return An object of class `json`, of either GeoJSON or TopoJSON
#' @seealso [topojson_write()], [topojson_read()]
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
#'   '{"type": "LineString", "coordinates": [ [100, 0], [101, 1] ]}',
#'   '{"type": "LineString", "coordinates": [ [110, 0], [110, 1] ]}',
#'   '{"type": "LineString", "coordinates": [ [120, 0], [121, 1] ]}'
#' )
#' geo2topo(x)
#'
#' # change the object name created
#' x <- '{"type": "LineString", "coordinates": [ [100.0, 0.0], [101.0, 1.0] ]}'
#' geo2topo(x, object_name = "HelloWorld")
#' geo2topo(x, object_name = "4")
#'
#' x <- list(
#'   '{"type": "LineString", "coordinates": [ [100, 0], [101, 1] ]}',
#'   '{"type": "LineString", "coordinates": [ [110, 0], [110, 1] ]}',
#'   '{"type": "LineString", "coordinates": [ [120, 0], [121, 1] ]}'
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
geo2topo <- function(x, object_name = "foo", quantization = 0, ...) {
  UseMethod("geo2topo")
}

#' @export
geo2topo.default <- function(x, object_name = "foo", quantization = 0, ...) {
  stop("no 'geo2topo' method for ", class(x), call. = FALSE)
}

#' @export
geo2topo.character <- function(x, object_name = "foo", quantization = 0, ...) {
  if (!inherits(object_name, "character")) stop("'object_name' must be of class character")
  if (length(object_name) > 1) {
    if (length(x) != length(object_name)) {
      stop("length of `x` and `object_name` must be equal, unless `object_name` length == 1")
    }
    Map(function(z, w) geo_to_topo(unclass(z), w, ...), x, object_name, quantization)
  } else {
    geo_to_topo(x, object_name, quantization)
  }
}

#' @export
geo2topo.json <- function(x, object_name = "foo", quantization = 0, ...) {
  if (!inherits(object_name, "character")) {
    stop("'object_name' must be of class character")
  }
  geo_to_topo(unclass(x), object_name, quantization, ...)
}

#' @export
geo2topo.list <- function(x, object_name = "foo", quantization = 0, ...) {
  Map(function(z, w, q) geo_to_topo(unclass(z), w, q, ...), x, object_name, quantization)
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
geo_to_topo <- function(x, object_name, quantization = 0, ...) {
  topo$eval(
    sprintf(
      "var output = JSON.stringify(topojson.topology({%s: %s}, %s))",
      object_name, x, quantization
    )
  )
  structure(topo$get("output"), class = "json")
}

topo_to_geo <- function(x, ...) {
  res <- tosf(x, stringsAsFactors = FALSE, ...)
  geojson_json(res)
}
