#' Convert many input types with spatial data to geojson specified as a list
#'
#' @export
#'
#' @param input Input list, data.frame, spatial class, or sf class. Inputs can
#' also be dplyr `tbl_df` class since it inherits from `data.frame`
#' @param lat (character) Latitude name. The default is `NULL`, and we
#' attempt to guess.
#' @param lon (character) Longitude name. The default is `NULL`, and we
#' attempt to guess.
#' @param geometry (character) One of point (Default) or polygon.
#' @param type (character) The type of collection. One of FeatureCollection
#' (default) or GeometryCollection.
#' @param group (character) A grouping variable to perform grouping for
#' polygons - doesn't apply for points
#' @param precision (integer) desired number of decimal places for coordinates.
#' Only used with classes from \pkg{sp}\pkg{rgeos} classes; ignored for other
#' classes. Using fewer decimal places decreases object sizes (at the
#' cost of precision). This changes the underlying precision stored in the
#' data. `options(digits = <some number>)` changes the maximum number of
#' digits displayed (to find out what yours is set at see
#' `getOption("digits")`); the value of this parameter will change what's
#' displayed in your console up to the value of `getOption("digits")`
#' @param convert_wgs84 Should the input be converted to the
#' [standard CRS for GeoJSON](https://tools.ietf.org/html/rfc7946)
#' (geographic coordinate reference system, using the WGS84 datum, with
#' longitude and latitude units of decimal degrees; EPSG: 4326).
#' Default is `FALSE` though this may change in a future package version.
#' This will only work for `sf` or `Spatial` objects with a CRS
#' already defined. If one is not defined but you know what it is, you
#' may define it in the `crs` argument below.
#' @param crs The CRS of the input if it is not already defined. This can
#' be an epsg code as a four or five digit integer or a valid proj4 string.
#' This argument will be ignored if `convert_wgs84` is `FALSE`
#' or the object already has a CRS.
#' @param ... Ignored
#'
#' @details This function creates a geojson structure as an R list; it does
#' not write a file - see [geojson_write()] for that.
#'
#' Note that all sp class objects will output as `FeatureCollection` objects,
#' while other classes (numeric, list, data.frame) can be output as
#' `FeatureCollection` or `GeometryCollection` objects. We're working
#' on allowing `GeometryCollection` option for sp class objects.
#'
#' Also note that with sp classes we do make a round-trip,
#' using [sf::st_write()] to write GeoJSON to disk, then read it back in.
#' This is fast and we don't have to think
#' about it too much, but this disk round-trip is not ideal.
#'
#' For sf classes (sf, sfc, sfg), the following conversions are made:
#'
#' - sfg: the appropriate geometry `Point, LineString, Polygon, MultiPoint,
#'  MultiLineString, MultiPolygon, GeometryCollection`
#' - sfc: `GeometryCollection`, unless the sfc is length 1, then the geometry
#' as above
#' - sf: `FeatureCollection`
#'
#' For `list` and `data.frame` objects, you don't have to pass in `lat` and
#' `lon` parameters if they are named appropriately (e.g., lat/latitude,
#' lon/long/longitude), as they will be auto-detected. If they can not be
#' found, the function will stop and warn you to specify the parameters
#' specifically.
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
#' vecs <- list(c(100.0,0.0), c(101.0,0.0), c(101.0,1.0),
#'   c(100.0,1.0), c(100.0,0.0))
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
#' ## a data.frame with columsn not named appropriately, but you can
#' ## specify them
#' # dat <- data.frame(a = c(31, 41), b = c(-120, -110))
#' # geojson_list(dat)
#' # geojson_list(dat, lat="a", lon="b")
#'
#' # from data.frame to polygons
#' head(states)
#' geojson_list(states[1:351, ], lat='lat', lon='long',
#'   geometry="polygon", group='group')
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
#' # From SpatialPolygons class with precision agreement
#' x_coord <- c(-114.345703125, -114.345703125, -106.61132812499999,
#'   -106.61132812499999, -114.345703125)
#' y_coord <- c(39.436192999314095, 43.45291889355468, 43.45291889355468,
#'   39.436192999314095, 39.436192999314095)
#' coords <- cbind(x_coord, y_coord)
#' poly <- Polygon(coords)
#' polys <- Polygons(list(poly), 1)
#' sp_poly2 <- SpatialPolygons(list(polys))
#' geojson_list(sp_poly2, geometry = "polygon", precision = 4)
#' geojson_list(sp_poly2, geometry = "polygon", precision = 3)
#' geojson_list(sp_poly2, geometry = "polygon", precision = 2)
#'
#' # From SpatialPoints class with precision
#' points <- SpatialPoints(cbind(x_coord,y_coord))
#' geojson_list(points)
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
#' pixels <- suppressWarnings(
#'   SpatialPixels(SpatialPoints(us_cities[c("long", "lat")])))
#' summary(pixels)
#' geojson_list(pixels)
#'
#' # From SpatialPixelsDataFrame
#' library("sp")
#' pixelsdf <- suppressWarnings(
#'  SpatialPixelsDataFrame(points = canada_cities[c("long", "lat")],
#'  data = canada_cities)
#' )
#' geojson_list(pixelsdf)
#'
#' # From SpatialCollections
#' library("sp")
#' poly1 <- Polygons(
#'   list(Polygon(cbind(c(-100,-90,-85,-100), c(40,50,45,40)))), "1")
#' poly2 <- Polygons(
#'   list(Polygon(cbind(c(-90,-80,-75,-90), c(30,40,35,30)))), "2")
#' poly <- SpatialPolygons(list(poly1, poly2), 1:2)
#' coordinates(us_cities) <- ~long+lat
#' dat <- SpatialCollections(points = us_cities, polygons = poly)
#' out <- geojson_list(dat)
#' out$SpatialPoints
#' out$SpatialPolygons
#' }
#'
#' # From sf classes:
#' if (require(sf)) {
#' ## sfg (a single simple features geometry)
#'   p1 <- rbind(c(0,0), c(1,0), c(3,2), c(2,4), c(1,4), c(0,0))
#'   poly <- rbind(c(1,1), c(1,2), c(2,2), c(1,1))
#'   poly_sfg <-st_polygon(list(p1))
#'   geojson_list(poly_sfg)
#'
#' ## sfc (a collection of geometries)
#'   p1 <- rbind(c(0,0), c(1,0), c(3,2), c(2,4), c(1,4), c(0,0))
#'   p2 <- rbind(c(5,5), c(5,6), c(4,5), c(5,5))
#'   poly_sfc <- st_sfc(st_polygon(list(p1)), st_polygon(list(p2)))
#'   geojson_list(poly_sfc)
#'
#' ## sf (collection of geometries with attributes)
#'   p1 <- rbind(c(0,0), c(1,0), c(3,2), c(2,4), c(1,4), c(0,0))
#'   p2 <- rbind(c(5,5), c(5,6), c(4,5), c(5,5))
#'   poly_sfc <- st_sfc(st_polygon(list(p1)), st_polygon(list(p2)))
#'   poly_sf <- st_sf(foo = c("a", "b"), bar = 1:2, poly_sfc)
#'   geojson_list(poly_sf)
#' }
#'

