#' Convert many input types with spatial data to geojson specified as a list
#'
#' @export
#'
#' @param input Input list, data.frame, or spatial class. Inputs can also be dplyr \code{tbl_df}
#' class since it inherits from \code{data.frame}.
#' @param lat (character) Latitude name. The default is \code{NULL}, and we attempt to guess.
#' @param lon (character) Longitude name. The default is \code{NULL}, and we attempt to guess.
#' @param geometry (character) One of point (Default) or polygon.
#' @param type (character) The type of collection. One of FeatureCollection (default) or
#' GeometryCollection.
#' @param group (character) A grouping variable to perform grouping for polygons - doesn't apply
#' for points
#' @param ... Ignored
#'
#' @details This function creates a geojson structure as an R list; it does not write a file
#' using \code{rgdal} - see \code{\link{geojson_write}} for that.
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
#' For \code{list} and \code{data.frame} objects, you don't have to pass in \code{lat} and
#' \code{lon} parameters if they are named appropriately (e.g., lat/latitude, lon/long/longitude),
#' as they will be auto-detected. If they can not be found, the function will stop and warn
#' you to specify the parameters specifically.
#'
#' @examples \dontrun{
#' # From a numeric vector of length 2 to a point
#' vec <- c(-99.74,32.45)
#' geojson_list(vec)
#'
#' # Lists
#' ## From a list
#' mylist <- list(list(latitude=30, longitude=120, marker="red"),
#'                list(latitude=30, longitude=130, marker="blue"))
#' geojson_list(mylist)
#'
#' ## From a list of numeric vectors to a polygon
#' vecs <- list(c(100.0,0.0), c(101.0,0.0), c(101.0,1.0), c(100.0,1.0), c(100.0,0.0))
#' geojson_list(vecs, geometry="polygon")
#'
#' # from data.frame to points
#' (res <- geojson_list(us_cities[1:2,], lat='lat', lon='long'))
#' as.json(res)
#' ## guess lat/long columns
#' geojson_list(us_cities[1:2,])
#' geojson_list(states[1:3,])
#' geojson_list(states[1:351,], geometry="polygon", group='group')
#' geojson_list(canada_cities[1:30,])
#' ## a data.frame with columsn not named appropriately, but you can specify them
#' # dat <- data.frame(a = c(31, 41), b = c(-120, -110))
#' # geojson_list(dat)
#' # geojson_list(dat, lat="a", lon="b")
#'
#' # from data.frame to polygons
#' head(states)
#' geojson_list(states[1:351, ], lat='lat', lon='long', geometry="polygon", group='group')
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
#' 
#' # From SpatialRings
#' library("rgeos")
#' r1 <- Ring(cbind(x=c(1,1,2,2,1), y=c(1,2,2,1,1)), ID="1")
#' r2 <- Ring(cbind(x=c(1,1,2,2,1), y=c(1,2,2,1,1)), ID="2")
#' r1r2 <- SpatialRings(list(r1, r2))
#' geojson_list(r1r2)
#' 
#' # From SpatialRingsDataFrame
#' dat <- data.frame(id = c(1,2), value = 3:4)
#' r1r2df <- SpatialRingsDataFrame(r1r2, data = dat)
#' geojson_list(r1r2df)
#' 
#' # From SpatialPixels
#' library("sp")
#' pixels <- suppressWarnings(SpatialPixels(SpatialPoints(us_cities[c("long", "lat")])))
#' summary(pixels)
#' geojson_list(pixels)
#' 
#' # From SpatialPixelsDataFrame
#' library("sp")
#' pixelsdf <- suppressWarnings(
#'  SpatialPixelsDataFrame(points = canada_cities[c("long", "lat")], data = canada_cities)
#' )
#' geojson_list(pixelsdf)
#' 
#' # From SpatialCollections
#' library("sp")
#' poly1 <- Polygons(list(Polygon(cbind(c(-100,-90,-85,-100), c(40,50,45,40)))), "1")
#' poly2 <- Polygons(list(Polygon(cbind(c(-90,-80,-75,-90), c(30,40,35,30)))), "2")
#' poly <- SpatialPolygons(list(poly1, poly2), 1:2)
#' coordinates(us_cities) <- ~long+lat
#' dat <- SpatialCollections(points = us_cities, polygons = poly)
#' out <- geojson_list(dat)
#' out$SpatialPoints
#' out$SpatialPolygons
#' }

geojson_list <- function(input, lat = NULL, lon = NULL, group = NULL,
                         geometry = "point", type = "FeatureCollection", ...) {
  UseMethod("geojson_list")
}

# spatial classes from sp --------------------------
#' @export
geojson_list.SpatialPolygons <- function(input, lat = NULL, lon = NULL, group = NULL,
                                         geometry = "point", type = "FeatureCollection", ...) {
  as.geo_list(geojson_rw(input), "SpatialPolygons")
}

#' @export
geojson_list.SpatialPolygonsDataFrame <- function(input, lat = NULL, lon = NULL, group = NULL,
                                                  geometry = "point", type = "FeatureCollection", ...) {
  as.geo_list(geojson_rw(input), "SpatialPolygonsDataFrame")
}

#' @export
geojson_list.SpatialPoints <- function(input, lat = NULL, lon = NULL, group = NULL,
                                       geometry = "point", type = "FeatureCollection", ...) {
  dat <- SpatialPointsDataFrame(input, data.frame(dat = 1:NROW(input@coords)))
  as.geo_list(geojson_rw(dat), "SpatialPoints")
}

