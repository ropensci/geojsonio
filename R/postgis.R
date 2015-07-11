#' PostGIS setup
#' 
#' \code{\link{geojson_read}} allows you to get data out of a PostgreSQL 
#' database set up with PostGIS. Below are steps for setting up data
#' that we can at the end query with \code{\link{geojson_read}}.
#' 
#' If you don't already have PostgreSQL or PostGIS:
#' \itemize{
#'  \item PostgreSQL installation: http://www.postgresql.org/download/
#'  \item PostGIS installation: http://postgis.net/install
#' }
#' 
#' Once you have both of those installed, you can proceed below.
#'
#' @examples \dontrun{
#' library("DBI")
#' library("RPostgres")
#' 
#' # Create connection
#' conn <- dbConnect(RPostgres::Postgres())
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
#' }
#' @name postgis
NULL
