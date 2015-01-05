#' Convert many input types with spatial data to geojson specified as a list
#'
#' @export
#'
#' @param input Input list, data.frame, or spatial class. Inputs can also be dplyr \code{tbl_df}
#' class since it inherits from \code{data.frame}.
#' @param lat Latitude name. Default: latitude
#' @param lon Longitude name. Default: longitude
#' @param polygon If a polygon is defined in a data.frame, this is the column that defines the
#' grouping of the polygons in the \code{data.frame}
#' @param object (character) One of FeatureCollection, or
#' @param unnamed (logical) Is lat/long data unnamed? That is, you can pass in a list of 
#' lat/long pairs as e.g., a polygon or linestring perhaps, and they aren't named. If so, use 
#' \code{unnamed=TRUE}. The default is \code{FALSE}, that is, when a list is passed, this function
#' looks for lat and lon variable names to parse that data. 
#' @param ... Ignored
#'
#' @details This function creates a geojson structure as an R list; it does not write a file
#' using \code{rgdal} - see \code{\link{geojson_write}} for that.
#'
#' @examples \dontrun{
#' library("maps")
#' data(us.cities)
#' (res <- geojson_list(us.cities[1:2,], lat='lat', lon='long'))
#' as.json(res)
#'
#' # polygons
#' library("ggplot2")
#' states <- map_data("state")
#' head(states)
#' ## make list for input to e.g., rMaps
#' res <- geojson_list(input=states, lat='lat', lon='long', group='group')
#'
#' ## From a list
#' mylist <- list(list(latitude=30, longitude=120, marker="red"),
#'                list(latitude=30, longitude=130, marker="blue"))
#' geojson_list(mylist)
#'
#' # From a numeric vector of length 2 to a point
#' vec <- c(32.45,-99.74)
#' geojson_list(vec)
#' 
#' # From a list of numeric vectors to a polygon
#' vecs <- list(c(100.0,0.0), c(101.0,0.0), c(101.0,1.0), c(100.0,1.0), c(100.0,0.0))
#' geojson_list(vecs, unnamed=TRUE, polygon=TRUE)
#'
#' # From SpatialPolygons class
#' library('sp')
#' poly1 <- Polygons(list(Polygon(cbind(c(-100,-90,-85,-100),
#'    c(40,50,45,40)))), "1")
#' poly2 <- Polygons(list(Polygon(cbind(c(-90,-80,-75,-90),
#'    c(30,40,35,30)))), "2")
#' sp_poly <- SpatialPolygons(list(poly1, poly2), 1:2)
#' geojson_list(sp_poly)
#'
#' # From SpatialPolygonsDataFrame class
#' sp_polydf <- as(sp_poly, "SpatialPolygonsDataFrame")
#' geojson_list(input = sp_polydf)
#' 
#' # From SpatialPoints class
#' x <- c(1,2,3,4,5)
#' y <- c(3,2,5,1,4)
#' s <- SpatialPoints(cbind(x,y))
#' geojson_list(s)
#' 
#' # From SpatialPointsDataFrame class
#' s <- SpatialPointsDataFrame(cbind(x,y), mtcars[1:5,])
#' geojson_list(s)
#' }

geojson_list <- function(...) UseMethod("geojson_list")

#' @export
#' @rdname geojson_list
geojson_list.SpatialPolygons <- function(input, ...) as.geo_list(sppolytogeolist(input))

#' @export
#' @rdname geojson_list
geojson_list.SpatialPolygonsDataFrame <- function(input, ...) as.geo_list(sppolytogeolist(input))

#' @export
#' @rdname geojson_list
geojson_list.SpatialPointsDataFrame <- function(input, ...) as.geo_list(spdftogeolist(input))

#' @export
#' @rdname geojson_list
geojson_list.SpatialPoints <- function(input, ...) as.geo_list(spdftogeolist(input))

#' @export
#' @rdname geojson_list
geojson_list.numeric <- function(input, polygon=NULL, ...) as.geo_list(num_to_geo_list(input, polygon))

#' @export
#' @rdname geojson_list
geojson_list.data.frame <- function(input, lat = "latitude", lon = "longitude", polygon=NULL, object = "FeatureCollection", ...){
  as.geo_list(df_to_geo_list(input, lat, lon, polygon, object))
}

#' @export
#' @rdname geojson_list
geojson_list.list <- function(input, lat = "latitude", lon = "longitude", polygon=NULL, object = "FeatureCollection", unnamed=FALSE, ...){
  as.geo_list(list_to_geo_list(input, lat, lon, polygon, object, unnamed))
}

as.geo_list <- function(x) structure(x, class="geo_list")
