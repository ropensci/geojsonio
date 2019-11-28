#' @title **I/O for GeoJSON**
#'
#' @description Convert various data formats to/from GeoJSON or TopoJSON. This
#' package focuses mostly on converting lists, data.frame's, numeric,
#' SpatialPolygons, SpatialPolygonsDataFrame, and more to GeoJSON with the
#' help of \pkg{sf}. You can currently read TopoJSON - writing
#' TopoJSON will come in a future version of this package.
#'
#' @section Package organization:
#' The core functions in this package are organized first around what you're
#' working with or want to get, GeoJSON or TopoJSON, then convert to or read
#' from various formats:
#' 
#' - [geojson_list()] / [topojson_list()] - convert
#' 	to GeoJSON or TopoJSON as R list format
#' - [geojson_json()] / [topojson_json()] - convert
#'  to GeoJSON or TopoJSON as JSON
#' - [geojson_sp()] - convert to a spatial object from
#'  `geojson_list` or `geojson_json`
#' - [geojson_sf()] - convert to an sf object from
#'  `geojson_list` or `geojson_json`
#' - [geojson_read()] / [topojson_read()] - read a
#'  GeoJSON/TopoJSON file from file path or URL
#' - [geojson_write()] / [topojson_write()] - write
#'  a GeoJSON file locally (TopoJSON coming later)
#'
#' Other interesting functions:
#' 
#' - [map_gist()] - Create a GitHub gist (renders as an
#'  interactive map)
#' - [map_leaf()] - Create a local interactive map using the
#'  `leaflet` package
#' - [geo2topo()] - Convert GeoJSON to TopoJSON
#' - [topo2geo()] - Convert TopoJSON to GeoJSON
#'
#' All of the above functions have methods for various classes, including
#' `numeric` vectors, `data.frame`, `list`, `SpatialPolygons`, `SpatialLines`,
#' `SpatialPoints`, and many more - which will try to do the right thing
#' based on the data you give as input.
#'
#' @import methods sp rgeos
#' @importFrom sf st_crs st_transform st_read st_write
#' @importFrom httr GET POST content stop_for_status upload_file
#' @importFrom maptools readShapeSpatial
#' @importFrom magrittr %>%
#' @importFrom jsonlite toJSON fromJSON unbox
#' @importFrom geojson featurecollection geometrycollection
#' @name geojsonio
#' @author Scott Chamberlain \email{myrmecocystus@@gmail.com}
#' @author Andy Teucher \email{andy.teucher@@gmail.com}
#' @docType package
NULL

#' This is the same data set from the maps library, named differently
#'
#' This database is of us cities of population greater than about 40,000.
#' Also included are state capitals of any population size.
#'
#' @name us_cities
#' @format A list with 6 components, namely "name", "country.etc", "pop",
#' "lat", "long", and "capital", containing the city name, the state
#' abbreviation, approximate population (as at January 2006), latitude,
#' longitude and capital status indication (0 for non-capital, 1 for capital,
#' 2 for state capital.
#' @docType data
#' @keywords data
NULL

#' This is the same data set from the maps library, named differently
#'
#' This database is of Canadian cities of population greater than about 1,000.
#' Also included are province capitals of any population size.
#'
#' @name canada_cities
#' @format A list with 6 components, namely "name", "country.etc", "pop",
#' "lat", "long", and "capital", containing the city name, the province
#' abbreviation, approximate population (as at January 2006), latitude,
#' longitude and capital status indication (0 for non-capital, 1 for capital,
#' 2 for provincial
#' @docType data
#' @keywords data
NULL

#' This is the same data set from the ggplot2 library
#'
#' This is a data.frame with "long", "lat", "group", "order", "region", and
#' "subregion" columns specifying polygons for each US state.
#'
#' @name states
#' @docType data
#' @keywords data
NULL


#' Defunct functions in geojsonio
#'
#' - [lint()]: See `geojsonlint::geojson_hint`
#' - [validate()]: See `geojsonlint::geojson_lint`
#'
#' @name geojsonio-defunct
NULL
