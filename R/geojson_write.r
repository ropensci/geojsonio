#' Convert many input types with spatial data to a geojson file
#' 
#' @import methods sp rgeos
#' @importFrom jsonlite toJSON fromJSON unbox
#' @export
#' 
#' @param input Input list, data.frame, or spatial class. Inputs can also be
#'   dplyr \code{tbl_df} class since it inherits from \code{data.frame}.
#' @param lat (character) Latitude name. The default is \code{NULL}, and we
#'   attempt to guess.
#' @param lon (character) Longitude name. The default is \code{NULL}, and we
#'   attempt to guess.
#' @param geometry (character) One of point (Default) or polygon.
#' @param group (character) A grouping variable to perform grouping for polygons
#'   - doesn't apply for points
#' @param file (character) A path and file name (e.g., myfile), with the 
#'   \code{.geojson} file extension. Default writes to current working
#'   directory.
#' @param overwrite (logical) Overwrite the file given in \code{file} with
#'   \code{input}. Default: \code{TRUE}. If this param is \code{FALSE} and 
#'   the file already exists, we stop with error message.
#' @param precision desired number of decimal places for the coordinates in the
#'   geojson file. Using fewer decimal places can decrease file sizes (at the
#'   cost of precision).
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
#' ## Expected order is lon, lat
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
                          group = NULL, file = "myfile.geojson", 
                          overwrite = TRUE, precision = NULL, ...) {
  UseMethod("geojson_write")
}

## spatial classes from sp -----------------
#' @export
geojson_write.SpatialPolygons <- function(input, lat = NULL, lon = NULL, geometry = "point",
                                          group = NULL, file = "myfile.geojson", 
                                          overwrite = TRUE, precision = NULL, ...) {
  write_geojson(as(input, "SpatialPolygonsDataFrame"), file, precision = precision, ...)
  return(as.geojson(file, "SpatialPolygons"))
}

#' @export
geojson_write.SpatialPolygonsDataFrame <- function(input, lat = NULL, lon = NULL, geometry = "point",
                                                   group = NULL, file = "myfile.geojson", 
                                                   overwrite = TRUE, precision = NULL, ...) {
  write_geojson(input, file, precision = precision, ...)
  return(as.geojson(file, "SpatialPolygonsDataFrame"))
}

#' @export
geojson_write.SpatialPoints <- function(input, lat = NULL, lon = NULL, geometry = "point",
                                        group = NULL, file = "myfile.geojson", 
                                        overwrite = TRUE, precision = NULL, ...) {
  write_geojson(as(input, "SpatialPointsDataFrame"), file, precision = precision, ...)
  return(as.geojson(file, "SpatialPoints"))
}

#' @export
geojson_write.SpatialPointsDataFrame <- function(input, lat = NULL, lon = NULL, geometry = "point",
                                                 group = NULL, file = "myfile.geojson", 
                                                 overwrite = TRUE, precision = NULL, ...) {
  write_geojson(input, file, precision = precision, ...)
  return(as.geojson(file, "SpatialPointsDataFrame"))
}

#' @export
geojson_write.SpatialLines <- function(input, lat = NULL, lon = NULL, geometry = "point",
                                       group = NULL, file = "myfile.geojson", 
                                       overwrite = TRUE, precision = NULL, ...) {
  write_geojson(as(input, "SpatialLinesDataFrame"), file, precision = precision, ...)
  return(as.geojson(file, "SpatialLines"))
}

#' @export
geojson_write.SpatialLinesDataFrame <- function(input, lat = NULL, lon = NULL, geometry = "point",
                                                group = NULL, file = "myfile.geojson", 
                                                overwrite = TRUE, precision = NULL, ...) {
  write_geojson(input, file, precision = precision, ...)
  return(as.geojson(file, "SpatialLinesDataFrame"))
}

#' @export
geojson_write.SpatialGrid <- function(input, lat = NULL, lon = NULL, geometry = "point",
                                      group = NULL, file = "myfile.geojson", 
                                      overwrite = TRUE, precision = NULL, ...) {
  size <- prod(input@grid@cells.dim)
  input <- SpatialGridDataFrame(input, data.frame(val = rep(1, size)))
  write_geojson(input, file, precision = precision, ...)
  return(as.geojson(file, "SpatialGrid"))
}

#' @export
geojson_write.SpatialGridDataFrame <- function(input, lat = NULL, lon = NULL, geometry = "point",
                                               group = NULL, file = "myfile.geojson", 
                                               overwrite = TRUE, precision = NULL, ...) {
  write_geojson(as(input, "SpatialPointsDataFrame"), file, precision = precision, ...)
  return(as.geojson(file, "SpatialGridDataFrame"))
}

#' @export
geojson_write.SpatialPixels <- function(input, lat = NULL, lon = NULL, geometry = "point",
                                       group = NULL, file = "myfile.geojson", 
                                       overwrite = TRUE, precision = NULL, ...) {
  write_geojson(as(input, "SpatialPointsDataFrame"), file, precision = precision, ...)
  return(as.geojson(file, "SpatialPixels"))
}

#' @export
geojson_write.SpatialPixelsDataFrame <- function(input, lat = NULL, lon = NULL, geometry = "point",
                                                group = NULL, file = "myfile.geojson", 
                                                overwrite = TRUE, precision = NULL, ...) {
  write_geojson(as(input, "SpatialPointsDataFrame"), file, precision = precision, ...)
  return(as.geojson(file, "SpatialPixelsDataFrame"))
}

## spatial classes from rgeos -----------------
#' @export
geojson_write.SpatialRings <- function(input, lat = NULL, lon = NULL, geometry = "point",
                                       group = NULL, file = "myfile.geojson", 
                                       overwrite = TRUE, precision = NULL, ...) {
  write_geojson(as(input, "SpatialPolygonsDataFrame"), file, precision = precision, ...)
  return(as.geojson(file, "SpatialRings"))
}

