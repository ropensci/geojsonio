# get GDAL version for later use
geojsonio_env <- new.env()

gdal_version <- function() {
  if (length(ls(envir = geojsonio_env)) == 0) {
    tmp <- rgdal::getGDALVersionInfo(str = "--version") 
    val <- as.numeric(
      gsub("\\.", "", regmatches(tmp, regexpr("[0-9]+\\.[0-9]+\\.[0-9]+", tmp)))
    )
    assign("gdal_ver", val, envir = geojsonio_env)    
  }
  return(get("gdal_ver", envir = geojsonio_env))
}

## SpatialPoints to SpatialPointsDataFrame
as.SpatialPointsDataFrame.SpatialPoints <- function(from) {
  ids <- rownames(slot(from, "coords"))
  if (is.null(ids)) {
    ids <- 1:NROW(slot(from, "coords"))
  }
  df <- data.frame(dummy = rep(0, length(ids)), row.names = ids)
  SpatialPointsDataFrame(from, df)
}

setAs("SpatialPoints", "SpatialPointsDataFrame",
      as.SpatialPointsDataFrame.SpatialPoints)


## SpatialLines to SpatialLinesDataFrame
as.SpatialLinesDataFrame.SpatialLines <- function(from) {
  IDs <- sapply(slot(from, "lines"), function(x) slot(x, "ID"))
  df <- data.frame(dummy = rep(0, length(IDs)), row.names = IDs)
  SpatialLinesDataFrame(from, df)
}

setAs("SpatialLines", "SpatialLinesDataFrame",
      as.SpatialLinesDataFrame.SpatialLines)


## SpatialRings to SpatialPolygonsDataFrame
as.SpatialPolygonsDataFrame.SpatialRings <- function(from) {
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
as.SpatialPolygonsDataFrame.SpatialRingsDataFrame <- function(from) {
  rings <- slot(from, "rings")
  IDs <- sapply(rings, function(x) slot(x, "ID"))
  res <- lapply(rings, function(x) {
    Polygons(list(Polygon(x@coords)), ID = x@ID)
  })
  SpatialPolygonsDataFrame(SpatialPolygons(res), from@data)
}

setAs("SpatialRingsDataFrame", "SpatialPolygonsDataFrame",
      as.SpatialPolygonsDataFrame.SpatialRingsDataFrame)


## SpatialPixels to SpatialPointsDataFrame
as.SpatialPointsDataFrame.SpatialPixels <- function(from) {
  df <- data.frame(id = 1:NROW(from@coords), stringsAsFactors = FALSE)
  SpatialPointsDataFrame(from, data = df)
}

setAs("SpatialPixels", "SpatialPointsDataFrame",
      as.SpatialPointsDataFrame.SpatialPixels)

# Convert to various sp classes from geojson files
as.SpatialPolygonsDataFrame <- function(x, ...) {
  UseMethod("as.SpatialPolygonsDataFrame")
}

as.SpatialPolygonsDataFrame.geojson <- function(x, ...) {
  if (gdal_version() < 220) {
    # if gdal <= 2.2
    readOGR(x$path, "OGRGeoJSON", ...)
  } else {
    # if gdal >= 2.2
    readOGR(x$path, sub("\\..+", "", basename(x$path)), ...)
  }
}

as.SpatialPolygonsDataFrame.character <- function(x, ...) {
  if (gdal_version() < 220) {
    # if gdal <= 2.2
    readOGR(x, "OGRGeoJSON", ...)
  } else {
    # if gdal >= 2.2
    readOGR(x, sub("\\..+", "", basename(x)), ...)
  }
}



## SpatialRings to SpatialPoints
# as.SpatialPoints.SpatialRings <- function(from) {
#   rings <- slot(from, "rings")
#   IDs <- sapply(rings, function(x) slot(x, "ID"))
#   res <- lapply(rings, function(x) {
#     Polygons(list(Polygon(x@coords)), ID = x@ID)
#   })
#   SpatialPolygonsDataFrame(SpatialPolygons(res), from@data)
# }
# 
# setAs("SpatialRings", "SpatialPoints",
#       as.SpatialPoints.SpatialRings)
