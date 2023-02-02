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
