#' Convert objects to spatial classes
#'
#' @export
#'
#' @inheritParams geojson_sf
#' @param disambiguateFIDs Ignored, and will be removed in a future version. 
#' Previously was passed to `rgdal::readOGR()`, which is no longer used.
#'
#' @return A spatial class object, see Details.
#' @details The spatial class object returned will depend on the input GeoJSON.
#' Sometimes you will get back a `SpatialPoints` class, and sometimes a
#' `SpatialPolygonsDataFrame` class, etc., depending on what the
#' structure of the GeoJSON.
#'
#' The reading and writing of the CRS to/from geojson is inconsistent. You can
#' directly set the CRS by passing a valid PROJ4 string or epsg code to the crs
#' argument in [sf::st_read()]
#'
#' @examples \dontrun{
#' library(sp)
#'
#' # geo_list ------------------
#' ## From a numeric vector of length 2 to a point
#' vec <- c(-99.74,32.45)
#' geojson_list(vec) %>% geojson_sp
#'
#' ## Lists
#' ## From a list
#' mylist <- list(list(latitude=30, longitude=120, marker="red"),
#'                list(latitude=30, longitude=130, marker="blue"))
#' geojson_list(mylist) %>% geojson_sp
#' geojson_list(mylist) %>% geojson_sp %>% plot
#'
#' ## From a list of numeric vectors to a polygon
#' vecs <- list(c(100.0,0.0), c(101.0,0.0), c(101.0,1.0), c(100.0,1.0), c(100.0,0.0))
#' geojson_list(vecs, geometry="polygon") %>% geojson_sp
#' geojson_list(vecs, geometry="polygon") %>% geojson_sp %>% plot
#'
#' # geo_json ------------------
#' ## from point
#' geojson_json(c(-99.74,32.45)) %>% geojson_sp
#' geojson_json(c(-99.74,32.45)) %>% geojson_sp %>% plot
#'
#' # from featurecollectino of points
#' geojson_json(us_cities[1:2,], lat='lat', lon='long') %>% geojson_sp
#' geojson_json(us_cities[1:2,], lat='lat', lon='long') %>% geojson_sp %>% plot
#'
#' # Set the CRS via the crs argument
#' geojson_json(us_cities[1:2,], lat='lat', lon='long') %>%
#'   geojson_sp(crs = "+init=epsg:4326")
#'
#' # json ----------------------
#' x <- geojson_json(us_cities[1:2,], lat='lat', lon='long')
#' geojson_sp(x)
#' 
#' # character string ----------------------
#' x <- unclass(geojson_json(c(-99.74,32.45)))
#' geojson_sp(x)
#' }
geojson_sp <- function(x, disambiguateFIDs = FALSE, stringsAsFactors = FALSE, ...) {
  if (disambiguateFIDs) {
    warning("disambiguateFIDs is no longer used in geojson_sp")
  }
  UseMethod("geojson_sp")
}

#' @export
geojson_sp.character <- function(x, disambiguateFIDs, stringsAsFactors = FALSE, ...) {
  tosp(as.json(x), stringsAsFactors = stringsAsFactors, ...)
}

#' @export
geojson_sp.geo_list <- function(x, disambiguateFIDs, stringsAsFactors = FALSE, ...) {
  tosp(as.json(x), stringsAsFactors = stringsAsFactors, ...)
}

#' @export
geojson_sp.geo_json <- function(x, disambiguateFIDs, stringsAsFactors = FALSE, ...) {
  tosp(x, stringsAsFactors = stringsAsFactors, ...)
}

#' @export
geojson_sp.json <- function(x, disambiguateFIDs, stringsAsFactors = FALSE, ...) {
  tosp(x, stringsAsFactors = stringsAsFactors, ...)
}

tosp_base <- function(x, stringsAsFactors, ...) {
  x_sf <- tosf(x, stringsAsFactors = stringsAsFactors, ...)
  # Mimic behaviour of rgdal::readOGR where an FID column is added when no
  # attributes exist
  if (ncol(x_sf) == 1) {
    x_sf <- cbind(FID = seq_along(x_sf[[1]]), x_sf)
  }
  return(x_sf)
}

tosp <- function(x, stringsAsFactors, ...) {
  as(tosp_base(x, stringsAsFactors, ...), "Spatial")
}