geojson_list <- function(input, lat = NULL, lon = NULL, group = NULL,
  geometry = "point", type = "FeatureCollection",
  convert_wgs84 = FALSE, crs = NULL, precision = NULL, ...) {
  UseMethod("geojson_list")
}

# spatial classes from sp --------------------------
#' @export
geojson_list.SpatialPolygons <- function(input, lat = NULL, lon = NULL,
  group = NULL, geometry = "point", type = "FeatureCollection",
  convert_wgs84 = FALSE, crs = NULL, precision = NULL,  ...) {
  as.geo_list(geojson_rw(input, target = "list", precision = precision,
    convert_wgs84 = convert_wgs84, crs = crs), "SpatialPolygons")
}

#' @export
geojson_list.SpatialPolygonsDataFrame <- function(input, lat = NULL, lon = NULL,
  group = NULL, geometry = "point", type = "FeatureCollection",
  convert_wgs84 = FALSE, crs = NULL, precision = NULL,  ...) {
  as.geo_list(geojson_rw(input, target = "list", precision = precision,
    convert_wgs84 = convert_wgs84, crs = crs), "SpatialPolygonsDataFrame")
}

#' @export
geojson_list.SpatialPoints <- function(input, lat = NULL, lon = NULL,
  group = NULL, geometry = "point", type = "FeatureCollection",
  convert_wgs84 = FALSE, crs = NULL, precision = NULL,  ...) {
  dat <- SpatialPointsDataFrame(input, data.frame(dat = 1:NROW(input@coords)))
  as.geo_list(geojson_rw(dat, target = "list", precision = precision,
    convert_wgs84 = convert_wgs84, crs = crs), "SpatialPoints")
}

