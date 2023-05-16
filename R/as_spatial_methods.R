## SpatialPoints to SpatialPointsDataFrame
as.SpatialPointsDataFrame.SpatialPoints <- function(from) {
  ids <- rownames(slot(from, "coords"))
  if (is.null(ids)) {
    ids <- 1:NROW(slot(from, "coords"))
  }
  df <- data.frame(dummy = rep(0, length(ids)), row.names = ids)
  SpatialPointsDataFrame(from, df)
}

setAs(
  "SpatialPoints", "SpatialPointsDataFrame",
  as.SpatialPointsDataFrame.SpatialPoints
)

## SpatialLines to SpatialLinesDataFrame
as.SpatialLinesDataFrame.SpatialLines <- function(from) {
  IDs <- sapply(slot(from, "lines"), function(x) slot(x, "ID"))
  df <- data.frame(dummy = rep(0, length(IDs)), row.names = IDs)
  SpatialLinesDataFrame(from, df)
}

setAs(
  "SpatialLines", "SpatialLinesDataFrame",
  as.SpatialLinesDataFrame.SpatialLines
)

## SpatialPixels to SpatialPointsDataFrame
as.SpatialPointsDataFrame.SpatialPixels <- function(from) {
  df <- data.frame(id = 1:NROW(from@coords), stringsAsFactors = FALSE)
  SpatialPointsDataFrame(from, data = df)
}

setAs(
  "SpatialPixels", "SpatialPointsDataFrame",
  as.SpatialPointsDataFrame.SpatialPixels
)

# Convert to various sp classes from geojson files
as.SpatialPolygonsDataFrame <- function(x, ...) {
  UseMethod("as.SpatialPolygonsDataFrame")
}

as.SpatialPolygonsDataFrame.geojson_file <- function(x, ...) {
  sf::st_read(x$path, quiet = TRUE, ...)
}

as.SpatialPolygonsDataFrame.character <- function(x, ...) {
  sf::st_read(x, quiet = TRUE, ...)
}
