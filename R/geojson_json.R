#' Convert many input types with spatial data to geojson specified as a json string
#'
#' @export
#'
#' @param input Input list, data.frame, or spatial class. Inputs can also be dplyr \code{tbl_df}
#' class since it inherits from \code{data.frame}.
#' @param lat Latitude name. Default: latitude
#' @param lon Longitude name. Default: longitude
#' @param polygon If a polygon is defined in a data.frame, this is the column that defines the
#' grouping of the polygons in the \code{data.frame}
#' @param object The type of collection. One of FeatureCollection (default) or GeometryCollection.
#' @param ... Further args passed on to \code{\link[jsonlite]{toJSON}}
#' @param x Ignored
#'
#' @details This function creates a geojson structure as a json character string; it does not
#' write a file using \code{rgdal} - see \code{\link{geojson_write}} for that.
#'
#' @examples \dontrun{
#' # From a numeric vector of length 2
#' geojson_json(c(32.45,-99.74))
#'
#' # From a data.frame
#' library('maps')
#' data(us.cities)
#' geojson_json(us.cities[1:2,], lat='lat', lon='long')
#' geojson_json(us.cities[1:2,], lat='lat', lon='long', pretty=TRUE)
#' geojson_json(us.cities[1:2,], lat='lat', lon='long',
#'    object="GeometryCollection", pretty=TRUE)
#'
#' # From SpatialPolygons class
#' library('sp')
#' poly1 <- Polygons(list(Polygon(cbind(c(-100,-90,-85,-100),
#'    c(40,50,45,40)))), "1")
#' poly2 <- Polygons(list(Polygon(cbind(c(-90,-80,-75,-90),
#'    c(30,40,35,30)))), "2")
#' sp_poly <- SpatialPolygons(list(poly1, poly2), 1:2)
#' geojson_json(sp_poly)
#' geojson_json(sp_poly, pretty=TRUE)
#'
#' # data.frame to SpatialPolygonsDataFrame
#' library('maps')
#' data(us.cities)
#' geojson_write(us.cities[1:2,], lat='lat', lon='long') %>% as.SpatialPolygonsDataFrame
#'
#' # data.frame to json (via SpatialPolygonsDataFrame)
#' geojson_write(us.cities[1:2,], lat='lat', lon='long') %>% as.json
#' 
#' # From SpatialPoints class
#' x <- c(1,2,3,4,5)
#' y <- c(3,2,5,1,4)
#' s <- SpatialPoints(cbind(x,y))
#' geojson_json(s)
#' 
#' # From SpatialPointsDataFrame class
#' s <- SpatialPointsDataFrame(cbind(x,y), mtcars[1:5,])
#' geojson_json(s)
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
#' geojson_json(sl1)
#' geojson_json(sl12)
#'
#' # From SpatialLinesDataFrame class
#' dat <- data.frame(X = c("Blue", "Green"),
#'                  Y = c("Train", "Plane"), 
#'                  Z = c("Road", "River"), row.names = c("a", "b"))
#' sldf <- SpatialLinesDataFrame(sl12, dat)
#' geojson_json(sldf)
#' geojson_json(sldf, pretty=TRUE)
#' 
#' # From SpatialGrid
#' x <- GridTopology(c(0,0), c(1,1), c(5,5))
#' y <- SpatialGrid(x)
#' geojson_json(y)
#' 
#' # From SpatialGridDataFrame
#' sgdim <- c(3,4)
#' sg <- SpatialGrid(GridTopology(rep(0,2), rep(10,2), sgdim))
#' sgdf <- SpatialGridDataFrame(sg, data.frame(val = 1:12))
#' geojson_json(sgdf)
#' 
#' # from a list
#' a <- geojson_list(us.cities[1:2,], lat='lat', lon='long')$features[[1]]
#' geojson_list(a)
#' }

geojson_json <- function(...) UseMethod("geojson_json")

#' @export
#' @rdname geojson_json
geojson_json.SpatialPolygons <- function(input, ...) to_json(geojson_rw(input), ...)

#' @export
#' @rdname geojson_json
geojson_json.SpatialPolygonsDataFrame <- function(input, ...) to_json(geojson_rw(input), ...)

#' @export
#' @rdname geojson_json
geojson_json.SpatialPoints <- function(input, ...) {
  dat <- SpatialPointsDataFrame(input, data.frame(dat=1:NROW(input@coords)))
  to_json(geojson_rw(dat))
}

#' @export
#' @rdname geojson_json
geojson_json.SpatialPointsDataFrame <- function(input, ...) to_json(geojson_rw(input), ...)

#' @export
#' @rdname geojson_json
geojson_json.SpatialLines <- function(input, ...) to_json(geojson_rw(input), ...)

#' @export
#' @rdname geojson_json
geojson_json.SpatialLinesDataFrame <- function(input, object = "FeatureCollection", ...) to_json(geojson_rw(input), ...)

#' @export
#' @rdname geojson_json
geojson_json.SpatialGrid <- function(input, ...) to_json(geojson_rw(input), ...)

#' @export
#' @rdname geojson_json
geojson_json.SpatialGridDataFrame <- function(input, ...) to_json(geojson_rw(input), ...)

#' @export
#' @rdname geojson_json
geojson_json.numeric <- function(input, polygon=NULL, ...) to_json(num_to_geo_list(input, polygon), ...)

#' @export
#' @rdname geojson_json
geojson_json.data.frame <- function(input, lat = "latitude", lon = "longitude", polygon=NULL, 
                                    object='FeatureCollection', ...)
{
  res <- df_to_geo_list(input, lat, lon, polygon, object)
  to_json(res, ...)
}

#' @export
#' @rdname geojson_json
geojson_json.list <- function(input, lat = "latitude", lon = "longitude", polygon=NULL, object='FeatureCollection', ...){
  res <- list_to_geo_list(input, lat, lon, polygon, object=object, unnamed = TRUE)
  to_json(res, ...)
}

#' @export
#' @rdname geojson_json
as.json <- function(x, ...) UseMethod("as.json")

#' @export
#' @rdname geojson_json
as.json.geo_list <- function(x, ...) to_json(unclass(x), ...)

#' @export
#' @rdname geojson_json
as.json.geojson <- function(x, ...) {
  res <- as.SpatialPolygonsDataFrame(x, ...)
  to_json(spdftogeolist(res))
}
