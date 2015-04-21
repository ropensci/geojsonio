#' Convert various data formats to/from GeoJSON or TopoJSON
#'
#' This package focuses mostly on converting lists, data.frame's, numeric, SpatialPolygons,
#' SpatialPolygonsDataFrame, and more to GeoJSON with the help of \code{rgdal} and 
#' friends. You can currently read TopoJSON - writing TopoJSON will come in a future
#' version of this package.
#'
#' @name geojsonio
#' @author Scott Chamberlain
#' @author Andy Teucher
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