#' @export
geojson_list.SpatialPointsDataFrame <- function(input, lat = NULL, lon = NULL,
  group = NULL, geometry = "point", type = "FeatureCollection",
  convert_wgs84 = FALSE, crs = NULL, precision = NULL,  ...) {
  as.geo_list(geojson_rw(input, target = "list", precision = precision,
    convert_wgs84 = convert_wgs84, crs = crs), "SpatialPointsDataFrame")
}

#' @export
geojson_list.SpatialLines <- function(input, lat = NULL, lon = NULL,
  group = NULL, geometry = "point", type = "FeatureCollection",
  convert_wgs84 = FALSE, crs = NULL, precision = NULL,  ...) {
  as.geo_list(geojson_rw(input, target = "list", precision = precision,
    convert_wgs84 = convert_wgs84, crs = crs), "SpatialLines")
}

#' @export
geojson_list.SpatialLinesDataFrame <- function(input, lat = NULL, lon = NULL,
  group = NULL, geometry = "point", type = "FeatureCollection",
  convert_wgs84 = FALSE, crs = NULL, precision = NULL,  ...) {
  as.geo_list(geojson_rw(input, target = "list", precision = precision,
    convert_wgs84 = convert_wgs84, crs = crs), "SpatialLinesDataFrame")
}

#' @export
geojson_list.SpatialGrid <- function(input, lat = NULL, lon = NULL,
  group = NULL, geometry = "point", type = "FeatureCollection",
  convert_wgs84 = FALSE, crs = NULL, precision = NULL,  ...) {
  as.geo_list(geojson_rw(input, target = "list", precision = precision,
    convert_wgs84 = convert_wgs84, crs = crs), "SpatialGrid")
}

#' @export
geojson_list.SpatialGridDataFrame <- function(input, lat = NULL, lon = NULL,
  group = NULL, geometry = "point", type = "FeatureCollection",
  convert_wgs84 = FALSE, crs = NULL, precision = NULL,  ...) {
  as.geo_list(geojson_rw(input, target = "list", precision = precision,
    convert_wgs84 = convert_wgs84, crs = crs), "SpatialGridDataFrame")
}

#' @export
geojson_list.SpatialPixels <- function(input, lat = NULL, lon = NULL,
  group = NULL, geometry = "point", type='FeatureCollection',
  convert_wgs84 = FALSE, crs = NULL, precision = NULL,  ...) {
  as.geo_list(geojson_rw(input, target = "list", precision = precision,
    convert_wgs84 = convert_wgs84, crs = crs), "SpatialPixels")
}

#' @export
geojson_list.SpatialPixelsDataFrame <- function(input, lat = NULL, lon = NULL,
  group = NULL, geometry = "point", type = "FeatureCollection",
  convert_wgs84 = FALSE, crs = NULL, precision = NULL,  ...) {
  as.geo_list(geojson_rw(input, target = "list", precision = precision,
    convert_wgs84 = convert_wgs84, crs = crs), "SpatialPixelsDataFrame")
}

# spatial classes from rgeos --------------------------
#' @export
geojson_list.SpatialRings <- function(input, lat = NULL, lon = NULL,
  group = NULL, geometry = "point",  type='FeatureCollection',
  convert_wgs84 = FALSE, crs = NULL, precision = NULL,  ...) {
  as.geo_list(geojson_rw(input, target = "list", precision = precision,
    convert_wgs84 = convert_wgs84, crs = crs), "SpatialRings")
}

#' @export
geojson_list.SpatialRingsDataFrame <- function(input, lat = NULL, lon = NULL,
  group = NULL, geometry = "point", type = "FeatureCollection",
  convert_wgs84 = FALSE, crs = NULL, precision = NULL,  ...) {
  as.geo_list(geojson_rw(input, target = "list", precision = precision,
    convert_wgs84 = convert_wgs84, crs = crs), "SpatialRingsDataFrame")
}

#' @export
geojson_list.SpatialCollections <- function(input, lat = NULL, lon = NULL,
  group = NULL, geometry = "point", type = "FeatureCollection",
  convert_wgs84 = FALSE, crs = NULL, precision = NULL,  ...) {

  pt <- donotnull(input@pointobj, geojson_rw, target = "list",
                  convert_wgs84 = convert_wgs84, crs = crs,
                  precision = precision)
  ln <- donotnull(input@lineobj, geojson_rw, target = "list",
                  convert_wgs84 = convert_wgs84, crs = crs,
                  precision = precision)
  rg <- donotnull(input@ringobj, geojson_rw, target = "list",
                  convert_wgs84 = convert_wgs84, crs = crs,
                  precision = precision)
  py <- donotnull(input@polyobj, geojson_rw, target = "list",
                  convert_wgs84 = convert_wgs84, crs = crs,
                  precision = precision)
  alldat <- tg_compact(list(SpatialPoints = pt, SpatialLines = ln,
                            SpatialRings = rg, SpatialPolygons = py))
  as.geo_list(alldat, "SpatialCollections")
}

