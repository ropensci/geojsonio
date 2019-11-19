#' PostGIS setup
#' 
#' [geojson_read()] allows you to get data out of a PostgreSQL 
#' database set up with PostGIS. Below are steps for setting up data
#' that we can at the end query with [geojson_read()]
#' 
#' If you don't already have PostgreSQL or PostGIS:
#' 
#' - PostgreSQL installation: http://www.postgresql.org/download/
#' - PostGIS installation: http://postgis.net/install
#' 
#' Once you have both of those installed, you can proceed below.
#'
#' @examples \dontrun{
#' if (requireNamespace("DBI") && requireNamespace("RPostgres")) {
#' library("DBI")
#' library("RPostgres")
#' 
#' # Create connection
#' conn <- tryCatch(dbConnect(RPostgres::Postgres()), error = function(e) e)
#' if (inherits(conn, "PqConnection")) {
#'
#' # Create database
#' dbSendQuery(conn, "CREATE DATABASE postgistest")
#'
#' # New connection to the created database
#' conn <- dbConnect(RPostgres::Postgres(), dbname = 'postgistest')
#'
#' # Initialize PostGIS in Postgres
#' dbSendQuery(conn, "CREATE EXTENSION postgis")
#' dbSendQuery(conn, "SELECT postgis_full_version()")
#'
#' # Create table
#' dbSendQuery(conn, "CREATE TABLE locations(loc_id integer primary key
#'    , loc_name varchar(70), geog geography(POINT) );")
#'
#' # Insert data
#' dbSendQuery(conn, "INSERT INTO locations(loc_id, loc_name, geog)
#'  VALUES (1, 'Waltham, MA', ST_GeogFromText('POINT(42.40047 -71.2577)') )
#'    , (2, 'Manchester, NH', ST_GeogFromText('POINT(42.99019 -71.46259)') )
#'    , (3, 'TI Blvd, TX', ST_GeogFromText('POINT(-96.75724 32.90977)') );")
#'
#'
#' # Get data (notice warnings of unknown field type for geog)
#' dbGetQuery(conn, "SELECT * from locations")
#' 
#' 
#' # Once you're setup, use geojson_read()
#' conn <- dbConnect(RPostgres::Postgres(), dbname = 'postgistest')
#' state <- "SELECT row_to_json(fc)
#'  FROM (SELECT 'FeatureCollection' As type, array_to_json(array_agg(f)) As features
#'  FROM (SELECT 'Feature' As type
#'     , ST_AsGeoJSON(lg.geog)::json As geometry
#'     , row_to_json((SELECT l FROM (SELECT loc_id, loc_name) As l
#'       )) As properties
#'    FROM locations As lg   ) As f )  As fc;"
#' json <- geojson_read(conn, query = state, what = "json")
#' 
#' ## map the geojson with map_leaf()
#' map_leaf(json)
#' 
#' }
#' }
#' }
#' @name postgis
NULL
