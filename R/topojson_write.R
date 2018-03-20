#' Write TopoJSON from various inputs
#'
#' @export
#'
#' @inheritParams geojson_write
#' @param object_name (character) name to give to the TopoJSON object created.
#' Default: "foo"
#' @return A \code{topojson_write} class, with two elements:
#' \itemize{
#'  \item path: path to the file with the TopoJSON
#'  \item type: type of object the TopoJSON came from, e.g., SpatialPoints
#' }
#' @seealso \code{\link{geojson_write}}, \code{\link{topojson_read}}
#' @details Under the hood we simply wrap \code{\link{geojson_write}}, then
#' take the GeoJSON output of that operation, then convert to TopoJSON with
#' \code{\link{geo2topo}}, then write to disk.
#'
#' Unfortunately, this process requires a number of round trips to disk, so
#' speed ups will hopefully come soon.
#'
#' Any intermediate geojson files are cleaned up (deleted).
#'
#' @examples
#' # From a data.frame
#' ## to points
#' topojson_write(us_cities[1:2,], lat='lat', lon='long')
#'
#' ## to polygons
#' head(states)
#' topojson_write(input=states, lat='lat', lon='long',
#'   geometry='polygon', group="group")
#'
#' \dontrun{
#' ## partial states dataset to points (defaults to points)
#' topojson_write(input=states, lat='lat', lon='long')
#'
#' ## Lists
#' ### list of numeric pairs
#' poly <- list(c(-114.345703125,39.436192999314095),
#'           c(-114.345703125,43.45291889355468),
#'           c(-106.61132812499999,43.45291889355468),
#'           c(-106.61132812499999,39.436192999314095),
#'           c(-114.345703125,39.436192999314095))
#' topojson_write(poly, geometry = "polygon")
#'
#' ### named list
#' mylist <- list(list(latitude=30, longitude=120, marker="red"),
#'                list(latitude=30, longitude=130, marker="blue"))
#' topojson_write(mylist)
#'
#' # From a numeric vector of length 2
#' ## Expected order is lon, lat
#' vec <- c(-99.74, 32.45)
#' topojson_write(vec)
#'
#' # from TopoJSON as JSON
#' x <- system.file("examples/point.json", package = "geojsonio")
#' tj <- structure(paste0(readLines(x), collapse = ""), class = "json")
#' topojson_write(tj, file = "my.topojson")
#'
#' # convert GeoJSON to TopoJSON, then write
#' x <- '{"type": "LineString", "coordinates": [ [100.0, 0.0], [101.0, 1.0] ]}'
#' topojson_write(geo2topo(x), file = "out.topojson")
#'
#' # SpatialPoints class
#' library(sp)
#' x <- c(1,2,3,4,5)
#' y <- c(3,2,5,1,4)
#' s <- SpatialPoints(cbind(x,y))
#' res <- topojson_write(s, file = "out.topojson")
#' readLines("out.topojson")
#'
#' # SpatialPointsDataFrame class
#' s <- SpatialPointsDataFrame(cbind(x,y), mtcars[1:5,])
#' topojson_write(s, file = "out.topojson")
#' readLines("out.topojson")
#'
#' # SpatialLines class
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
#' topojson_write(sl1, file = "out.topojson")
#' readLines("out.topojson")
#'
#' # SpatialLinesDataFrame class
#' dat <- data.frame(X = c("Blue", "Green"),
#'                  Y = c("Train", "Plane"),
#'                  Z = c("Road", "River"), row.names = c("a", "b"))
#' sldf <- SpatialLinesDataFrame(sl12, dat)
#' topojson_write(sldf, file = "out.topojson")
#' readLines("out.topojson")
#'
#' # SpatialPolygons class
#' library('sp')
#' poly1 <- Polygons(list(Polygon(cbind(c(-100,-90,-85,-100),
#'    c(40,50,45,40)))), "1")
#' poly2 <- Polygons(list(Polygon(cbind(c(-90,-80,-75,-90),
#'    c(30,40,35,30)))), "2")
#' sp_poly <- SpatialPolygons(list(poly1, poly2), 1:2)
#' res <- topojson_write(sp_poly, file = "out.topojson")
#' readLines(res$path)
#'
#' # From SpatialPolygonsDataFrame class
#' sp_polydf <- as(sp_poly, "SpatialPolygonsDataFrame")
#' res <- topojson_write(sp_polydf, file = "out.topojson")
#' readLines(res$path)
#'
#' # From SpatialGrid
#' x <- GridTopology(c(0,0), c(1,1), c(5,5))
#' y <- SpatialGrid(x)
#' topojson_write(y)
#'
#' # From SpatialGrid
#' x <- GridTopology(c(0,0), c(1,1), c(5,5))
#' y <- SpatialGrid(x)
#' res <- topojson_write(y)
#' readLines(res$path)
#'
#' # From SpatialGridDataFrame
#' sgdim <- c(3,4)
#' sg <- SpatialGrid(GridTopology(rep(0,2), rep(10,2), sgdim))
#' sgdf <- SpatialGridDataFrame(sg, data.frame(val = 1:12))
#' topojson_write(sgdf)
#'
#' # From SpatialPixels
#' library("sp")
#' pixels <- suppressWarnings(SpatialPixels(SpatialPoints(us_cities[c("long", "lat")])))
#' summary(pixels)
#' topojson_write(pixels)
#'
#' # From SpatialPixelsDataFrame
#' library("sp")
#' pixelsdf <- suppressWarnings(
#'  SpatialPixelsDataFrame(points = canada_cities[c("long", "lat")], data = canada_cities)
#' )
#' topojson_write(pixelsdf)
#'
#' # From SpatialRings
#' library(rgeos)
#' r1 <- Ring(cbind(x=c(1,1,2,2,1), y=c(1,2,2,1,1)), ID="1")
#' r2 <- Ring(cbind(x=c(1,1,2,2,1), y=c(1,2,2,1,1)), ID="2")
#' r1r2 <- SpatialRings(list(r1, r2))
#' class(r1r2)
#' topojson_write(r1r2)
#'
#' # From SpatialRingsDataFrame
#' dat <- data.frame(id = c(1,2), value = 3:4)
#' r1r2df <- SpatialRingsDataFrame(r1r2, data = dat)
#' geojson_write(r1r2df)
#'
#' # From SpatialCollections
#' library("sp")
#' library("rgeos")
#' poly1 <- Polygons(list(Polygon(cbind(c(-100,-90,-85,-100), c(40,50,45,40)))), "1")
#' poly2 <- Polygons(list(Polygon(cbind(c(-90,-80,-75,-90), c(30,40,35,30)))), "2")
#' poly <- SpatialPolygons(list(poly1, poly2), 1:2)
#' coordinates(us_cities) <- ~long+lat
#' dat <- SpatialCollections(points = us_cities, polygons = poly)
#' topojson_write(dat)
#'
#' # From sf classes:
#' if (require(sf)) {
#'   file <- system.file("examples", "feature_collection.geojson", package = "geojsonio")
#'   sf_fc <- st_read(file, quiet = TRUE)
#'   topojson_write(sf_fc)
#' }
#' 
#' # Change the object name created
#' vec <- c(-99.74, 32.45)
#' x <- topojson_write(vec, object_name = "California")
#' readLines(x$path)
#' }
topojson_write <- function(input, lat = NULL, lon = NULL, geometry = "point",
                           group = NULL, file = "myfile.topojson",
                           overwrite = TRUE, precision = NULL,
                           convert_wgs84 = FALSE, crs = NULL, 
                           object_name = "foo", ...) {
  UseMethod("topojson_write")
}

