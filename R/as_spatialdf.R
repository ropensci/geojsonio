as.SpatialPointsDataFrame.SpatialPoints <- function (from) {
  IDs <-rownames(slot(from, "coords"))
  df <- data.frame(dummy = rep(0, length(IDs)), row.names = IDs)
  SpatialPointsDataFrame(from, df)
}

setAs("SpatialPoints", "SpatialPointsDataFrame",
      as.SpatialPointsDataFrame.SpatialPoints)

as.SpatialLinesDataFrame.SpatialLines <- function (from) {
  IDs <- sapply(slot(from, "lines"), function(x) slot(x, "ID"))
  df <- data.frame(dummy = rep(0, length(IDs)), row.names = IDs)
  SpatialLinesDataFrame(from, df)
}

setAs("SpatialLines", "SpatialLinesDataFrame",
      as.SpatialLinesDataFrame.SpatialLines)
