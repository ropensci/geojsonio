#' Convert many input types with spatial data to a geojson file
#'
#' @import methods rgeos sp
#' @importFrom jsonlite toJSON fromJSON unbox
#' @export
#'
#' @param input Input list, data.frame, or spatial class. Inputs can also be dplyr \code{tbl_df}
#' class since it inherits from \code{data.frame}.
#' @param lat (character) Latitude name. The default is \code{NULL}, and we attempt to guess.
#' @param lon (character) Longitude name. The default is \code{NULL}, and we attempt to guess.
#' @param geometry (character) One of point (Default) or polygon.
#' @param group (character) A grouping variable to perform grouping for polygons - doesn't apply for points
#' @param file (character) A path and file name (e.g., myfile), with the \code{.geojson} file extension
#' @param ... Further args passed on to \code{\link[rgdal]{writeOGR}}
#'
#' @seealso \code{\link{geojson_list}}, \code{\link{geojson_json}}
#'
#' @examples \dontrun{
#' # From a data.frame
#' ## to points
#' geojson_write(us_cities[1:2,], lat='lat', lon='long')
#'
#' ## to polygons
#' head(states)
#' geojson_write(input=states, lat='lat', lon='long', geometry='group', group="group")
#'
#' ## partial states dataset to points (defaults to points)
#' geojson_write(input=states, lat='lat', lon='long')
#'
#' ## Lists
#' ### list of numeric pairs
#' poly <- list(c(-114.345703125,39.436192999314095),
#'           c(-114.345703125,43.45291889355468),
#'           c(-106.61132812499999,43.45291889355468),
#'           c(-106.61132812499999,39.436192999314095),
#'           c(-114.345703125,39.436192999314095))
#' geojson_write(poly, geometry = "polygon")
#'
#' ### named list
#' mylist <- list(list(latitude=30, longitude=120, marker="red"),
#'                list(latitude=30, longitude=130, marker="blue"))
#' geojson_write(mylist)
#'
#' # From a numeric vector of length 2
#' vec <- c(-99.74, 32.45)
#' geojson_write(vec)
#'
#' ## polygon from a series of numeric pairs
#' ### this requires numeric class input, so inputting a list will
#' ### dispatch on the list method
#' poly <- c(c(-114.345703125,39.436192999314095),
#'           c(-114.345703125,43.45291889355468),
#'           c(-106.61132812499999,43.45291889355468),
#'           c(-106.61132812499999,39.436192999314095),
#'           c(-114.345703125,39.436192999314095))
#' geojson_write(poly, geometry = "polygon")
#'
#' # Write output of geojson_list to file
#' res <- geojson_list(us_cities[1:2,], lat='lat', lon='long')
#' class(res)
#' geojson_write(res)
#'
#' # Write output of geojson_json to file
#' res <- geojson_json(us_cities[1:2,], lat='lat', lon='long')
#' class(res)
#' geojson_write(res)
#'
#' # From SpatialPolygons class
#' library('sp')
#' poly1 <- Polygons(list(Polygon(cbind(c(-100,-90,-85,-100),
#'    c(40,50,45,40)))), "1")
#' poly2 <- Polygons(list(Polygon(cbind(c(-90,-80,-75,-90),
#'    c(30,40,35,30)))), "2")
#' sp_poly <- SpatialPolygons(list(poly1, poly2), 1:2)
#' geojson_write(sp_poly)
#'
#' # From SpatialPolygonsDataFrame class
#' sp_polydf <- as(sp_poly, "SpatialPolygonsDataFrame")
#' geojson_write(input = sp_polydf)
#' geojson_write(input = sp_polydf, file = "~/stuff")
#'
#' # From SpatialGrid
#' x <- GridTopology(c(0,0), c(1,1), c(5,5))
#' y <- SpatialGrid(x)
#' geojson_write(y)
#'
#' # From SpatialGridDataFrame
#' sgdim <- c(3,4)
#' sg <- SpatialGrid(GridTopology(rep(0,2), rep(10,2), sgdim))
#' sgdf <- SpatialGridDataFrame(sg, data.frame(val = 1:12))
#' geojson_write(sgdf)
#'
#' # From SpatialRings
#' r1 <- Ring(cbind(x=c(1,1,2,2,1), y=c(1,2,2,1,1)), ID="1")
#' r2 <- Ring(cbind(x=c(1,1,2,2,1), y=c(1,2,2,1,1)), ID="2")
#' r1r2 <- SpatialRings(list(r1, r2))
#' geojson_write(r1r2)
#'
#' # From SpatialRingsDataFrame
#' dat <- data.frame(id = c(1,2), value = 3:4)
#' r1r2df <- SpatialRingsDataFrame(r1r2, data = dat)
#' geojson_write(r1r2df)
#'
#' # From SpatialPixels
#' library("sp")
#' pixels <- suppressWarnings(SpatialPixels(SpatialPoints(us_cities[c("long", "lat")])))
#' summary(pixels)
#' geojson_write(pixels)
#'
#' # From SpatialPixelsDataFrame
#' library("sp")
#' pixelsdf <- suppressWarnings(
#'  SpatialPixelsDataFrame(points = canada_cities[c("long", "lat")], data = canada_cities)
#' )
#' geojson_write(pixelsdf)
#'
#' # From SpatialCollections
#' library("sp")
#' poly1 <- Polygons(list(Polygon(cbind(c(-100,-90,-85,-100), c(40,50,45,40)))), "1")
#' poly2 <- Polygons(list(Polygon(cbind(c(-90,-80,-75,-90), c(30,40,35,30)))), "2")
#' poly <- SpatialPolygons(list(poly1, poly2), 1:2)
#' coordinates(us_cities) <- ~long+lat
#' dat <- SpatialCollections(points = us_cities, polygons = poly)
#' geojson_write(dat)
#' }

