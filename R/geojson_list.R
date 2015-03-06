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
#' # from data.frame
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
#' vec <- c(-99.74,32.45)
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
#'
#' # From SpatialLines class
#' library("sp")
#' c1 <- cbind(c(1,2,3), c(3,2,2))
#' c2 <- cbind(c1[,1]+.05,c1[,2]+.05)
#' c3 <- cbind(c(1,2,3),c(1,1.5,1))
#' L1 <- Line(c1)
#' L2 <- Line(c2)
#' L3 <- Line(c3)
#' Ls1 <- Lines(list(L1), ID = "a")
#' Ls2 <- Lines(list(L2, L3), ID = "b")
#' sl1 <- SpatialLines(list(Ls1))
#' sl12 <- SpatialLines(list(Ls1, Ls2))
#' geojson_list(sl1)
#' geojson_list(sl12)
#' as.json(geojson_list(sl12))
#' as.json(geojson_list(sl12), pretty=TRUE)
#'
#' # From SpatialLinesDataFrame class
#' dat <- data.frame(X = c("Blue", "Green"),
#'                  Y = c("Train", "Plane"), 
#'                  Z = c("Road", "River"), row.names = c("a", "b"))
#' sldf <- SpatialLinesDataFrame(sl12, dat)
#' geojson_list(sldf)
#' as.json(geojson_list(sldf))
#' as.json(geojson_list(sldf), pretty=TRUE)
#' 
#' # From SpatialGrid
#' x <- GridTopology(c(0,0), c(1,1), c(5,5))
#' y <- SpatialGrid(x)
#' geojson_list(y)
#' 
#' # From SpatialGridDataFrame
#' sgdim <- c(3,4)
#' sg <- SpatialGrid(GridTopology(rep(0,2), rep(10,2), sgdim))
#' sgdf <- SpatialGridDataFrame(sg, data.frame(val = 1:12))
#' geojson_list(sgdf)
#' }

geojson_list <- function(...) UseMethod("geojson_list")

#' @export
#' @rdname geojson_list
geojson_list.SpatialPolygons <- function(input, ...) as.geo_list(geojson_rw(input), "SpatialPolygons")

#' @export
#' @rdname geojson_list
geojson_list.SpatialPolygonsDataFrame <- function(input, ...) as.geo_list(geojson_rw(input), "SpatialPolygonsDataFrame")

#' @export
#' @rdname geojson_list
geojson_list.SpatialPoints <- function(input, ...) { 
  dat <- SpatialPointsDataFrame(input, data.frame(dat=1:NROW(input@coords)))
  as.geo_list(geojson_rw(dat), "SpatialPoints")
}

#' @export
#' @rdname geojson_list
geojson_list.SpatialPointsDataFrame <- function(input, ...) as.geo_list(geojson_rw(input), "SpatialPointsDataFrame")

#' @export
#' @rdname geojson_list
geojson_list.SpatialLines <- function(input, ...) as.geo_list(geojson_rw(input), "SpatialLines")

#' @export
#' @rdname geojson_list
geojson_list.SpatialLinesDataFrame <- function(input, object = "FeatureCollection", ...) as.geo_list(geojson_rw(input), "SpatialLinesDataFrame")

#' @export
#' @rdname geojson_list
geojson_list.SpatialGrid <- function(input, ...) as.geo_list(geojson_rw(input), "SpatialGrid")

#' @export
#' @rdname geojson_list
geojson_list.SpatialGridDataFrame <- function(input, ...) as.geo_list(geojson_rw(input), "SpatialGridDataFrame")

#' @export
#' @rdname geojson_list
geojson_list.numeric <- function(input, geometry = "point", type = "FeatureCollection", ...) { 
  as.geo_list(num_to_geo_list(input, geometry, type), "numeric")
}

#' @export
#' @rdname geojson_list
geojson_list.data.frame <- function(input, lat = "latitude", lon = "longitude", polygon=NULL, object = "FeatureCollection", ...){
  as.geo_list(df_to_geo_list(input, lat, lon, polygon, object), "data.frame")
}

#' @export
#' @rdname geojson_list
geojson_list.list <- function(input, lat = "latitude", lon = "longitude", polygon=NULL, object = "FeatureCollection", unnamed=FALSE, ...){
  as.geo_list(list_to_geo_list(input, lat, lon, polygon, object, unnamed), "list")
}

as.geo_list <- function(x, from) structure(x, class="geo_list", from=from)
