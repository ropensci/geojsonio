#' GeoJSON to TopoJSON and back
#' 
#' TopoJSON to GeoJSON not quite working yet.
#'
#' @export
#' @param x geojson or topojson as a character string, or form a file, or url
#' @param ... ignored
#' @return A character string of either GeoJSON or TopoJSON
#' @examples
#' # geojson to topojson
#' x <- '{"type": "LineString", "coordinates": [ [100.0, 0.0], [101.0, 1.0] ]}'
#' cat(geo2topo(x))
geo2topo <- function(x, ...) {
  UseMethod("geo2topo")
}

#' @export
geo2topo.default <- function(x, ...) {
  stop("no 'geo2topo' method for ", class(x), call. = FALSE)
}

#' @export
geo2topo.character <- function(x, ...) {
  geo_to_topo(x)
}

#' @export
#' @rdname geo2topo
topo2geo <- function(x, ...) {
  UseMethod("topo2geo")
}

#' @export
#' @rdname geo2topo
topo2geo.default <- function(x, ...) {
  stop("not working yet", call. = FALSE)
  # stop("no 'topo2geo' method for ", class(x), call. = FALSE)
}

#' @export
#' @rdname geo2topo
topo2geo.character <- function(x, ...) {
  stop("not working yet", call. = FALSE)
  # topo2geo(x)
}

# helpers  --------------------------
geo_to_topo <- function(x) {
  topo$eval(sprintf("var output = JSON.stringify(topojson.topology(%s))", x))
  topo$get("output")
}

# topo2geo <- function(x) {
#   ff <- tempfile(fileext = ".json")
#   paste0(readLines(topojson_write(x, ff)), collapse = "")
# }
