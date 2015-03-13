## SpatialPoints to SpatialPointsDataFrame
as.SpatialPointsDataFrame.SpatialPoints <- function (from) {
  IDs <-rownames(slot(from, "coords"))
  df <- data.frame(dummy = rep(0, length(IDs)), row.names = IDs)
  SpatialPointsDataFrame(from, df)
}

setAs("SpatialPoints", "SpatialPointsDataFrame",
      as.SpatialPointsDataFrame.SpatialPoints)


## SpatialLines to SpatialLinesDataFrame
as.SpatialLinesDataFrame.SpatialLines <- function (from) {
  IDs <- sapply(slot(from, "lines"), function(x) slot(x, "ID"))
  df <- data.frame(dummy = rep(0, length(IDs)), row.names = IDs)
  SpatialLinesDataFrame(from, df)
}

setAs("SpatialLines", "SpatialLinesDataFrame",
      as.SpatialLinesDataFrame.SpatialLines)


## SpatialRings to SpatialPolygonsDataFrame
as.SpatialPolygonsDataFrame.SpatialRings <- function (from) {
  rings <- slot(from, "rings")
  IDs <- sapply(rings, function(x) slot(x, "ID"))
  res <- lapply(rings, function(x) {
    Polygons(list(Polygon(x@coords)), ID = x@ID)
  })
  df <- data.frame(dummy = rep(0, length(IDs)), row.names = IDs)
  SpatialPolygonsDataFrame(SpatialPolygons(res), df)
}

setAs("SpatialRings", "SpatialPolygonsDataFrame",
      as.SpatialPolygonsDataFrame.SpatialRings)


## SpatialRingsDataFrame to SpatialPolygonsDataFrame
as.SpatialPolygonsDataFrame.SpatialRingsDataFrame <- function (from) {
  rings <- slot(from, "rings")
  IDs <- sapply(rings, function(x) slot(x, "ID"))
  res <- lapply(rings, function(x) {
    Polygons(list(Polygon(x@coords)), ID = x@ID)
  })
  SpatialPolygonsDataFrame(SpatialPolygons(res), from@data)
}

setAs("SpatialRingsDataFrame", "SpatialPolygonsDataFrame",
      as.SpatialPolygonsDataFrame.SpatialRingsDataFrame)