#' @export
geojson_write.SpatialRingsDataFrame <- function(input, lat = NULL, lon = NULL, geometry = "point",
                                                group = NULL, file = "myfile.geojson", 
                                                overwrite = TRUE, precision = NULL, ...) {
  write_geojson(as(input, "SpatialPolygonsDataFrame"), file, precision = precision, ...)
  return(as.geojson(file, "SpatialRingsDataFrame"))
}

#' @export
geojson_write.SpatialCollections <- function(input, lat = NULL, lon = NULL, geometry = "point",
                                                 group = NULL, file = "myfile.geojson", 
                                             overwrite = TRUE, precision = NULL, ...) {
  ptfile <- iter_spatialcoll(input@pointobj, file, precision = precision, ...)
  lfile <- iter_spatialcoll(input@lineobj, file, precision = precision, ...)
  rfile <- iter_spatialcoll(input@ringobj, file, precision = precision, ...)
  pyfile <- iter_spatialcoll(input@polyobj, file, precision = precision, ...)
  return(structure(list(ptfile, lfile, rfile, pyfile), class = "spatialcoll"))
}

iter_spatialcoll <- function(z, file, precision = NULL, ...) {
  wfile <- sprintf("%s/%s_%s", dirname(file), class(z)[1], basename(file))
  if (!is.null(z)) {
    geojson_write(z, file = wfile, precision = precision, ...)
  }
}

## normal R classes -----------------
#' @export
geojson_write.numeric <- function(input, lat = NULL, lon = NULL, geometry = "point",
                                  group = NULL, file = "myfile.geojson", 
                                  overwrite = TRUE, precision = NULL, ...) {
  if (geometry == "point") {
    res <- df_to_SpatialPointsDataFrame(num2df(input, lat, lon), lon = lon, lat = lat)
  } else {
    res <- df_to_SpatialPolygonsDataFrame(input)
  }
  write_geojson(res, file, precision = precision, ...)
  return(as.geojson(file, "numeric"))
}

num2df <- function(x, lat, lon) {
  if (is.null(lat)) lat <- "lat"
  if (is.null(lon)) lon <- "lon"
  setNames(data.frame(rbind(x), stringsAsFactors = FALSE, row.names = NULL), c(lat, lon))
}

#' @export
geojson_write.data.frame <- function(input, lat = NULL, lon = NULL, geometry = "point",
                                     group = NULL, file = "myfile.geojson", overwrite = TRUE,
                                     precision = NULL, ...) {
  tmp <- guess_latlon(names(input), lat, lon)
  if (geometry == "point") {
    res <- df_to_SpatialPointsDataFrame(input, tmp$lon, tmp$lat)
  } else {
    res <- df_to_SpatialPolygonsDataFrame2(input, tmp$lat, tmp$lon, group)
  }
  write_geojson(res, file, precision = precision, overwrite = overwrite, ...)
  return(as.geojson(file, "data.frame"))
}

#' @export
geojson_write.list <- function(input, lat = NULL, lon = NULL, geometry="point",
                               group = NULL, file = "myfile.geojson", 
                               overwrite = TRUE, precision = NULL, ...) {
  if (geometry == "polygon") lint_polygon_list(input)
  if (is.named(input)) {
    tmp <- guess_latlon(names(input[[1]]), lat, lon)
    res <- list_to_geo_list(input, tmp$lat, tmp$lon, geometry)
    list_to_geojson(res, lat = tmp$lat, lon = tmp$lon, geometry = geometry, ...)
  } else {
    if (geometry == "point") {
      res <- list_to_SpatialPointsDataFrame(input, lon = lon, lat = lat)
    } else {
      res <- list_to_SpatialPolygonsDataFrame(input, lat, lon)
    }
    write_geojson(res, file, precision = precision, ...)
  }
  return(as.geojson(file, "list"))
}

#' @export
geojson_write.geo_list <- function(input, lat = NULL, lon = NULL, geometry = "point",
                                   group = NULL, file = "myfile.geojson", overwrite = TRUE, ...) {
  if (!overwrite && file.exists(file)) {
    stop(file, " already exists and overwrite = FALSE", call. = FALSE)
  }
  cat(as.json(input, pretty = TRUE), file = file)
  message("Success! File is at ", file)
  return(as.geojson(file, "geo_list"))
}

#' @export
geojson_write.json <- function(input, lat = NULL, lon = NULL, geometry = "point",
                               group = NULL, file = "myfile.geojson", overwrite = TRUE, ...) {
  if (!overwrite && file.exists(file)) {
    stop(file, " already exists and overwrite = FALSE", call. = FALSE)
  }
  cat(toJSON(jsonlite::fromJSON(input), pretty = TRUE, auto_unbox = TRUE), file = file)
  message("Success! File is at ", file)
  return(as.geojson(file, "json"))
}

#' @export
print.geojson <- function(x, ...) {
  cat("<geojson>", "\n", sep = "")
  cat("  Path:       ", x$path, "\n", sep = "")
  cat("  From class: ", x$type, "\n", sep = "")
}

#' @export
print.spatialcoll <- function(x, ...) {
  cat("<spatial collection>", "\n", sep = "")
  x <- tg_compact(x)
  for (i in seq_along(x)) {
    cat("  <geojson>", "\n", sep = "")
    cat("    Path:       ", x[[i]]$path, "\n", sep = "")
    cat("    From class: ", x[[i]]$type, "\n", sep = "")
  }
}

as.geojson <- function(path, type) {
  structure(list(path = path, type = type), class = "geojson")
}
