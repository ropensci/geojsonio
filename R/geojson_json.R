#' Convert many input types with spatial data to geojson specified as a json string
#'
#' @export
#'
#' @param input Input list, data.frame, or spatial class. Inputs can also be dplyr \code{tbl_df}
#' class since it inherits from \code{data.frame}.
#' @param lat (character) Latitude name. The default is \code{NULL}, and we attempt to guess.
#' @param lon (character) Longitude name. The default is \code{NULL}, and we attempt to guess.
#' @param geometry (character) One of point (Default) or polygon.
#' @param type  (character)The type of collection. One of FeatureCollection (default) or GeometryCollection.
#' @param group (character) A grouping variable to perform grouping for polygons - doesn't
#' apply for points
#' @param ... Further args passed on to \code{\link[jsonlite]{toJSON}}
#'
#' @return An object of class \code{geo_json} (and \code{json})
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
#'
#' ## polygon type
#' ### this requires numeric class input, so inputting a list will dispatch on the list method
#' poly <- c(c(-114.345703125,39.436192999314095),
#'           c(-114.345703125,43.45291889355468),
#'           c(-106.61132812499999,43.45291889355468),
#'           c(-106.61132812499999,39.436192999314095),
#'           c(-114.345703125,39.436192999314095))
#' geojson_json(poly, geometry = "polygon", pretty=TRUE)
#'
#' # Lists
#' ## From a list of numeric vectors to a polygon
#' vecs <- list(c(100.0,0.0), c(101.0,0.0), c(101.0,1.0), c(100.0,1.0), c(100.0,0.0))
#' geojson_json(vecs, geometry="polygon", pretty=TRUE)
#' 
#' ## from a named list
#' mylist <- list(list(latitude=30, longitude=120, marker="red"),
#'                list(latitude=30, longitude=130, marker="blue"))
#' geojson_json(mylist, lat='latitude', lon='longitude')
#'
#' # From a data.frame to points
#' geojson_json(us_cities[1:2,], lat='lat', lon='long', pretty=TRUE)
#' geojson_json(us_cities[1:2,], lat='lat', lon='long',
#'    type="GeometryCollection", pretty=TRUE)
#'
#' # from data.frame to polygons
#' head(states)
#' ## make list for input to e.g., rMaps
#' geojson_json(states[1:351, ], lat='lat', lon='long', geometry="polygon", group='group')
#'
#' # from a geo_list
#' a <- geojson_list(us_cities[1:2,], lat='lat', lon='long')
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
#' crs <- gsub("\n", "", paste0("+proj=merc +a=6378137 +b=6378137 +lat_ts=0.0 +lon_0=0.0 +x_0=0.0
#'    +y_0=0 +k=1.0 +units=m +nadgrids=@@null +wktext +no_defs", collapse = ""))
#' pt <- spTransform(pt, CRS(crs))
#' ## buffer
#' pt <- gBuffer(pt, width = 100)
#' pt <- spTransform(pt, CRS("+proj=longlat +datum=WGS84"))
#' geojson_json(pt)
#'
#' ## data.frame to geojson
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
#' 
#' # From SpatialRings
#' library("rgeos")
#' r1 <- Ring(cbind(x=c(1,1,2,2,1), y=c(1,2,2,1,1)), ID="1")
#' r2 <- Ring(cbind(x=c(1,1,2,2,1), y=c(1,2,2,1,1)), ID="2")
#' r1r2 <- SpatialRings(list(r1, r2))
#' geojson_json(r1r2)
#' 
#' # From SpatialRingsDataFrame
#' dat <- data.frame(id = c(1,2), value = 3:4)
#' r1r2df <- SpatialRingsDataFrame(r1r2, data = dat)
#' geojson_json(r1r2df)
#' 
#' # From SpatialPixels
#' library("sp") 
#' pixels <- suppressWarnings(SpatialPixels(SpatialPoints(us_cities[c("long", "lat")])))
#' summary(pixels)
#' geojson_json(pixels)
#' 
#' # From SpatialPixelsDataFrame
#' library("sp")
#' pixelsdf <- suppressWarnings(
#'  SpatialPixelsDataFrame(points = canada_cities[c("long", "lat")], data = canada_cities)
#' )
#' geojson_json(pixelsdf)
#' 
#' # From SpatialCollections
#' library("sp")
#' library("rgeos")
#' pts <- SpatialPoints(cbind(c(1,2,3,4,5), c(3,2,5,1,4)))
#' poly1 <- Polygons(list(Polygon(cbind(c(-100,-90,-85,-100), c(40,50,45,40)))), "1")
#' poly2 <- Polygons(list(Polygon(cbind(c(-90,-80,-75,-90), c(30,40,35,30)))), "2")
#' poly <- SpatialPolygons(list(poly1, poly2), 1:2)
#' dat <- SpatialCollections(pts, polygons = poly)
#' geojson_json(dat)
#' 
#' ## Pretty print a json string
#' geojson_json(c(-99.74,32.45))
#' geojson_json(c(-99.74,32.45)) %>% pretty
#' }
geojson_json <- function(input, lat = NULL, lon = NULL, group = NULL,
                         geometry = "point", type='FeatureCollection', ...) {
  UseMethod("geojson_json")
}

