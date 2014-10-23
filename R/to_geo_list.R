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
#' 
#' @details This function creates a geojson structure as an R list; it does not write a file 
#' using \code{rgdal} - see \code{\link{to_geojson}} for that. 
#'
#' @examples \dontrun{
#' library('maps')
#' data(us.cities)
#' (res <- to_geo_list(us.cities[1:2,], lat='lat', lon='long'))
#' as.json(res)
#'
#' # polygons
#' library('ggplot2')
#' states <- map_data("state")
#' head(states)
#' ## make list for input to e.g., rMaps
#' res <- to_geo_list(input=states, lat='lat', lon='long', group='group')
#'
#' ## From a list
#' mylist <- list(list(latitude=30, longitude=120, marker="red"),
#'                list(latitude=30, longitude=130, marker="blue"))
#' to_geo_list(mylist)
#'
#' # From a numeric vector of length 2
#' vec <- c(32.45,-99.74)
#' to_geo_list(vec)
#'
#' # From SpatialPolygons class
#' library('sp')
#' poly1 <- Polygons(list(Polygon(cbind(c(-100,-90,-85,-100),
#'    c(40,50,45,40)))), "1")
#' poly2 <- Polygons(list(Polygon(cbind(c(-90,-80,-75,-90),
#'    c(30,40,35,30)))), "2")
#' sp_poly <- SpatialPolygons(list(poly1, poly2), 1:2)
#' to_geo_list(sp_poly)
#'
#' # From SpatialPolygonsDataFrame class
#' sp_polydf <- as(sp_poly, "SpatialPolygonsDataFrame")
#' to_geo_list(input = sp_polydf)
#' }

to_geo_list <- function(...) UseMethod("to_geo_list")

#' @export
#' @rdname to_geo_list
to_geo_list.SpatialPolygons <- function(input) as.geo_list(sppolytogeolist(input))

#' @export
#' @rdname to_geo_list
to_geo_list.SpatialPolygonsDataFrame <- function(input) as.geo_list(sppolytogeolist(input))

#' @export
#' @rdname to_geo_list
to_geo_list.SpatialPointsDataFrame <- function(input) as.geo_list(sppolytogeolist(input))

#' @export
#' @rdname to_geo_list
to_geo_list.numeric <- function(input, polygon=NULL) as.geo_list(num_to_geo_list(input, polygon))

#' @export
#' @rdname to_geo_list
to_geo_list.data.frame <- function(input, lat = "latitude", lon = "longitude", polygon=NULL){
  as.geo_list(df_to_geo_list(input, lat, lon, polygon))
}

#' @export
#' @rdname to_geo_list
to_geo_list.list <- function(input, lat = "latitude", lon = "longitude", polygon=NULL){
  as.geo_list(list_to_geo_list(input, lat, lon, polygon))
}

as.geo_list <- function(x) structure(x, class="geo_list")