#' @export
geojson_list.SpatialPointsDataFrame <- function(input, lat = NULL, lon = NULL, group = NULL,
                                                geometry = "point", type = "FeatureCollection", ...) {
  as.geo_list(geojson_rw(input), "SpatialPointsDataFrame")
}

#' @export
geojson_list.SpatialLines <- function(input, lat = NULL, lon = NULL, group = NULL,
                                      geometry = "point", type = "FeatureCollection", ...) {
  as.geo_list(geojson_rw(input), "SpatialLines")
}

#' @export
geojson_list.SpatialLinesDataFrame <- function(input, lat = NULL, lon = NULL, group = NULL,
                                               geometry = "point", type = "FeatureCollection", ...) {
  as.geo_list(geojson_rw(input), "SpatialLinesDataFrame")
}

#' @export
geojson_list.SpatialGrid <- function(input, lat = NULL, lon = NULL, group = NULL,
                                     geometry = "point", type = "FeatureCollection", ...) {
  as.geo_list(geojson_rw(input), "SpatialGrid")
}

#' @export
geojson_list.SpatialGridDataFrame <- function(input, lat = NULL, lon = NULL, group = NULL,
                                              geometry = "point", type = "FeatureCollection", ...) {
  as.geo_list(geojson_rw(input), "SpatialGridDataFrame")
}

#' @export
geojson_list.SpatialPixels <- function(input, lat = NULL, lon = NULL, group = NULL,
                                       geometry = "point",  type='FeatureCollection', ...) {
  as.geo_list(geojson_rw(input), "SpatialPixels")
}

#' @export
geojson_list.SpatialPixelsDataFrame <- function(input, lat = NULL, lon = NULL, group = NULL,
                                                geometry = "point",  type='FeatureCollection', ...) {
  as.geo_list(geojson_rw(input), "SpatialPixelsDataFrame")
}

# spatial classes from rgeos --------------------------
#' @export
geojson_list.SpatialRings <- function(input, lat = NULL, lon = NULL, group = NULL,
                                      geometry = "point",  type='FeatureCollection', ...) {
  as.geo_list(geojson_rw(input), "SpatialRings")
}

#' @export
geojson_list.SpatialRingsDataFrame <- function(input, lat = NULL, lon = NULL, group = NULL,
                                               geometry = "point",  type='FeatureCollection', ...) {
  as.geo_list(geojson_rw(input), "SpatialRingsDataFrame")
}

#' @export
geojson_list.SpatialCollections <- function(input, lat = NULL, lon = NULL, group = NULL,
                                            geometry = "point",  type='FeatureCollection', ...) {
  pt <- donotnull(input@pointobj, geojson_rw)
  ln <- donotnull(input@lineobj, geojson_rw)
  rg <- donotnull(input@ringobj, geojson_rw)
  py <- donotnull(input@polyobj, geojson_rw)
  alldat <- tg_compact(list(SpatialPoints = pt, SpatialLines = ln, 
                            SpatialRings = rg, SpatialPolygons = py))
  as.geo_list(alldat, "SpatialCollections")
}

donotnull <- function(x, fun) {
  if (!is.null(x)) {
    fun(x)
  } else {
    NULL
  }
}

# regular R classes --------------------------
#' @export
geojson_list.numeric <- function(input, lat = NULL, lon = NULL, group = NULL,
                                 geometry = "point", type = "FeatureCollection", ...) {
  as.geo_list(num_to_geo_list(input, geometry, type), "numeric")
}

#' @export
geojson_list.data.frame <- function(input, lat = NULL, lon = NULL, group = NULL,
                                    geometry = "point", type = "FeatureCollection", ...) {

  tmp <- guess_latlon(names(input), lat, lon)
  as.geo_list(df_to_geo_list(x = input, lat = tmp$lat, lon = tmp$lon, 
                             geometry = geometry, type = type, group = group), "data.frame")
}

#' @export
geojson_list.list <- function(input, lat = NULL, lon = NULL, group = NULL,
                              geometry = "point", type = "FeatureCollection", ...) {

  if (geometry == "polygon") lint_polygon_list(input)
  tmp <- if (!is.named(input)) {
    list(lon = NULL, lat = NULL)
  } else {
    guess_latlon(names(input[[1]]), lat, lon)
  }
  as.geo_list(list_to_geo_list(input, lat = tmp$lat, lon = tmp$lon, 
                               geometry, type, !is.named(input), group), "list")
}

#' @export
geojson_list.geo_list <- function(input, lat = NULL, lon = NULL, group = NULL,
                              geometry = "point", type = "FeatureCollection", ...) {
  
  return(input)
}

#' @export
geojson_list.json <- function(input, lat = NULL, lon = NULL, group = NULL,
                              geometry = "point", type = "FeatureCollection", ...) {

  output_list <- jsonlite::fromJSON(input, FALSE, ...)
  as.geo_list(output_list, from = "json")
}

as.geo_list <- function(x, from) structure(x, class = "geo_list", from = from)


lint_polygon_list <- function(x) {
  if (!identical(x[[1]], x[[length(x)]])) {
    stop("First and last point in a polygon must be identical", 
         call. = FALSE)
  }
}