## stop if no matching method
#' @export
topojson_write.default <- function(input, lat = NULL, lon = NULL, geometry = "point",
                                           group = NULL, file = "myfile.topojson",
                                           overwrite = TRUE, precision = NULL,
                                           convert_wgs84 = FALSE, crs = NULL, 
                                           object_name = "foo", ...) {
  stop("no 'topojson_write' method for ", class(input), call. = FALSE)
}

#' @export
topojson_write.SpatialPolygons <- function(input, lat = NULL, lon = NULL, geometry = "point",
                                           group = NULL, file = "myfile.topojson",
                                           overwrite = TRUE, precision = NULL,
                                           convert_wgs84 = FALSE, crs = NULL, 
                                           object_name = "foo", ...) {

  sp_helper(input, file = file, precision = precision,
            convert_wgs84 = convert_wgs84, crs = crs,
            class = "SpatialPolygons", object_name = object_name, ...)
}

#' @export
topojson_write.SpatialPolygonsDataFrame <- function(input, lat = NULL, lon = NULL, geometry = "point",
                                                    group = NULL, file = "myfile.topojson",
                                                    overwrite = TRUE, precision = NULL,
                                                    convert_wgs84 = FALSE, crs = NULL, 
                                                    object_name = "foo", ...) {

  sp_helper(input, file = file, precision = precision,
            convert_wgs84 = convert_wgs84, crs = crs,
            class = "SpatialPolygonsDataFrame", object_name = object_name, ...)
}

