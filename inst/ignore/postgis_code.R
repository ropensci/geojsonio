#' @param query A SQL query.

#' # Query PostGIS/Postgres
#' library("DBI")
#' library("RPostgres")
#' conn <- dbConnect(RPostgres::Postgres(), dbname = 'postgistest')
#' state <- "SELECT row_to_json(fc)
#'  FROM (SELECT 'FeatureCollection' As type, array_to_json(array_agg(f)) As features
#'  FROM (SELECT 'Feature' As type
#'     , ST_AsGeoJSON(lg.geog)::json As geometry
#'     , row_to_json((SELECT l FROM (SELECT loc_id, loc_name) As l
#'       )) As properties
#'    FROM locations As lg   ) As f )  As fc;"
#' json <- geojson_read(conn, state)[[1]]
#' map_leaf(json)

#' @export
geojson_read.PqConnection <- function(x, query, method = "web", parse = FALSE, what = "list", ...) {
  check4dbi()
  check4rpostgres()
  DBI::dbGetQuery(x, query)
}

check4rpostgres <- function() {
  if (!requireNamespace("RPostgres", quietly = TRUE)) {
    stop("Please install RPostgres", call. = FALSE)
  }
}

check4dbi <- function() {
  if (!requireNamespace("DBI", quietly = TRUE)) {
    stop("Please install DBI", call. = FALSE)
  }
}

