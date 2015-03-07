#' Convert many input types with spatial data to geojson specified as a json string
#'
#' @export
#'
#' @param input Input list, data.frame, or spatial class. Inputs can also be dplyr \code{tbl_df}
#' class since it inherits from \code{data.frame}.
#' @param lat Latitude name. Default: latitude
#' @param lon Longitude name. Default: longitude
#' @param geometry (character) One of point (Default) or polygon. 
#' @param type The type of collection. One of FeatureCollection (default) or GeometryCollection.
#' @param group (character) A grouping variable to perform grouping for polygons - doesn't 
#' apply for points
#' @param ... Further args passed on to \code{\link[jsonlite]{toJSON}}
#' @param x Ignored
#'
#' @details This function creates a geojson structure as a json character string; it does not
#' write a file using \code{rgdal} - see \code{\link{geojson_write}} for that.
#' 
#' Note that all sp class objects will output as \code{FeatureCollection} objects, while other
#' classes (numeric, list, data.frame) can be output as \code{FeatureCollection} or 
#' \code{GeometryCollection} objects. We're working on allowing \code{GeometryCollection}
#' option for sp class objects.
#' 
#' Also note that with sp classes we do make a round-trip, using \code{\link[rgdal]{writeOGR}}
#' to write GeoJSON to disk, then read it back in. This is fast and we don't have to think 
#' about it too much, but this disk round-trip is not ideal.
#'
#' @examples \dontrun{
#' # From a numeric vector of length 2, making a point type
#' geojson_json(c(-99.74,32.45), pretty=TRUE)
#' geojson_json(c(-99.74,32.45), type = "GeometryCollection", pretty=TRUE)
#' ## polygon type 
#' ### this requires numeric class input, so inputting a list will dispatch on the list method
#' poly <- c(c(-114.345703125,39.436192999314095),
#'           c(-114.345703125,43.45291889355468),
#'           c(-106.61132812499999,43.45291889355468),
#'           c(-106.61132812499999,39.436192999314095),
#'           c(-114.345703125,39.436192999314095))
#' geojson_json(poly, geometry = "polygon", pretty=TRUE)
#'
#' # From a data.frame to points
#' geojson_json(us_cities[1:2,], lat='lat', lon='long')
#' geojson_json(us_cities[1:2,], lat='lat', lon='long', pretty=TRUE)
#' geojson_json(us_cities[1:2,], lat='lat', lon='long',
#'    type="GeometryCollection", pretty=TRUE)
#'    
#' # from data.frame to polygons
#' library("ggplot2")
#' states <- map_data("state")
#' head(states)
#' ## make list for input to e.g., rMaps
#' geojson_json(states[1:351, ], lat='lat', lon='long', geometry="polygon", group='group')
#'    
#' # from a list
#' mylist <- list(list(latitude=30, longitude=120, marker="red"),
#'                list(latitude=30, longitude=130, marker="blue"))
#' geojson_json(mylist, lat='latitude', lon='longitude')
#'         
#' # from a geo_list
#' a <- geojson_list(us_cities[1:2,], lat='lat', lon='long')$features[[1]]
#' geojson_json(a)
#'
#' # sp classes
#' 
#' ## From SpatialPolygons class
#' library('sp')
#' poly1 <- Polygons(list(Polygon(cbind(c(-100,-90,-85,-100),
#'    c(40,50,45,40)))), "1")
#' poly2 <- Polygons(list(Polygon(cbind(c(-90,-80,-75,-90),
#'    c(30,40,35,30)))), "2")
#' sp_poly <- SpatialPolygons(list(poly1, poly2), 1:2)
#' geojson_json(sp_poly)
#' geojson_json(sp_poly, pretty=TRUE)
#' 
#' ## Another SpatialPolygons
#' library("sp")
#' library("rgeos")
#' pt <- SpatialPoints(coordinates(list(x = 0, y = 0)), CRS("+proj=longlat +datum=WGS84"))
#' ## transfrom to web mercator becuase geos needs project coords
#' pt <- spTransform(pt, CRS("+proj=merc +a=6378137 +b=6378137 +lat_ts=0.0 +lon_0=0.0 +x_0=0.0 +y_0=0 +k=1.0 +units=m +nadgrids=@@null +wktext +no_defs"))
#' ## buffer
#' pt <- gBuffer(pt, width = 100)
#' pt <- spTransform(pt, CRS("+proj=longlat +datum=WGS84"))
#' geojson_json(pt)
#'
#' ## data.frame to SpatialPolygonsDataFrame
#' geojson_write(us_cities[1:2,], lat='lat', lon='long') %>% as.SpatialPolygonsDataFrame
#'
#' ## data.frame to json (via SpatialPolygonsDataFrame)
#' geojson_write(us_cities[1:2,], lat='lat', lon='long') %>% as.json
#' 
#' # From SpatialPoints class
#' x <- c(1,2,3,4,5)
#' y <- c(3,2,5,1,4)
#' s <- SpatialPoints(cbind(x,y))
#' geojson_json(s)
#' 
#' ## From SpatialPointsDataFrame class
#' s <- SpatialPointsDataFrame(cbind(x,y), mtcars[1:5,])
#' geojson_json(s)
#' 
#' ## From SpatialLines class
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
#' ## From SpatialLinesDataFrame class
#' dat <- data.frame(X = c("Blue", "Green"),
#'                  Y = c("Train", "Plane"), 
#'                  Z = c("Road", "River"), row.names = c("a", "b"))
#' sldf <- SpatialLinesDataFrame(sl12, dat)
#' geojson_json(sldf)
#' geojson_json(sldf, pretty=TRUE)
#' 
#' ## From SpatialGrid
#' x <- GridTopology(c(0,0), c(1,1), c(5,5))
#' y <- SpatialGrid(x)
#' geojson_json(y)
#' 
#' ## From SpatialGridDataFrame
#' sgdim <- c(3,4)
#' sg <- SpatialGrid(GridTopology(rep(0,2), rep(10,2), sgdim))
#' sgdf <- SpatialGridDataFrame(sg, data.frame(val = 1:12))
#' geojson_json(sgdf)
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
geojson_json.SpatialLinesDataFrame <- function(input, type = "FeatureCollection", ...) to_json(geojson_rw(input), ...)

#' @export
#' @rdname geojson_json
geojson_json.SpatialGrid <- function(input, ...) to_json(geojson_rw(input), ...)

#' @export
#' @rdname geojson_json
geojson_json.SpatialGridDataFrame <- function(input, ...) to_json(geojson_rw(input), ...)

#' @export
#' @rdname geojson_json
geojson_json.numeric <- function(input, geometry = "point", type = "FeatureCollection", ...) { 
  to_json(num_to_geo_list(input, geometry, type), ...)
}

#' @export
#' @rdname geojson_json
geojson_json.data.frame <- function(input, lat = "latitude", lon = "longitude", group = NULL, geometry = "point",
                                    type='FeatureCollection', ...) {
  res <- df_to_geo_list(input, lat, lon, geometry, type, group)
  to_json(res, ...)
}

#' @export
#' @rdname geojson_json
geojson_json.list <- function(input, lat = "latitude", lon = "longitude", group = NULL, geometry = "point",  type='FeatureCollection', ...){
  res <- list_to_geo_list(input, lat, lon, geometry, type, unnamed = TRUE, group)
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

#' @export
#' @rdname geojson_json
as.json.character <- function(x, ...) {
  res <- as.SpatialPolygonsDataFrame(x, ...)
  to_json(spdftogeolist(res))
}