#' @export
topojson_write.SpatialPoints <- function(input, lat = NULL, lon = NULL, geometry = "point",
                                         group = NULL, file = "myfile.topojson",
                                         overwrite = TRUE, precision = NULL,
                                         convert_wgs84 = FALSE, crs = NULL, 
                                         object_name = "foo", ...) {

  sp_helper(input, file = file, precision = precision,
            convert_wgs84 = convert_wgs84, crs = crs,
            class = "SpatialPoints", object_name = object_name, ...)
}

#' @export
topojson_write.SpatialPointsDataFrame <- function(input, lat = NULL, lon = NULL, geometry = "point",
                                                  group = NULL, file = "myfile.topojson",
                                                  overwrite = TRUE, precision = NULL,
                                                  convert_wgs84 = FALSE, crs = NULL, 
                                                  object_name = "foo", ...) {

  sp_helper(input, file = file, precision = precision,
            convert_wgs84 = convert_wgs84, crs = crs,
            class = "SpatialPointsDataFrame", object_name = object_name, ...)
}

#' @export
topojson_write.SpatialLines <- function(input, lat = NULL, lon = NULL, geometry = "point",
                                        group = NULL, file = "myfile.topojson",
                                        overwrite = TRUE, precision = NULL,
                                        convert_wgs84 = FALSE, crs = NULL, 
                                        object_name = "foo", ...) {

  sp_helper(input, file = file, precision = precision,
            convert_wgs84 = convert_wgs84, crs = crs,
            class = "SpatialLines", object_name = object_name, ...)
}

#' @export
topojson_write.SpatialLinesDataFrame <- function(input, lat = NULL, lon = NULL, geometry = "point",
                                                 group = NULL, file = "myfile.topojson",
                                                 overwrite = TRUE, precision = NULL,
                                                 convert_wgs84 = FALSE, crs = NULL, 
                                                 object_name = "foo", ...) {

  sp_helper(input, file = file, precision = precision,
            convert_wgs84 = convert_wgs84, crs = crs,
            class = "SpatialLinesDataFrame", object_name = object_name, ...)
}

#' @export
topojson_write.SpatialGrid <- function(input, lat = NULL, lon = NULL, geometry = "point",
  group = NULL, file = "myfile.topojson", overwrite = TRUE, precision = NULL,
  convert_wgs84 = FALSE, crs = NULL, object_name = "foo", ...) {

  sp_helper(input, file = file, precision = precision,
            convert_wgs84 = convert_wgs84, crs = crs,
            class = "SpatialGrid", object_name = object_name, ...)
}

#' @export
topojson_write.SpatialGridDataFrame <- function(input, lat = NULL, lon = NULL,
  geometry = "point", group = NULL, file = "myfile.topojson",
  overwrite = TRUE, precision = NULL, convert_wgs84 = FALSE, crs = NULL, 
  object_name = "foo", ...) {

  sp_helper(input, file = file, precision = precision,
            convert_wgs84 = convert_wgs84, crs = crs,
            class = "SpatialGridDataFrame", object_name = object_name, ...)
}

