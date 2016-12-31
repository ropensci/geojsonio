#' Write topojson from various inputs
#'
#' @export
#'
#' @param x topojson as character string, or form a file, or url
#' @param file (character) if \code{NULL} write to stdout
#' @param ... Further args passed on to xxxx
#' 
#' @return A path (character)
#' @details xxx
#'
#' @examples
#' # from character string of TopoJSON
#' x <- system.file("examples/point.json", package = "geojsonio")
#' tj <- paste0(readLines(x), collapse = "")
#' (z <- topojson_write(tj, file = "my.topojson"))
#' topojson_read(z)
#' 
#' # convert GeoJSON to TopoJSON, then write
#' x <- '{"type": "LineString", "coordinates": [ [100.0, 0.0], [101.0, 1.0] ]}'
#' topojson_write(geojson2topojson(x))
#' topojson_write(geojson2topojson(x), "out.topojson")
#' 
#' # SpatialPoints class
#' x <- c(1,2,3,4,5)
#' y <- c(3,2,5,1,4)
#' s <- SpatialPoints(cbind(x,y))
#' topojson_write(s, "out.topojson")
#' readLines("out.topojson")
#'
#' # SpatialPointsDataFrame class
#' s <- SpatialPointsDataFrame(cbind(x,y), mtcars[1:5,])
#' topojson_write(s, "out.topojson")
#' readLines("out.topojson")
#' 
#' # SpatialLines class
#' library(sp)
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
#' topojson_write(sl1, "out.topojson")
#' readLines("out.topojson")
#'
#' # SpatialLinesDataFrame class
#' dat <- data.frame(X = c("Blue", "Green"),
#'                  Y = c("Train", "Plane"),
#'                  Z = c("Road", "River"), row.names = c("a", "b"))
#' sldf <- SpatialLinesDataFrame(sl12, dat)
#' topojson_write(sldf, "out.topojson")
#' readLines("out.topojson")
#' 
#' # SpatialPolygons class
#' library('sp')
#' poly1 <- Polygons(list(Polygon(cbind(c(-100,-90,-85,-100),
#'    c(40,50,45,40)))), "1")
#' poly2 <- Polygons(list(Polygon(cbind(c(-90,-80,-75,-90),
#'    c(30,40,35,30)))), "2")
#' sp_poly <- SpatialPolygons(list(poly1, poly2), 1:2)
#' topojson_write(sp_poly, file = "out.topojson")
#' readLines(res)
#' 
#' # From SpatialPolygonsDataFrame class
#' sp_polydf <- as(sp_poly, "SpatialPolygonsDataFrame")
#' res <- topojson_write(sp_polydf, file = "out.topojson")
#' readLines(res)
#' 
#' # from file
#' ff <- system.file("examples/california.geojson", package = "geojsonio")
#' ffgeo <- paste0(readLines(ff), collapse = " ")
#' topojson_write(x = ffgeo, file = "stuff.topojson")
topojson_write <- function(x, file = NULL, ...) {
  UseMethod("topojson_write")
}

#' @export
topojson_write.character <- function(x, file = NULL, ...) {
  write_topojson(x, file, ...)
}

#' @export
topojson_write.SpatialPoints <- function(x, file = NULL, ...) sp_helper(x, file)

#' @export
topojson_write.SpatialPointsDataFrame <- function(x, file = NULL, ...) {
  sp_helper(x, file)
}

#' @export
topojson_write.SpatialLines <- function(x, file = NULL, ...) sp_helper(x, file)

#' @export
topojson_write.SpatialLinesDataFrame <- function(x, file = NULL, ...) {
  sp_helper(x, file)
}

#' @export
topojson_write.SpatialPolygons <- function(x, file = NULL, ...) sp_helper(x, file)

#' @export
topojson_write.SpatialPolygonsDataFrame <- function(x, file = NULL, ...) {
  sp_helper(x, file)
}

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

sp_helper <- function(x, file) {
  write_topojson(
    geo2topo(unclass(geojson::as.geojson(x))),
    file = file
  )
}
