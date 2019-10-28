#' Read geojson or other formats from a local file or a URL
#'
#' @export
#' @param x (character) Path to a local file or a URL.
#' @param parse (logical) To parse geojson to data.frame like structures if
#' possible. Default: `FALSE`
#' @param what (character) What to return. One of "list", "sp" (for
#' Spatial class), or "json". Default: "list". "list" "and" sp run through
#' package \pkg{sf}. if "json", returns json as character class
#' @param query (character) A SQL query, see also [postgis]
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
#'
#' - list: geojson as a list using [jsonlite::fromJSON()]
#' - sp: geojson as an sp class object using [sf::st_read()]
#' - json: geojson as character string, to parse downstream as you wish
#'
#' @seealso [topojson_read()], [geojson_write()] [postgis]
#' @examples \dontrun{
#' # From a file
#' file <- system.file("examples", "california.geojson", package = "geojsonio")
#' (out <- geojson_read(file))
#' geojson_read(file)
#'
#' # From a URL
#' url <- "https://raw.githubusercontent.com/glynnbird/usstatesgeojson/master/california.geojson"
#' geojson_read(url)
#' geojson_read(url, parse = TRUE)
#'
#' # Use as.location first if you want
#' geojson_read(as.location(file))
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
#'
#' # from a Postgres database - your Postgres instance must be running
#' ## MAKE SURE to run the setup in the postgis manual file first!
#' if (requireNamespace("DBI") && requireNamespace("RPostgres")) {
#' library(DBI)
#' conn <- tryCatch(dbConnect(RPostgres::Postgres(), dbname = 'postgistest'), 
#'  error = function(e) e)
#' if (inherits(conn, "PqConnection")) {
#'   state <- "SELECT row_to_json(fc)
#'    FROM (SELECT 'FeatureCollection' As type, array_to_json(array_agg(f)) As features
#'    FROM (SELECT 'Feature' As type
#'      , ST_AsGeoJSON(lg.geog)::json As geometry
#'      , row_to_json((SELECT l FROM (SELECT loc_id, loc_name) As l
#'        )) As properties
#'     FROM locations As lg   ) As f )  As fc;"
#'   json <- geojson_read(conn, query = state, what = "json")
#'   map_leaf(json)
#'  }
#' }
#' }
geojson_read <- function(x, parse = FALSE, what = "list",
  stringsAsFactors = FALSE, query = NULL, ...) {
  UseMethod("geojson_read")
}

#' @export
geojson_read.default <- function(x, parse = FALSE, what = "list",
  stringsAsFactors = FALSE, query = NULL, ...) {
  stop("no 'geojson_read' method for ", class(x), call. = FALSE)
}

#' @export
geojson_read.character <- function(x, parse = FALSE, what = "list",
  stringsAsFactors = FALSE, query = NULL, ...) {
  read_json(as.location(x), parse, what, stringsAsFactors, ...)
}

#' @export
geojson_read.location_ <- function(x, parse = FALSE, what = "list",
  stringsAsFactors = FALSE, query = NULL, ...) {
  read_json(x, parse, what, stringsAsFactors, ...)
}

#' @export
geojson_read.PqConnection <- function(x, parse = FALSE,
  what = "list", stringsAsFactors = FALSE, query = NULL, ...) {

  check4pkg("DBI")
  check4pkg("RPostgres")
  tmp <- DBI::dbGetQuery(x, query)
  if (!inherits(tmp, "data.frame")) stop("failure reading from database")
  read_from_sql(unclass(tmp[[1]]), parse, what, stringsAsFactors, ...)
}

# utilities
read_from_sql <- function(x, parse, what, stringsAsFactors = FALSE, ...) {
  what <- match.arg(what, c("list", "sp", "json"))
  switch(what,
    list = jsonlite::fromJSON(x, parse, ...),
    sp = tosp(x, stringsAsFactors, ...),
    json = x
  )
}

read_json <- function(x, parse, what, stringsAsFactors = FALSE, ...) {
  what <- match.arg(what, c("list", "sp", "json"))
  switch(what,
    list = file_to_list(x, stringsAsFactors, parse, ...),
    sp = file_to_sp(x, stringsAsFactors, ...),
    json = stop("what='json' not supported for file and url inputs yet")
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
