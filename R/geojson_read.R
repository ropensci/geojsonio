#' Read geojson or other formats from a local file or a URL
#'
#' @export
#' @param x (character) Path to a local file or a URL.
#' @param parse (logical) To parse geojson to data.frame like structures if 
#' possible. Default: `FALSE`
#' @param what (character) What to return. One of "list" or "sp" (for 
#' Spatial class). Default: "list". both options run through package \pkg{sf}
#' @param stringsAsFactors Convert strings to Factors? Default `FALSE`.
#' @param ... Further args passed on to [sf::st_read()]
#' @section Linting GeoJSON:
#' If you're having trouble rendering GeoJSON files, ensure you have a valid
#' GeoJSON file by running it through the package `geojsonlint`, which 
#' has a variety of different GeoJSON linters.
#' @section File size:
#' We previously used [file_to_geojson()] in this function, leading to 
#' file size problems; this should no longer be a concern, but let us know
#' if you run into file size problems
#' @details This function supports various geospatial file formats from a URL,
#' as well as local kml, shp, and geojson file formats.
#' @return various, depending on what's chosen in `what` parameter
#' @seealso [topojson_read()], [geojson_write()]
#' @examples \dontrun{
#' # From a file
#' file <- system.file("examples", "california.geojson", package = "geojsonio")
#' (out <- geojson_read(file))
#'
#' # From a URL
#' url <- "https://raw.githubusercontent.com/glynnbird/usstatesgeojson/master/california.geojson"
#' geojson_read(url)
#' 
#' # Use as.location first if you want
#' geojson_read(as.location(file))
#' 
#' # use jsonlite to parse to data.frame structures where possible
#' geojson_read(url, parse = TRUE)
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
#' x <- "https://raw.githubusercontent.com/johan/world.geo.json/master/countries.geo.json"
#' geojson_read(x, what = "sp")
#' geojson_read(x, what = "list")
#' 
#' utils::download.file(x, destfile = basename(x))
#' geojson_read(basename(x), what = "sp")
#' }
geojson_read <- function(x, parse = FALSE, what = "list", stringsAsFactors = FALSE, ...) {
  UseMethod("geojson_read")
}

#' @export
geojson_read.default <- function(x, parse = FALSE, what = "list", stringsAsFactors = FALSE, ...) { 
  stop("no 'geojson_read' method for ", class(x), call. = FALSE)
}

#' @export
geojson_read.character <- function(x, parse = FALSE, what = "list", stringsAsFactors = FALSE, ...) { 
  read_json(as.location(x), parse, what, stringsAsFactors, ...)
}

#' @export
geojson_read.location_ <- function(x, parse = FALSE, what = "list", stringsAsFactors = FALSE, ...) {
  read_json(x, parse, what, stringsAsFactors, ...)
}

read_json <- function(x, parse, what, stringsAsFactors = FALSE, ...) {
  what <- match.arg(what, c("list", "sp"))
  switch(what, 
    list = file_to_list(x, stringsAsFactors, parse, ...),
    sp = file_to_sp(x, stringsAsFactors, ...)
  )
}

file_to_list <- function(input, stringsAsFactors = FALSE, parse = FALSE, ...) {
  fileext <- ftype(input)
  fileext <- match.arg(fileext, c("shp", "kml", "geojson", "json"))
  input <- handle_remote(input)
  switch(
    fileext,
    kml = tosp_list(input, stringsAsFactors, parse, ...),
    shp = tosp_list(input, stringsAsFactors, parse, ...),
    geojson = tosp_list(input, stringsAsFactors, parse, ...),
    json = tosp_list(input, stringsAsFactors, parse, ...)
  )
}

file_to_sp <- function(input, stringsAsFactors = FALSE, ...) {
  fileext <- ftype(input)
  fileext <- match.arg(fileext, c("shp", "kml", "geojson", "json"))
  input <- handle_remote(input)
  switch(
    fileext, 
    kml = tosp(input, stringsAsFactors, ...),
    shp = tosp(input, stringsAsFactors, ...),
    geojson = tosp(input, stringsAsFactors, ...),
    json = tosp(input, stringsAsFactors, ...)
  )
}

sf2list <- function(x, parse) {
  stopifnot(inherits(x, "sf"))
  tfile <- tempfile(fileext = ".geojson")
  sf::st_write(x, tfile, quiet = TRUE)
  on.exit(unlink(x))
  jsonlite::fromJSON(tfile, parse)
}
