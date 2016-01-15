#' @title \strong{I/O for GeoJSON}
#' 
#' @description Convert various data formats to/from GeoJSON or TopoJSON. This package 
#' focuses mostly on converting lists, data.frame's, numeric, SpatialPolygons,
#' SpatialPolygonsDataFrame, and more to GeoJSON with the help of \code{rgdal} and 
#' friends. You can currently read TopoJSON - writing TopoJSON will come in a future
#' version of this package.
#' 
#' @section Package organization:
#' The core functions in this package are organized first around what you're working 
#' with or want to get, geojson or topojson, then convert to or read from 
#' various formats:
#' \itemize{
#'  \item \code{\link{geojson_list}} - convert to geojson as R list format
#'  \item \code{\link{geojson_json}} - convert to geojson as json
#'  \item \code{\link{geojson_sp}} - convert to a spatial object from \code{geojson_list}
#'  or \code{geojson_json}
#'  \item \code{\link{geojson_read}} / \code{\link{topojson_read}} - read a 
#'  geojson/topojson file from file path or URL
#'  \item \code{\link{geojson_write}} - write a geojson file locally (topojson coming later)
#' }
#' 
#' Other interesting functions:
#' \itemize{
#'  \item \code{\link{map_gist}} - Create a GitHub gist (renders as an interactive map)
#'  \item \code{\link{map_leaf}} - Create a local interactive map using the \code{leaflet}
#'  package
#'  \item \code{\link{lint}} - Checks validity of geojson using the Javascript library
#'  geojsonhint
#'  \item \code{\link{validate}} - Checks validity of geojson using the web service at
#'  http://geojsonlint.com/
#' }
#' 
#' All of the above functions have methods for various classes, including 
#' \code{numeric} vectors, \code{data.frame}, \code{list}, \code{SpatialPolygons}, 
#' \code{SpatialLines}, \code{SpatialPoints}, and many more - which will try to 
#' do the right thing based on the data you give as input.
#' 
#' @importFrom stats setNames
#' @importFrom utils download.file
#' @importFrom httr GET POST content stop_for_status upload_file
#' @importFrom maptools readShapeSpatial
#' @importFrom rgdal readOGR writeOGR ogrListLayers
#' @importFrom magrittr %>%
#' @name geojsonio
#' @author Scott Chamberlain \email{myrmecocystus@@gmail.com}
#' @author Andy Teucher \email{andy.teucher@@gmail.com}
#' @docType package
NULL

#' This is the same data set from the maps library, named differently
#' 
#' This database is of us cities of population greater than about 40,000. Also included 
#' are state capitals of any population size.
#'
#' @name us_cities
#' @format A list with 6 components, namely "name", "country.etc", "pop", "lat", "long", and 
#' "capital", containing the city name, the state abbreviation, approximate population 
#' (as at January 2006), latitude, longitude and capital status indication (0 for non-capital, 
#' 1 for capital, 2 for state capital.
#' @docType data
#' @keywords data
NULL

#' This is the same data set from the maps library, named differently
#' 
#' This database is of Canadian cities of population greater than about 1,000. Also included 
#' are province capitals of any population size.
#'
#' @name canada_cities
#' @format A list with 6 components, namely "name", "country.etc", "pop", "lat", "long", 
#' and "capital", containing the city name, the province abbreviation, approximate population 
#' (as at January 2006), latitude, longitude and capital status indication (0 for non-capital, 
#' 1 for capital, 2 for provincial
#' @docType data
#' @keywords data
NULL

#' This is the same data set from the ggplot2 library
#' 
#' This is a data.frame with "long", "lat", "group", "order", "region", and "subregion" 
#' columns specifying polygons for each US state.
#'
#' @name states
#' @docType data
#' @keywords data
NULL

