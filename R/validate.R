#' Validate a geoJSON file
#' 
#' @name validate
#' @param input Input list, data.frame, or spatial class. Inputs can also be dplyr \code{tbl_df}
#' class since it inherits from \code{data.frame}.
#' @param ... Ignored
#'
#' @examples \dontrun{
#' # A file
#' file <- system.file("examples", "zillow_or.geojson", package = "togeojson")
#' validate(x = as.location(file))
#'
#' # A URL
#' url <- "https://raw.githubusercontent.com/glynnbird/usstatesgeojson/master/california.geojson"
#' validate(as.location(url))
#'
#' # From output of geojson_list
#' library("maps")
#' data(us.cities)
#' (x <- geojson_list(us.cities[1:2,], lat='lat', lon='long'))
#' validate(x)
#'
#' # From output of geojson_json
#' library('maps')
#' data(us.cities)
#' (x <- geojson_json(us.cities[1:2,], lat='lat', lon='long'))
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
#' @rdname validate
validate <- function(x, ...) UseMethod("validate")

#' @export
#' @rdname validate
validate.location <- function(x, ...){
  res <- switch(attr(x, "type"),
                file = POST(v_url(), body=upload_file(x[[1]])),
                url = GET(v_url(), query=list(url = x[[1]])))
  stop_for_status(res)
  content(res)
}

#' @export
#' @rdname validate
validate.geo_list <- function(x, ...){
  val_fxn(x)
}

#' @export
#' @rdname validate
validate.json <- function(x, ...){
  val_fxn(x)
}

#' @export
#' @rdname validate
validate.SpatialPolygons <- function(x, ...) validate(geojson_list(x))

#' @export
#' @rdname validate
validate.SpatialPolygonsDataFrame <- function(x, ...) validate(geojson_list(x))

#' @export
#' @rdname validate
validate.SpatialPoints <- function(x, ...) validate(geojson_list(x))

#' @export
#' @rdname validate
validate.SpatialPointsDataFrame <- function(x, ...) validate(geojson_list(x))

#' @export
#' @rdname validate
validate.SpatialLines <- function(x, ...) validate(geojson_list(x))

#' @export
#' @rdname validate
validate.SpatialLinesDataFrame <- function(x, ...) validate(geojson_list(x))

#' @export
#' @rdname validate
validate.SpatialGrid <- function(x, ...) validate(geojson_list(x))

#' @export
#' @rdname validate
validate.SpatialGridDataFrame <- function(x, ...) validate(geojson_list(x))

#' @export
#' @rdname validate
validate.numeric <- function(x, ...) validate(geojson_list(x))

#' @export
#' @rdname validate
validate.data.frame <- function(x, ...) validate(geojson_list(x))

#' @export
#' @rdname validate
validate.list <- function(x, ...) validate(geojson_list(x))

val_fxn <- function(x){
  file <- tempfile(fileext = ".geojson")
  suppressMessages(geojson_write(x, file=file))
  res <- POST(v_url(), body=upload_file(file))
  stop_for_status(res)
  content(res)
}

v_url <- function() 'http://geojsonlint.com/validate'
