#' Atomize
#'
#' @importFrom jqr jq
#' @export
#' @param x (geo_list/geo_json/json/character) input object, either
#' `geo_json`, `geo_list`, `json`, or `character` class.
#' If \code{character}, must be valid JSON
#' @param combine (logical) only applies to `geo_json/json` type inputs.
#' combine valid JSON objects into a single valid JSON object. Default:
#' `TRUE`
#'
#' @return same class as input object, but modified
#'
#' @details A FeatureCollection is split into many Feature's, and
#' a GeometryCollection is split into many geometries
#'
#' Internally we use \pkg{jqr} for JSON parsing
#'
#' @examples
#' ################# lists
#' # featurecollection -> features
#' mylist <- list(
#'   list(latitude = 30, longitude = 120, marker = "red"),
#'   list(latitude = 30, longitude = 130, marker = "blue")
#' )
#' (x <- geojson_list(mylist))
#' geojson_atomize(x)
#'
#' # geometrycollection -> geometries
#' mylist <- list(
#'   list(latitude = 30, longitude = 120, marker = "red"),
#'   list(latitude = 30, longitude = 130, marker = "blue")
#' )
#' (x <- geojson_list(mylist, type = "GeometryCollection"))
#' geojson_atomize(x)
#'
#' # sf class
#' library(sf)
#' p1 <- rbind(c(0, 0), c(1, 0), c(3, 2), c(2, 4), c(1, 4), c(0, 0))
#' poly <- rbind(c(1, 1), c(1, 2), c(2, 2), c(1, 1))
#' poly_sfg <- st_polygon(list(p1))
#' (x <- geojson_list(poly_sfg))
#' geojson_atomize(x)
#'
#' ################# json
#' # featurecollection -> features
#' mylist <- list(
#'   list(latitude = 30, longitude = 120, marker = "red"),
#'   list(latitude = 30, longitude = 130, marker = "blue")
#' )
#' (x <- geojson_json(mylist))
#' geojson_atomize(x)
#' geojson_atomize(x, FALSE)
#'
#' # geometrycollection -> geometries
#' mylist <- list(
#'   list(latitude = 30, longitude = 120, marker = "red"),
#'   list(latitude = 30, longitude = 130, marker = "blue")
#' )
#' (x <- geojson_json(mylist, type = "GeometryCollection"))
#' geojson_atomize(x)
#' geojson_atomize(x, FALSE)
#'
#' # sf class
#' library(sf)
#' nc <- st_read(system.file("shape/nc.shp", package = "sf"), quiet = TRUE)
#' (x <- geojson_json(nc))
#' geojson_atomize(x)
#' geojson_atomize(x, FALSE)
#'
#' ################# character
#' # featurecollection -> features
#' mylist <- list(
#'   list(latitude = 30, longitude = 120, marker = "red"),
#'   list(latitude = 30, longitude = 130, marker = "blue")
#' )
#' (x <- geojson_json(mylist))
#' geojson_atomize(unclass(x))
geojson_atomize <- function(x, combine = TRUE) UseMethod("geojson_atomize")

#' @export
geojson_atomize.default <- function(x, combine = TRUE) {
  stop("no 'geojson_atomize' method for ", class(x))
}

#' @export
geojson_atomize.geo_json <- function(x, combine = TRUE) {
  geojson_atomize(unclass(x), combine = combine)
}

#' @export
geojson_atomize.character <- function(x, combine = TRUE) {
  if (!jsonlite::validate(x)) stop("'x' not valid JSON")
  geojson_atomize(structure(x, class = "json"), combine = combine)
}

#' @export
geojson_atomize.json <- function(x, combine = TRUE) {
  type <- stripjqr(jqr::jq(unclass(x), ".type"))
  keys <- stripjqr(jqr::jq(unclass(x), "keys[]"))
  if (type %in% c(
    "Point", "MultiPoint",
    "Polygon", "MultiPolygon",
    "LineString", "MultiLineString"
  )) {
    tmp <- jqr::jq(unclass(x), '{ "type": "Feature", "geometry": . }')
  } else {
    if ("features" %in% keys) {
      tmp <- jqr::jq(unclass(x), ".features[]")
    }
    if ("geometries" %in% keys) {
      tmp <- jqr::jq(unclass(x), ".geometries[]")
    }
  }
  structure(if (combine) jqr::combine(tmp) else tmp, class = "json")
}

#' @export
geojson_atomize.geo_list <- function(x, combine = TRUE) {
  if (x$type %in% c(
    "Point", "MultiPoint",
    "Polygon", "MultiPolygon",
    "LineString", "MultiLineString"
  )) {
    list(type = "Feature", geometry = c(x))
  } else {
    if ("features" %in% names(x)) {
      return(x$features)
    }
    if ("geometries" %in% names(x)) {
      return(x$geometries)
    }
  }
}

stripjqr <- function(x) gsub('\\"', "", unclass(x))