geojson_write <- function(input, lat = NULL, lon = NULL, geometry = "point",
                          group = NULL, file = "myfile.geojson", ...) {
  UseMethod("geojson_write")
}

## sp R classes -----------------
#' @export
geojson_write.SpatialPolygons <- function(input, lat = NULL, lon = NULL, geometry = "point",
                                          group = NULL, file = "myfile.geojson", ...) {
  write_geojson(as(input, "SpatialPolygonsDataFrame"), file, ...)
  return(file)
}

#' @export
geojson_write.SpatialPolygonsDataFrame <- function(input, lat = NULL, lon = NULL, geometry = "point",
                                                   group = NULL, file = "myfile.geojson", ...) {
  write_geojson(input, file, ...)
  return(file)
}

#' @export
geojson_write.SpatialPoints <- function(input, lat = NULL, lon = NULL, geometry = "point",
                                        group = NULL, file = "myfile.geojson", ...) {
  write_geojson(as(input, "SpatialPointsDataFrame"), file, ...)
  return(file)
}

#' @export
geojson_write.SpatialPointsDataFrame <- function(input, lat = NULL, lon = NULL, geometry = "point",
                                                 group = NULL, file = "myfile.geojson", ...) {
  write_geojson(input, file, ...)
  return(file)
}

#' @export
geojson_write.SpatialLines <- function(input, lat = NULL, lon = NULL, geometry = "point",
                                       group = NULL, file = "myfile.geojson", ...) {
  write_geojson(as(input, "SpatialLinesDataFrame"), file, ...)
  return(file)
}

#' @export
geojson_write.SpatialLinesDataFrame <- function(input, lat = NULL, lon = NULL, geometry = "point",
                                                group = NULL, file = "myfile.geojson", ...) {
  write_geojson(input, file, ...)
  return(file)
}

#' @export
geojson_write.SpatialGrid <- function(input, lat = NULL, lon = NULL, geometry = "point",
                                      group = NULL, file = "myfile.geojson", ...) {
  size <- prod(input@grid@cells.dim)
  input <- SpatialGridDataFrame(input, data.frame(val=rep(1, size)))
  write_geojson(input, file, ...)
  return(file)
}

#' @export
geojson_write.SpatialGridDataFrame <- function(input, lat = NULL, lon = NULL, geometry = "point",
                                               group = NULL, file = "myfile.geojson", ...) {
  write_geojson(as(input, "SpatialPointsDataFrame"), file, ...)
  return(file)
}

#' @export
geojson_write.SpatialGridDataFrame <- function(input, lat = NULL, lon = NULL, geometry = "point",
                                               group = NULL, file = "myfile.geojson", ...) {
  write_geojson(as(input, "SpatialPointsDataFrame"), file, ...)
  return(file)
}

#' @export
geojson_write.SpatialRings <- function(input, lat = NULL, lon = NULL, geometry = "point",
                                               group = NULL, file = "myfile.geojson", ...) {
  write_geojson(as(input, "SpatialPolygonsDataFrame"), file, ...)
  return(file)
}

