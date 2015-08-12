#' Read geojson or other formats from a local file or a URL
#'
#' @export
#'
#' @param x (character) Path to a local file or a URL.
#' @param method (character) One of "web" (default) or "local". Matches on partial strings.
#' @param parse (logical) To parse geojson to data.frame like structures if possible. 
#' Default: \code{FALSE}
#' @param what (character) What to return. One of "list" or "sp" (for Spatial class). 
#' Default: "list". If "sp" chosen, forced to \code{method="local"}. 
#' @param ... Additional parameters passed to \code{\link[rgdal]{readOGR}}
#' @details Uses \code{\link{file_to_geojson}} internally to give back geojson, 
#' and other helper functions when returning spatial classes.
#' 
#' This function supports various geospatial file formats from a URL, as well as local
#' kml, shp, and geojson file formats.
#'
#' @examples \dontrun{
#' # From a file
#' file <- system.file("examples", "california.geojson", package = "geojsonio")
#' out <- geojson_read(file)
#'
#' # From a URL
#' url <- "https://raw.githubusercontent.com/glynnbird/usstatesgeojson/master/california.geojson"
#' geojson_read(url, method = "local")
#' 
#' # Use as.location first if you want
#' geojson_read(as.location(file))
#' 
#' # use jsonlite to parse to data.frame structures where possible
#' geojson_read(url, method = "local", parse = TRUE)
#' 
#' # output a SpatialClass object
#' ## read kml
#' file <- system.file("examples", "norway_maple.kml", package = "geojsonio")
#' geojson_read(as.location(file), what = "sp")
#' ## read geojson
#' file <- system.file("examples", "california.geojson", package = "geojsonio")
#' geojson_read(as.location(file), what = "sp")
#' ## read geojson from a url
#' url <- "https://raw.githubusercontent.com/glynnbird/usstatesgeojson/master/california.geojson"
#' geojson_read(url, what = "sp")
#' ## read from a shape file
#' file <- system.file("examples", "bison.zip", package = "geojsonio")
#' dir <- tempdir()
#' unzip(file, exdir = dir)
#' shpfile <- list.files(dir, pattern = ".shp", full.names = TRUE)
#' geojson_read(shpfile, what = "sp")
#' 
#' # doesn't work right now
#' ## file <- system.file("examples", "feature_collection.geojson", package = "geojsonio")
#' ## geojson_read(file, what = "sp")
#' }
geojson_read <- function(x, method = "web", parse = FALSE, what = "list", ...) {
  UseMethod("geojson_read")
}

#' @export
geojson_read.character <- function(x, method = "web", parse = FALSE, what = "list", ...) { 
  read_json(as.location(x), method, parse, what, ...)
}

#' @export
geojson_read.location <- function(x, method = "web", parse = FALSE, what = "list", ...) {
  read_json(x, method, parse, what, ...)
}

read_json <- function(x, method, parse, what, ...) {
  what <- match.arg(what, c("list", "sp"))
  switch(what, 
         list = file_to_geojson(x, method, output = ":memory:", parse, ...), 
         sp = file_to_sp(x, ...)
  )
}

file_to_sp <- function(input, output = ".", ...) {
  fileext <- ftype(input)
  fileext <- match.arg(fileext, c("shp", "kml", "url", "geojson"))
  mem <- ifelse(output == ":memory:", TRUE, FALSE)
  output <- ifelse(output == ":memory:", tempfile(), output)
  output <- path.expand(output)
  switch(fileext, 
      kml = rgdal::readOGR(input, rgdal::ogrListLayers(input)[1], 
                       drop_unsupported_fields = TRUE, verbose = FALSE, ...),
      # shp = maptools::readShapeSpatial(input),
      shp = rgdal::readOGR(input, rgdal::ogrListLayers(input), verbose = FALSE, ...),
      url = rgdal::readOGR(input, rgdal::ogrListLayers(input), verbose = FALSE, ...),
      geojson = rgdal::readOGR(input, rgdal::ogrListLayers(input), verbose = FALSE, ...)
  )
}
