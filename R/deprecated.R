#' Deprecated functions from geojsonio
#' 
#' `r lifecycle::badge("defunct")`
#' 
#' Due to the retirement of rgeos and maptools in 2023, the following functions
#' are now defunct. They will be removed entirely in the future.
#' 
#' At the moment, there is no replacement for these functions that uses the 
#' newer geos package (or any alternative for maptools). If you'd be interested
#' in contributing replacements, please feel free to contribute a pull request!
#' 
#' @inheritParams geojson_write
#' 
#' @rdname defunct
#' @examples \dontrun{
#' # From SpatialRings
#' library(rgeos)
#' r1 <- Ring(cbind(x = c(1, 1, 2, 2, 1), y = c(1, 2, 2, 1, 1)), ID = "1")
#' r2 <- Ring(cbind(x = c(1, 1, 2, 2, 1), y = c(1, 2, 2, 1, 1)), ID = "2")
#' r1r2 <- SpatialRings(list(r1, r2))
#' geojson_write(r1r2)
#'
#' # From SpatialRingsDataFrame
#' dat <- data.frame(id = c(1, 2), value = 3:4)
#' r1r2df <- SpatialRingsDataFrame(r1r2, data = dat)
#' geojson_write(r1r2df)
#' 
#' # From SpatialCollections
#' library("sp")
#' poly1 <- Polygons(list(Polygon(cbind(c(-100, -90, -85, -100), c(40, 50, 45, 40)))), "1")
#' poly2 <- Polygons(list(Polygon(cbind(c(-90, -80, -75, -90), c(30, 40, 35, 30)))), "2")
#' poly <- SpatialPolygons(list(poly1, poly2), 1:2)
#' coordinates(us_cities) <- ~ long + lat
#' dat <- SpatialCollections(points = us_cities, polygons = poly)
#' geojson_write(dat)
#' }
#' 
#' @export
geojson_write.SpatialRings <- function(input, lat = NULL, lon = NULL, geometry = "point",
                                       group = NULL, file = "myfile.geojson",
                                       overwrite = TRUE, precision = NULL,
                                       convert_wgs84 = FALSE, crs = NULL, ...) {
  lifecycle::deprecate_stop(
    "0.10.0",
    "geojson_write.SpatialRings()",
    details = "Due to the pending retirement of rgeos in 2023, please migrate any existing code away from using rgeos."
  )
}

#' @rdname defunct
#' @export
geojson_write.SpatialRingsDataFrame <- function(input, lat = NULL, lon = NULL, geometry = "point",
                                                group = NULL, file = "myfile.geojson",
                                                overwrite = TRUE, precision = NULL,
                                                convert_wgs84 = FALSE, crs = NULL, ...) {
  lifecycle::deprecate_stop(
    "0.10.0",
    "geojson_write.SpatialRingsDataFrame()",
    details = "Due to the pending retirement of rgeos in 2023, please migrate any existing code away from using rgeos."
  )
}

#' @rdname defunct
#' @export
geojson_write.SpatialCollections <- function(input, lat = NULL, lon = NULL,
                                             geometry = "point",
                                             group = NULL, file = "myfile.geojson",
                                             overwrite = TRUE, precision = NULL,
                                             convert_wgs84 = FALSE, crs = NULL, ...) {
  lifecycle::deprecate_stop(
    "0.10.0",
    "geojson_write.SpatialCollections()",
    details = "Due to the pending retirement of rgeos in 2023, please migrate any existing code away from using rgeos."
  )
}

## SpatialRings to SpatialPolygonsDataFrame
as.SpatialPolygonsDataFrame.SpatialRings <- function(from) {
  
  lifecycle::deprecate_stop(
    "0.10.0",
    "as.SpatialPolygonsDataFrame.SpatialRings()",
    details = "Due to the pending retirement of rgeos in 2023, please migrate any existing code away from using rgeos."
  )
}

setAs(
  "SpatialRings", "SpatialPolygonsDataFrame",
  as.SpatialPolygonsDataFrame.SpatialRings
)


## SpatialRingsDataFrame to SpatialPolygonsDataFrame
as.SpatialPolygonsDataFrame.SpatialRingsDataFrame <- function(from) {
  
  lifecycle::deprecate_stop(
    "0.10.0",
    "as.SpatialPolygonsDataFrame.SpatialRingsDataFrame()",
    details = "Due to the pending retirement of rgeos in 2023, please migrate any existing code away from using rgeos."
  )
}

setAs(
  "SpatialRingsDataFrame", "SpatialPolygonsDataFrame",
  as.SpatialPolygonsDataFrame.SpatialRingsDataFrame
)