# spatial classes from sp --------------------------
#' @export
geojson_json.SpatialPolygons <- function(input, lat = NULL, lon = NULL, group = NULL,
                                         geometry = "point",  type='FeatureCollection', ...) {
  to_json(geojson_rw(input), ...)
}

#' @export
geojson_json.SpatialPolygonsDataFrame <- function(input, lat = NULL, lon = NULL, group = NULL,
                                                  geometry = "point",  type='FeatureCollection', ...) {
  to_json(geojson_rw(input), ...)
}

#' @export
geojson_json.SpatialPoints <- function(input, lat = NULL, lon = NULL, group = NULL,
                                       geometry = "point",  type='FeatureCollection', ...) {
  dat <- SpatialPointsDataFrame(input, data.frame(dat = 1:NROW(input@coords)))
  to_json(geojson_rw(dat))
}

#' @export
geojson_json.SpatialPointsDataFrame <- function(input, lat = NULL, lon = NULL, group = NULL,
                                                geometry = "point",  type='FeatureCollection', ...) {
  to_json(geojson_rw(input), ...)
}

#' @export
geojson_json.SpatialLines <- function(input, lat = NULL, lon = NULL, group = NULL,
                                      geometry = "point",  type='FeatureCollection', ...) {
  to_json(geojson_rw(input), ...)
}

#' @export
geojson_json.SpatialLinesDataFrame <- function(input, lat = NULL, lon = NULL, group = NULL,
                                               geometry = "point",  type='FeatureCollection', ...) {
  to_json(geojson_rw(input), ...)
}

#' @export
geojson_json.SpatialGrid <- function(input, lat = NULL, lon = NULL, group = NULL,
                                     geometry = "point",  type='FeatureCollection', ...) {
  to_json(geojson_rw(input), ...)
}

#' @export
geojson_json.SpatialGridDataFrame <- function(input, lat = NULL, lon = NULL, group = NULL,
                                              geometry = "point",  type='FeatureCollection', ...) {
  to_json(geojson_rw(input), ...)
}

#' @export
geojson_json.SpatialPixels <- function(input, lat = NULL, lon = NULL, group = NULL,
                                       geometry = "point",  type='FeatureCollection', ...) {
  to_json(geojson_rw(input), ...)
}

#' @export
geojson_json.SpatialPixelsDataFrame <- function(input, lat = NULL, lon = NULL, group = NULL,
                                                geometry = "point",  type='FeatureCollection', ...) {
  to_json(geojson_rw(input), ...)
}

# spatial classes from rgeos --------------------------
#' @export
geojson_json.SpatialRings <- function(input, lat = NULL, lon = NULL, group = NULL,
                                              geometry = "point",  type='FeatureCollection', ...) {
  to_json(geojson_rw(input), ...)
}

#' @export
geojson_json.SpatialRingsDataFrame <- function(input, lat = NULL, lon = NULL, group = NULL,
                                               geometry = "point",  type='FeatureCollection', ...) {
  to_json(geojson_rw(input), ...)
}

#' @export
geojson_json.SpatialCollections <- function(input, lat = NULL, lon = NULL, group = NULL,
                                                geometry = "point",  type='FeatureCollection', ...) {
  lapply(geojson_rw(input), to_json)
}


# regular R classes --------------------------
#' @export
geojson_json.numeric <- function(input, lat = NULL, lon = NULL, group = NULL,
                                 geometry = "point", type='FeatureCollection', ...) {
  to_json(num_to_geo_list(input, geometry, type), ...)
}

#' @export
geojson_json.data.frame <- function(input, lat = NULL, lon = NULL, group = NULL,
                                    geometry = "point", type='FeatureCollection', ...) {
  tmp <- guess_latlon(names(input), lat, lon)
  res <- df_to_geo_list(input, tmp$lat, tmp$lon, geometry, type, group)
  to_json(res, ...)
}

#' @export
geojson_json.list <- function(input, lat = NULL, lon = NULL, group = NULL,
                              geometry = "point",  type='FeatureCollection', ...){
  if (geometry == "polygon") lint_polygon_list(input)
  tmp <- if (!is.named(input)) {
    list(lon = NULL, lat = NULL)
  } else {
    guess_latlon(names(input[[1]]), lat, lon)
  }
  res <- list_to_geo_list(input, tmp$lat, tmp$lon, geometry, type, unnamed = !is.named(input), group)
  to_json(res, ...)
}

#' @export
geojson_json.geo_list <- function(input, lat = NULL, lon = NULL, group = NULL,
                                  geometry = "point", type = "FeatureCollection", ...) {
  
  to_json(unclass(input), ...)
}
