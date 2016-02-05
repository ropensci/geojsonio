#' Validate a geoJSON file, json object, list, or Spatial class.
#'
#' @name validate
#' @param x Input list, data.frame, or spatial class. Inputs can also be dplyr \code{tbl_df}
#' class since it inherits from \code{data.frame}.
#' @param ... Further args passed on to helper functions.
#'
#' @details Uses the web service at \url{http://geojsonlint.com/}
#'
#' @examples \dontrun{
#' # From a json character string
#' validate(x = '{"type": "Point", "coordinates": [-100, 80]}') # good
#' validate(x = '{"type": "Rhombus", "coordinates": [[1, 2], [3, 4], [5, 6]]}') # bad
#'
#' # A file
#' file <- system.file("examples", "zillow_or.geojson", package = "geojsonio")
#' validate(x = as.location(file))
#'
#' # A URL
#' url <- "https://raw.githubusercontent.com/glynnbird/usstatesgeojson/master/california.geojson"
#' validate(as.location(url))
#'
#' # From output of geojson_list
#' (x <- geojson_list(us_cities[1:2,], lat='lat', lon='long'))
#' validate(x)
#'
#' # From output of geojson_json
#' (x <- geojson_json(us_cities[1:2,], lat='lat', lon='long'))
#' validate(x)
#'
#' # From a list turned into geo_list
#' mylist <- list(list(latitude=30, longitude=120, marker="red"),
#'                list(latitude=30, longitude=130, marker="blue"))
#' x <- geojson_list(mylist)
#' class(x)
#' validate(x)
#'
#' # From SpatialPoints class
#' library("sp")
#' a <- c(1,2,3,4,5)
#' b <- c(3,2,5,1,4)
#' (x <- SpatialPoints(cbind(a,b)))
#' class(x)
#' validate(x)
#' }

#' @export
validate <- function(x, ...) {
  UseMethod("validate")
}

#' @export
validate.character <- function(x, ...){
  if (!jsonlite::validate(x)) stop("invalid json string", call. = FALSE)
  res <- POST(v_url(), body = x)
  stop_for_status(res)
  jsonlite::fromJSON(content(res, "text", encoding = "UTF-8"))
}

#' @export
validate.location <- function(x, ...){
  res <- switch(attr(x, "type"),
                file = POST(v_url(), body = upload_file(x[[1]])),
                url = GET(v_url(), query = list(url = x[[1]])))
  stop_for_status(res)
  jsonlite::fromJSON(content(res, "text", encoding = "UTF-8"))
}

#' @export
validate.geo_list <- function(x, ...){
  val_fxn(x)
}

#' @export
validate.json <- function(x, ...){
  val_fxn(x)
}

#' @export
validate.SpatialPolygons <- function(x, ...) validate(geojson_list(x))

#' @export
validate.SpatialPolygonsDataFrame <- function(x, ...) validate(geojson_list(x))

#' @export
validate.SpatialPoints <- function(x, ...) validate(geojson_list(x))

#' @export
validate.SpatialPointsDataFrame <- function(x, ...) validate(geojson_list(x))

#' @export
validate.SpatialLines <- function(x, ...) validate(geojson_list(x))

#' @export
validate.SpatialLinesDataFrame <- function(x, ...) validate(geojson_list(x))

#' @export
validate.SpatialGrid <- function(x, ...) validate(geojson_list(x))

#' @export
validate.SpatialGridDataFrame <- function(x, ...) validate(geojson_list(x))

#' @export
validate.numeric <- function(x, ...) validate(geojson_list(x))

#' @export
validate.data.frame <- function(x, ...) validate(geojson_list(x, ...))

#' @export
validate.list <- function(x, ...) validate(geojson_list(x))

val_fxn <- function(x){
  file <- tempfile(fileext = ".geojson")
  suppressMessages(geojson_write(x, file = file))
  res <- POST(v_url(), body = upload_file(file))
  stop_for_status(res)
  jsonlite::fromJSON(content(res, "text", encoding = "UTF-8"))
}

v_url <- function() 'http://geojsonlint.com/validate'