#' @export
geojson_write.SpatialRingsDataFrame <- function(input, lat = NULL, lon = NULL, geometry = "point",
                                       group = NULL, file = "myfile.geojson", ...) {
  write_geojson(as(input, "SpatialPolygonsDataFrame"), file, ...)
  return(file)
}

#' @export
geojson_write.SpatialPixels <- function(input, lat = NULL, lon = NULL, geometry = "point",
                                       group = NULL, file = "myfile.geojson", ...) {
  write_geojson(as(input, "SpatialPointsDataFrame"), file, ...)
  return(file)
}

#' @export
geojson_write.SpatialPixelsDataFrame <- function(input, lat = NULL, lon = NULL, geometry = "point",
                                                group = NULL, file = "myfile.geojson", ...) {
  write_geojson(as(input, "SpatialPointsDataFrame"), file, ...)
  return(file)
}

#' @export
geojson_write.SpatialCollections <- function(input, lat = NULL, lon = NULL, geometry = "point",
                                                 group = NULL, file = "myfile.geojson", ...) {
  ptfile <- iter_spatialcoll(input@pointobj, file, ...)
  lfile <- iter_spatialcoll(input@lineobj, file, ...)
  rfile <- iter_spatialcoll(input@ringobj, file, ...)
  pyfile <- iter_spatialcoll(input@polyobj, file, ...)
  return(c(ptfile, lfile, rfile, pyfile))
}

iter_spatialcoll <- function(z, file, ...) {
  wfile <- paste0(class(z)[1], "_", file)
  if (!is.null(z)) {
    geojson_write(z, file = wfile, ...)
  }
}

## normal R classes -----------------
#' @export
geojson_write.numeric <- function(input, lat = NULL, lon = NULL, geometry = "point",
                                  group = NULL, file = "myfile.geojson", ...) {
  if (geometry == "point") {
    res <- df_to_SpatialPointsDataFrame(num2df(input, lat, lon), lon = lon, lat = lat)
  } else {
    res <- df_to_SpatialPolygonsDataFrame(input)
  }
  write_geojson(res, file, ...)
  return(file)
}

num2df <- function(x, lat, lon) {
  setNames(data.frame(rbind(x), stringsAsFactors = FALSE, row.names = NULL), c(lat, lon))
}

#' @export
geojson_write.data.frame <- function(input, lat = NULL, lon = NULL, geometry = "point",
                                     group = NULL, file = "myfile.geojson", ...) {
  tmp <- guess_latlon(names(input), lat, lon)
  if (geometry == "point") {
    res <- df_to_SpatialPointsDataFrame(input, tmp$lon, tmp$lat)
  } else {
    res <- df_to_SpatialPolygonsDataFrame2(input, tmp$lat, tmp$lon, group)
  }
  write_geojson(res, file, ...)
  as.geojson(file, "data.frame")
  return(file)
}

#' @export
geojson_write.list <- function(input, lat = NULL, lon = NULL, geometry="point",
                               group = NULL, file = "myfile.geojson", ...) {
  if(is.named(input)) {
    tmp <- guess_latlon(names(input[[1]]), lat, lon)
    res <- list_to_geo_list(input, tmp$lat, tmp$lon, geometry)
    list_to_geojson(res, lat=tmp$lat, lon=tmp$lon, geometry=geometry, ...)
  } else {
    if(geometry == "point") {
      res <- list_to_SpatialPointsDataFrame(input, lon = lon, lat = lat)
    } else {
      res <- list_to_SpatialPolygonsDataFrame(input, lat, lon)
    }
    write_geojson(res, file, ...)
  }
  return(file)
}

#' @export
geojson_write.geo_list <- function(input, lat = NULL, lon = NULL, geometry = "point",
                                   group = NULL, file = "myfile.geojson", ...) {
  cat(as.json(input, pretty=TRUE), file=file)
  message("Success! File is at ", file)
  return(file)
}

#' @export
geojson_write.json <- function(input, lat = NULL, lon = NULL, geometry = "point",
                               group = NULL, file = "myfile.geojson", ...) {
  cat(toJSON(jsonlite::fromJSON(input), pretty=TRUE, auto_unbox = TRUE), file=file)
  message("Success! File is at ", file)
  return(file)
}

#' @export
print.geojson <- function(x, ...) {
  cat("<geojson>", "\n", sep = "")
  cat("  Path:       ", x$path, "\n", sep = "")
  cat("  From class: ", x$type, "\n", sep = "")
}

as.geojson <- function(path, type) {
  structure(list(path=path, type=type), class="geojson")
}
