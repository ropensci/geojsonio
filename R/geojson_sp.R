#' Convert output of geojson_list or geojson_json to spatial classes
#' 
#' @export
#' @param x Object of class \code{geo_list} or \code{geo_json}
#' @param disambiguateFIDs (logical) default \code{FALSE}, if \code{TRUE}, and FID 
#' values are not unique, they will be set to unique values 1:N for N features; 
#' problem observed in GML files
#' @param ... Further args passed on to \code{\link[rgdal]{readOGR}}
#' 
#' @return A spatial class object, see Details.
#' @details The spatial class object returned will depend on the input GeoJSON. 
#' Sometimes you will get back a \code{SpatialPoints} class, and sometimes a 
#' \code{SpatialPolygonsDataFrame} class, etc., depending on what the 
#' structure of the GeoJSON. 
#' 
#' The reading and writing of the CRS to/from geojson is inconsistent. You can 
#' directly set the CRS by passing a valid PROJ4 string to the \code{p4s} argument in 
#' \code{\link[rgdal]{readOGR}}.
#' 
#' @examples \dontrun{
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
#' # Set the CRS via the p4s argument
#' geojson_json(us_cities[1:2,], lat='lat', lon='long') %>% geojson_sp(p4s = "+init=epsg:4326")
#' 
#' # json ----------------------
#' x <- geojson_json(us_cities[1:2,], lat='lat', lon='long')
#' geojson_sp(x)
#' }
geojson_sp <- function(x, disambiguateFIDs = TRUE, ...) {
  UseMethod("geojson_sp")
}

#' @export
geojson_sp.geo_list <- function(x, disambiguateFIDs = TRUE, ...) {
  tosp(as.json(x), ...)
}

#' @export
geojson_sp.geo_json <- function(x, disambiguateFIDs = TRUE, ...) {
  tosp(x, ...)
}

#' @export
geojson_sp.json <- function(x, disambiguateFIDs = TRUE, ...) {
  tosp(x, disambiguateFIDs, ...)
}

tosp <- function(x, disambiguateFIDs, ...) {
  rgdal::readOGR(x, layer = "OGRGeoJSON", disambiguateFIDs = disambiguateFIDs, 
                 verbose = FALSE, ...)  
}