donotnull <- function(x, fun, ...) {
  if (!is.null(x)) {
    fun(x, ...)
  } else {
    NULL
  }
}

# sf classes ---------------------------------

#' @export
geojson_list.sf <- function(input, lat = NULL, lon = NULL, group = NULL,
  geometry = "point", type = "FeatureCollection",
  convert_wgs84 = FALSE, crs = NULL, ...) {
  if (convert_wgs84) {
    input <- convert_wgs84(input, crs)
  }

  sf_col <- get_sf_column_name(input)
  ## Get the sfc column
  sfc <- unclass(input[[sf_col]])
  ## remove the sf class so can extract the attributes using `[`
  attr_df <- as.data.frame(input)[, setdiff(names(input), sf_col),
                                  drop = FALSE]

  type <- "FeatureCollection"
  features <- lapply(seq_len(nrow(input)),
                     function(i) {
                       list(type = "Feature",
                            properties = as.list(attr_df[i, , drop = FALSE]),
                            geometry = unclass(geojson_list(sfc[[i]]))
                       )
                     })

  out <- list(type = type, features = features)

  as.geo_list(tg_compact(out), from = "sf")
}

#' @export
geojson_list.sfc <- function(input, lat = NULL, lon = NULL, group = NULL,
  geometry = "point", type = "FeatureCollection", convert_wgs84 = FALSE,
  crs = NULL, ...) {
  ## Remove names of input otherwise produces invalid geojson
  names(input) <- NULL

  if (convert_wgs84) {
    input <- convert_wgs84(input, crs)
  }
  ## A GeometryCollection except if length 1, then just return the geometry

  if (length(input) == 1) {
    return(geojson_list(input[[1]]))
  } else {
    out <- list(
      type = "GeometryCollection",
      geometries = lapply(input, function(x) unclass(geojson_list(x)))
    )
  }
  as.geo_list(out, from = "sfc")
}

#' @export
geojson_list.sfg <- function(input, lat = NULL, lon = NULL, group = NULL,
  geometry = "point", type = "FeatureCollection",
  convert_wgs84 = FALSE, crs = NULL, ...) {

  type <-  switch_geom_type(get_geometry_type(input))

  if (type == "GeometryCollection") {
    geometries <- lapply(input, function(x) unclass(geojson_list(x)))
    out <- list(type = type, geometries = geometries)
  } else {
    coordinates <- make_coords(input)
    out <- list(type = type, coordinates = coordinates)
  }
  as.geo_list(out, from = "sfg")
}

switch_geom_type <- function(x) {
  switch(x,
         "POINT" = "Point",
         "LINESTRING" = "LineString",
         "POLYGON" = "Polygon",
         "MULTIPOINT" = "MultiPoint",
         "MULTILINESTRING" = "MultiLineString",
         "MULTIPOLYGON" = "MultiPolygon",
         "GEOMETRY" = "GeometryCollection",
         "GEOMETRYCOLLECTION" = "GeometryCollection"
  )
}

get_sf_column_name <- function(x) attr(x, "sf_column")

## Get the geometry type
get_geometry_type <- function(x) UseMethod("get_geometry_type")
get_geometry_type.sfc <- function(x) strsplit(class(x)[1], "_")[[1]][2]
get_geometry_type.sfg <- function(x) class(x)[2]

## Make coordinates, dropping M dimension if it's there
make_coords <- function(input) {
  dim <- class(input)[1]
  m_loc <- regexpr("M", dim)

  if (m_loc > 0) {
    message("removing M dimension as not supported in GeoJSON format")
    return(drop_m(unclass(input), m_loc))
  }

  unclass(input)
}

drop_m <- function(input, m_loc) UseMethod("drop_m")
drop_m.list <- function(input, m_loc) lapply(input, drop_m, m_loc = m_loc)
drop_m.numeric <- function(input, m_loc) input[-m_loc]
drop_m.matrix <- function(input, m_loc) input[, -m_loc, drop = FALSE]

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
