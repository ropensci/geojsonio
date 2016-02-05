#' Lint geojson
#'
#' @importFrom jsonlite minify
#' @export
#'
#' @param x Input, a geojson character string or list
#' @param ... Further args passed on to helper functions.
#'
#' @examples \dontrun{
#' lint('{"type": "FooBar"}')
#' lint('{ "type": "FeatureCollection" }')
#' lint('{"type":"Point","geometry":{"type":"Point","coordinates":[-80,40]},"properties":{}}')
#'
#' # From a list turned into geo_list
#' mylist <- list(list(latitude=30, longitude=120, marker="red"),
#'                list(latitude=30, longitude=130, marker="blue"))
#' x <- geojson_list(mylist)
#' class(x)
#' lint(x)
#'
#' # A file
#' file <- system.file("examples", "zillow_or.geojson", package = "geojsonio")
#' lint(as.location(file))
#'
#' # A URL
#' url <- "https://raw.githubusercontent.com/glynnbird/usstatesgeojson/master/california.geojson"
#' lint(as.location(url))
#'
#' # from json (jsonlite class)
#' x <- jsonlite::minify('{ "type": "FeatureCollection" }')
#' class(x)
#' lint(x)
#'
#' # From SpatialPoints class
#' library("sp")
#' a <- c(1,2,3,4,5)
#' b <- c(3,2,5,1,4)
#' (x <- SpatialPoints(cbind(a,b)))
#' class(x)
#' lint(x)
#'
#' # From a data.frame
#' ## need to specify what columns are lat and long with a data.frame
#' lint(us_cities[1:2,], lat='lat', lon='long')
#'
#' # From numeric
#' vec <- c(32.45,-99.74)
#' lint(vec)
#' 
#' # From a list
#' mylist <- list(list(latitude=30, longitude=120, marker="red"),
#'                list(latitude=30, longitude=130, marker="blue"))
#' lint(mylist)
#' }
lint <- function(x, ...) {
  UseMethod("lint")
}

#' @export
lint.character <- function(x, ...) {
  if ( !jsonlite::validate(x) ) stop("invalid json string")
  lintit(x)
}

#' @export
lint.geo_list <- function(x, ...){
  lintit(jsonlite::toJSON(unclass(x), auto_unbox = TRUE))
}

#' @export
lint.location <- function(x, ...){
  res <- switch(attr(x, "type"),
                file = paste0(readLines(x), collapse = ""),
                url = minify(content(GET(x), "text", encoding = "UTF-8")))
  lintit(res)
}

#' @export
lint.list <- function(x, ...) {
  # lintit(toJSON(x, auto_unbox = TRUE))
  lint(geojson_list(x, ...))
}

#' @export
lint.json <- function(x, ...){
  lintit(x)
}

#' @export
lint.SpatialPolygons <- function(x, ...) lint(geojson_list(x))

#' @export
lint.SpatialPolygonsDataFrame <- function(x, ...) lint(geojson_list(x))

#' @export
lint.SpatialPoints <- function(x, ...) lint(geojson_list(x))

#' @export
lint.SpatialPointsDataFrame <- function(x, ...) lint(geojson_list(x))

#' @export
lint.SpatialLines <- function(x, ...) lint(geojson_list(x))

#' @export
lint.SpatialLinesDataFrame <- function(x, ...) lint(geojson_list(x))

#' @export
lint.SpatialGrid <- function(x, ...) lint(geojson_list(x))

#' @export
lint.SpatialGridDataFrame <- function(x, ...) lint(geojson_list(x))

#' @export
lint.numeric <- function(x, ...) lint(geojson_list(x))

#' @export
lint.data.frame <- function(x, ...) lint(geojson_list(x, ...))

# helper fxn
lintit <- function(x) {
  ct$assign("x", minify(x))
  ct$eval("var out = geojsonhint.hint(x);")
  tmp <- as.list(ct$get("out"))
  if (identical(tmp, list())) {
    return("valid")
  } else {
    tmp
  }
}

# Examples -------------------------------

# # from lincoln
# x <- '{"type":"Point","geometry":{"type":"Point","coordinates":[-80,40]},"properties":{}}'
#
# # bad
# x <- '{
# "type": "Point",
# "coordinates": [2, 2],
# "bbox": [1, 2, "string"]
# }'
#
# # bad, fails on minify() call i think cause bad json
# x <- '{
# "type": "MultiPoint"
# "coordinates": [["foo", "bar"]]
# }'
#
# # bad
# x <- '{
# "type": "FooBar"
# }'
#
# # bad
# x <- '{ "type": "FeatureCollection" }'
#
# # bad
# x <- '{
# "type": "Point",
# "coordinates": [2]
# }'
#
# # good
# x <- '{
# "type": "Feature",
# "id": 100,
# "geometry": {"type": "Point", "coordinates": [102.0, 0.5]},
# "properties": {"prop0": "value0"}
# }'
#
# # good
# x <- '{ "type": "FeatureCollection",
# "features": [
# { "type": "Feature",
# "geometry": {"type": "Point", "coordinates": [102.0, 0.5]},
# "properties": {"prop0": "value0"}
# },
# { "type": "Feature",
# "geometry": {
# "type": "LineString",
# "coordinates": [
# [102.0, 0.0], [103.0, 1.0], [104.0, 0.0], [105.0, 1.0]
# ]
# },
# "properties": {
# "prop0": "value0",
# "prop1": 0.0
# }
# },
# { "type": "Feature",
# "geometry": {
# "type": "Polygon",
# "coordinates": [
# [ [100.0, 0.0], [101.0, 0.0], [101.0, 1.0],
# [100.0, 1.0], [100.0, 0.0] ]
# ]
# },
# "properties": {
# "prop0": "value0",
# "prop1": {"this": "that"}
# }
# }
# ]
# }'