#' @export
topojson_write.SpatialPixels <- function(input, lat = NULL, lon = NULL, geometry = "point",
                                        group = NULL, file = "myfile.topojson",
                                        overwrite = TRUE, precision = NULL,
                                        convert_wgs84 = FALSE, crs = NULL, 
                                        object_name = "foo", ...) {

  sp_helper(input, file = file, precision = precision,
            convert_wgs84 = convert_wgs84, crs = crs,
            class = "SpatialPixelsDataFrame", object_name = object_name, ...)
}

#' @export
topojson_write.SpatialPixelsDataFrame <- function(input, lat = NULL, lon = NULL, geometry = "point",
                                                 group = NULL, file = "myfile.topojson",
                                                 overwrite = TRUE, precision = NULL,
                                                 convert_wgs84 = FALSE, crs = NULL, 
                                                 object_name = "foo", ...) {

  sp_helper(input, file = file, precision = precision,
            convert_wgs84 = convert_wgs84, crs = crs,
            class = "SpatialPixelsDataFrame", object_name = object_name, ...)
}

## spatial classes from rgeos -----------------
#' @export
topojson_write.SpatialRings <- function(input, lat = NULL, lon = NULL, geometry = "point",
                                       group = NULL, file = "myfile.topojson",
                                       overwrite = TRUE, precision = NULL,
                                       convert_wgs84 = FALSE, crs = NULL, 
                                       object_name = "foo", ...) {

  sp_helper(input, file = file, precision = precision,
            convert_wgs84 = convert_wgs84, crs = crs,
            class = "SpatialRings", object_name = object_name, ...)
}

#' @export
topojson_write.SpatialRingsDataFrame <- function(input, lat = NULL, lon = NULL,
  geometry = "point", group = NULL, file = "myfile.topojson", overwrite = TRUE,
  precision = NULL, convert_wgs84 = FALSE, crs = NULL, object_name = "foo", ...) {

  sp_helper(input, file = file, precision = precision,
            convert_wgs84 = convert_wgs84, crs = crs,
            class = "SpatialRingsDataFrame", object_name = object_name, ...)
}

#' @export
topojson_write.SpatialCollections <- function(input, lat = NULL, lon = NULL,
  geometry = "point", group = NULL, file = "myfile.topojson", overwrite = TRUE,
  precision = NULL, convert_wgs84 = FALSE, crs = NULL, object_name = "foo", ...) {

  tmp <- suppressMessages(
    geojson_write(input, lat, lon, geometry, group,
                  sub("\\.topojson|\\.json", "\\.geojson", file),
                  overwrite, precision, convert_wgs84, crs, ...))
  structure(lapply(tmp, function(z) {
    on.exit(unlink(z$path), add = TRUE)
    if (!is.null(z)) {
      topo_file(
        write_topojson(
          geo2topo(paste0(readLines(z$path), collapse = ""), object_name),
          sub("\\.geojson|\\.json", "\\.topojson", z$path)
        ),
        z$type
      )
    }
  }), class = "spatialcoll")
}

## normal R classes -----------------
#' @export
topojson_write.numeric <- function(input, lat = NULL, lon = NULL, geometry = "point",
                                  group = NULL, file = "myfile.topojson",
                                  overwrite = TRUE, precision = NULL, 
                                  object_name = "foo", ...) {

  sp_helper(input, lat = lat, lon = lon, geometry = geometry,
            file = file, precision = precision, overwrite = overwrite,
            class = "numeric", object_name = object_name, ...)
}

#' @export
topojson_write.data.frame <- function(input, lat = NULL, lon = NULL, geometry = "point",
                                     group = NULL, file = "myfile.topojson", overwrite = TRUE,
                                     precision = NULL, object_name = "foo", ...) {

  sp_helper(input, lat = lat, lon = lon, geometry = geometry, group = group,
            file = file, precision = precision, overwrite = overwrite,
            class = "data.frame", object_name = object_name, ...)
}

#' @export
topojson_write.list <- function(input, lat = NULL, lon = NULL, geometry="point",
                               group = NULL, file = "myfile.topojson",
                               overwrite = TRUE, precision = NULL, 
                               object_name = "foo", ...) {

  sp_helper(input, lat = lat, lon = lon, geometry = geometry, group = group,
            file = file, precision = precision, overwrite = overwrite,
            class = "list", object_name = object_name, ...)
}

