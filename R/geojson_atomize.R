#' Atomize
#' 
#' @importFrom jqr jq
#' @export
#' @param x input object, either json or list
#' @return same class as input object, but modified
#' @details outputs valid JSON - when a FeatureCollection is split into 
#' many Feature's, those are put into a JSON array making a valid JSON 
#' object
#' @examples
#' ################# lists 
#' # featurecollection -> features
#' mylist <- list(list(latitude=30, longitude=120, marker="red"),
#'           list(latitude=30, longitude=130, marker="blue"))
#' (x <- geojson_list(mylist))
#' geojson_atomize(x)
#' 
#' # geometrycollection -> geometries
#' mylist <- list(list(latitude=30, longitude=120, marker="red"),
#'           list(latitude=30, longitude=130, marker="blue"))
#' (x <- geojson_list(mylist, type = "GeometryCollection"))
#' geojson_atomize(x)
#' 
#' # sf class
#' library(sf)
#' p1 <- rbind(c(0,0), c(1,0), c(3,2), c(2,4), c(1,4), c(0,0))
#' poly <- rbind(c(1,1), c(1,2), c(2,2), c(1,1))
#' poly_sfg <- st_polygon(list(p1))
#' (x <- geojson_list(poly_sfg))
#' geojson_atomize(x)
#' 
#' ################# json 
#' # featurecollection -> features
#' mylist <- list(list(latitude=30, longitude=120, marker="red"),
#'                list(latitude=30, longitude=130, marker="blue"))
#' (x <- geojson_json(mylist))
#' geojson_atomize(x)
#' 
#' # geometrycollection -> geometries
#' mylist <- list(list(latitude=30, longitude=120, marker="red"),
#'                list(latitude=30, longitude=130, marker="blue"))
#' (x <- geojson_json(mylist, type = "GeometryCollection"))
#' geojson_atomize(x)
#' 
#' # sf class
#' library(sf)
#' p1 <- rbind(c(0,0), c(1,0), c(3,2), c(2,4), c(1,4), c(0,0))
#' poly <- rbind(c(1,1), c(1,2), c(2,2), c(1,1))
#' poly_sfg <- st_polygon(list(p1))
#' (x <- geojson_json(poly_sfg))
#' geojson_atomize(x)
geojson_atomize <- function(x) UseMethod("geojson_atomize")

#' @export
geojson_atomize.default <- function(x) {
  stop("no 'geojson_atomize' method for ", class(x))
}

#' @export
geojson_atomize.geo_json <- function(x) {
  type <- stripjqr(jqr::jq(unclass(x), ".type"))
  keys <- stripjqr(jqr::jq(unclass(x), "keys[]"))
  if (type %in% c('Point', 'MultiPoint', 
                  'Polygon', 'MultiPolygon', 
                  'LineString', 'MultiLineString')) {
    tmp <- jqr::jq(unclass(x), '{ "type": "Feature", "geometry": . }')
  } else {
    if ("features" %in% keys) {
      tmp <- jqr::jq(unclass(x), ".features[]")
    }
    if ("geometries" %in% keys) {
      tmp <- jqr::jq(unclass(x), ".geometries[]")
    }
  }
  structure(jqr::combine(tmp), class = "json")
}

#' @export
geojson_atomize.geo_list <- function(x) {
  if (x$type %in% c('Point', 'MultiPoint', 
                    'Polygon', 'MultiPolygon', 
                    'LineString', 'MultiLineString')) {
    list(type = "Feature", geometry = c(x))
  } else {
    if ("features" %in% names(x)) return(x$features)
    if ("geometries" %in% names(x)) return(x$geometries)
  }
}

stripjqr <- function(x) gsub('\\"', "", unclass(x))
