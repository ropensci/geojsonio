#' Read geojson or other formats from a local file or a URL
#'
#' @export
#'
#' @param x (character) Path to a local file, a URL, or a database connection
#' of class \code{PqConnection} (a PostgreSQL connection)
#' @param what (character) What to return. One of "list", "sp" (for
#' Spatial class), or "json". Default: "list". If "sp" chosen, forced to
#' \code{method="local"}. if "json", returns json as character class
#' @param query (character) A SQL query
#' @template read
#'
#' @seealso \code{\link{topojson_read}}, \code{\link{geojson_write}},
#' \code{\link{postgis}}
#'
#' @return various, depending on what's chosen in \code{what} parameter:
#' 
#' \itemize{
#'  \item list: geojson as a list using \code{jsonlite::fromJSON}
#'  \item sp: geojson as an sp class object using \code{rgdal::readOGR}
#'  \item json: geojson as character string, to parse downstream as you wish
#' }
#'
#' @details Uses \code{\link{file_to_geojson}} internally to give back geojson,
#' and other helper functions when returning spatial classes.
#'
#' This function supports various geospatial file formats from a URL, as well
#' as local kml, shp, and geojson file formats.
#'
#' @examples \dontrun{
#' # From a file
#' file <- system.file("examples", "california.geojson", package = "geojsonio")
#' (out <- geojson_read(file))
#' geojson_read(file, what = "json")
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
#' x <- "https://raw.githubusercontent.com/johan/world.geo.json/master/countries.geo.json"
#' geojson_read(x, method = "local", what = "sp")
#' geojson_read(x, method = "local", what = "list")
#'
#' utils::download.file(x, destfile = basename(x))
#' geojson_read(basename(x), method = "local", what = "sp")
#' 
#' # from a Postgres database - your Postgres instance must be running
#' if (requireNamespace("DBI") && requireNamespace("RPostgres")) {
#' library(DBI)
#' conn <- dbConnect(RPostgres::Postgres(), dbname = 'postgistest')
#' state <- "SELECT row_to_json(fc)
#'  FROM (SELECT 'FeatureCollection' As type, array_to_json(array_agg(f)) As features
#'  FROM (SELECT 'Feature' As type
#'     , ST_AsGeoJSON(lg.geog)::json As geometry
#'     , row_to_json((SELECT l FROM (SELECT loc_id, loc_name) As l
#'       )) As properties
#'    FROM locations As lg   ) As f )  As fc;"
#' json <- geojson_read(conn, query = state, what = "json")
#' map_leaf(json)
#' }
#'
#' # doesn't work right now
#' ## file <- system.file("examples", "feature_collection.geojson",
#' ##   package = "geojsonio")
#' ## geojson_read(file, what = "sp")
#' }
geojson_read <- function(x, method = "web", parse = FALSE, what = "list",
  query = NULL, ...) {

  UseMethod("geojson_read")
}

#' @export
geojson_read.default <- function(x, method = "web", parse = FALSE,
  what = "list", query = NULL, ...) {

  stop("no 'geojson_read' method for ", class(x), call. = FALSE)
}

#' @export
geojson_read.character <- function(x, method = "web", parse = FALSE,
  what = "list", query = NULL, ...) {

  read_json(as.location(x), method, parse, what, ...)
}

#' @export
geojson_read.location <- function(x, method = "web", parse = FALSE,
  what = "list", query = NULL, ...) {

  read_json(x, method, parse, what, ...)
}

#' @export
geojson_read.PqConnection <- function(x, method = "web", parse = FALSE,
  what = "list", query = NULL, ...) {

  check4pkg("DBI")
  check4pkg("RPostgres")
  tmp <- DBI::dbGetQuery(x, query)
  if (!inherits(tmp, "data.frame")) stop("failure reading from database")
  read_from_sql(unclass(tmp[[1]]), parse, what, ...)
}

# utilities
read_from_sql <- function(x, parse, what, ...) {
  what <- match.arg(what, c("list", "sp", "json"))
  switch(what,
    list = jsonlite::fromJSON(x, parse, ...),
    sp = rgdal::readOGR(x, rgdal::ogrListLayers(x), verbose = FALSE, ...),
    json = x
  )
}

read_json <- function(x, method, parse, what, ...) {
  what <- match.arg(what, c("list", "sp", "json"))
  switch(what,
    list = file_to_geojson(x, method, output = ":memory:", parse, ...),
    sp = file_to_sp(x, ...),
    json = stop("what='json' not supported for file and url inputs yet")
  )
}

file_to_sp <- function(input, ...) {
  fileext <- ftype(input)
  fileext <- match.arg(fileext, c("shp", "kml", "geojson", "json"))
  input <- handle_remote(input)
  switch(
    fileext,
    kml = rgdal::readOGR(input, rgdal::ogrListLayers(input)[1],
                         drop_unsupported_fields = TRUE, verbose = FALSE, ...),
    shp = rgdal::readOGR(input, rgdal::ogrListLayers(input), verbose = FALSE, ...),
    geojson = rgdal::readOGR(input, rgdal::ogrListLayers(input), verbose = FALSE, ...),
    json = rgdal::readOGR(input, rgdal::ogrListLayers(input), verbose = FALSE, ...)
  )
}