#' @export
topojson_write.geo_list <- function(input, lat = NULL, lon = NULL, geometry = "point",
                                   group = NULL, file = "myfile.topojson",
                                   overwrite = TRUE, object_name = "foo", ...) {

  sp_helper(input, file = file, overwrite = overwrite, class = "geo_list", 
    object_name = object_name, ...)
}

# JSON -----------------
#' @export
topojson_write.json <- function(input, lat = NULL, lon = NULL, geometry = "point",
                                group = NULL, file = "myfile.topojson",
                                overwrite = TRUE, object_name = "foo", ...) {

  topo_file(write_topojson(unclass(input), file, ...), "json")
}

## sf classes --------------
#' @export
topojson_write.sf <- function(input, lat = NULL, lon = NULL, geometry = "point",
                             group = NULL, file = "myfile.topojson",
                             overwrite = TRUE, precision = NULL,
                             convert_wgs84 = FALSE, crs = NULL, 
                             object_name = "foo", ...) {

  topo_write_sf(input, convert_wgs84, crs, file, overwrite, "sf", 
    object_name, ...)
}

#' @export
topojson_write.sfc <- function(input, lat = NULL, lon = NULL, geometry = "point",
                              group = NULL, file = "myfile.topojson",
                              overwrite = TRUE, precision = NULL,
                              convert_wgs84 = FALSE, crs = NULL,
                              object_name = "foo", ...) {

  topo_write_sf(input, convert_wgs84, crs, file, overwrite, "sfc", 
    object_name, ...)
}

#' @export
topojson_write.sfg <- function(input, lat = NULL, lon = NULL, geometry = "point",
                              group = NULL, file = "myfile.topojson",
                              overwrite = TRUE, precision = NULL,
                              convert_wgs84 = FALSE, crs = NULL,
                              object_name = "foo", ...) {

  topo_write_sf(input, convert_wgs84, crs, file, overwrite, "sfg", 
    object_name, ...)
}

topo_write_sf <- function(input, convert_wgs84, crs, file, overwrite, 
  class, object_name, ...) {

  tmp <- suppressMessages(
    geojson_write(input, convert_wgs84 = convert_wgs84,
                  crs = crs, file = tempfile(fileext=".geojson"),
                  overwrite = overwrite, ...))
  on.exit(unlink(tmp$path))
  topo_file(
    write_topojson(
      geo2topo(paste0(readLines(tmp$path, warn = FALSE), collapse = ""), 
        object_name), file),
    "sfc"
  )
}


# helpers ------------------
write_topojson <- function(x, file, ...) {
  if (is.null(file)) stop("'file' required with character string as input",
                          call. = FALSE)
  file <- path.expand(file)
  fcon <- file(file)
  on.exit(close(fcon))
  writeLines(x, con = fcon)
  message("Success! File at ", file)
  return(file)
}

sp_helper <- function(input, lat = NULL, lon = NULL, geometry = "point",
                      group = NULL, file = "myfile.topojson",
                      overwrite = TRUE, precision = NULL,
                      convert_wgs84 = FALSE, crs = NULL, 
                      class, object_name, ...) {

  res <- suppressMessages(
    geojson_write(
      input, lat = lat, lon = lon, geometry = geometry, group = group,
      file = sub("\\.topojson|\\.json", "\\.geojson", file),
      overwrite = overwrite, precision = precision,
      convert_wgs84 = convert_wgs84, crs = crs, ...))
  on.exit(unlink(res$path))
  topo_file(
    write_topojson(
      geo2topo(
        paste0(readLines(res$path, warn = FALSE), collapse = ""), 
        object_name
      ), 
      file
    ),
    class
  )
}

topo_file <- function(path, type) {
  structure(list(path = path, type = type), class = "topojson_file")
}

#' @export
print.topojson_file <- function(x, ...) {
  cat("<topojson-file>", "\n", sep = "")
  cat("  Path:       ", x$path, "\n", sep = "")
  cat("  From class: ", x$type, "\n", sep = "")
}
