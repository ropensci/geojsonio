#' Convert many input types with spatial data to a geojson file
#'
#' @import sp rgdal methods
#' @importFrom dplyr rbind_all
#' @importFrom jsonlite toJSON fromJSON unbox
#' @export
#'
#' @param input Input list, data.frame, or spatial class. Inputs can also be dplyr \code{tbl_df}
#' class since it inherits from \code{data.frame}.
#' @param lat Latitude name. Default: latitude
#' @param lon Longitude name. Default: longitude
#' @param polygon If a polygon is defined in a data.frame, this is the column that defines the
#' grouping of the polygons in the \code{data.frame}
#' @param file A path and file name (e.g., myfile), with the .geojson on the end.
#' @param ... Further args passed on to \code{\link[rgdal]{writeOGR}}
#' @param path Path to file
#' @param type Type of file
#'
#' @seealso \code{\link{geojson_list}}, \code{\link{geojson_json}}
#'
#' @examples \dontrun{
#' # From a data.frame
#' library('maps')
#' data(us.cities)
#' geojson_write(us.cities[1:2,], lat='lat', lon='long')
#'
#' # From polygons in R
#' library('ggplot2')
#' states <- map_data("state")
#' head(states)
#' geojson_write(input=states, lat='lat', lon='long', polygon='group')
#'
#' ## From a list
#' mylist <- list(list(latitude=30, longitude=120, marker="red"),
#'                list(latitude=30, longitude=130, marker="blue"))
#' geojson_write(mylist)
#'
#' # From a numeric vector of length 2
#' vec <- c(32.45,-99.74)
#' geojson_write(vec)
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
#' # Write output of geojson_list to file
#' library("maps")
#' data(us.cities)
#' res <- geojson_list(us.cities[1:2,], lat='lat', lon='long')
#' class(res)
#' geojson_write(res)
#' 
#' # Write output of geojson_json to file
#' library("maps")
#' data(us.cities)
#' res <- geojson_json(us.cities[1:2,], lat='lat', lon='long')
#' class(res)
#' geojson_write(res)
#' }

geojson_write <- function(...) UseMethod("geojson_write")

#' @export
#' @rdname geojson_write
geojson_write.geo_list <- function(input, file = "myfile.geojson", ...){
  cat(as.json(input, pretty=TRUE), file=file)
  message("Success! File is at ", file)
}

#' @export
#' @rdname geojson_write
geojson_write.json <- function(input, file = "myfile.geojson", ...){
  cat(toJSON(jsonlite::fromJSON(input), pretty=TRUE, auto_unbox = TRUE), file=file)
  message("Success! File is at ", file)
}

#' @export
#' @rdname geojson_write
geojson_write.SpatialPolygons <- function(input, file = "myfile.geojson", ...){
  write_geojson(as(input, "SpatialPolygonsDataFrame"), file, ...)
}

#' @export
#' @rdname geojson_write
geojson_write.SpatialPolygonsDataFrame <- function(input, file = "myfile.geojson", ...){
  write_geojson(input, file, ...)
}

#' @export
#' @rdname geojson_write
geojson_write.SpatialPoints <- function(input, file = "myfile.geojson", ...){
  write_geojson(as(input, "SpatialPointsDataFrame"), file, ...)
}

#' @export
#' @rdname geojson_write
geojson_write.SpatialPointsDataFrame <- function(input, file = "myfile.geojson", ...){
  write_geojson(input, file, ...)
}

#' @export
#' @rdname geojson_write
geojson_write.SpatialLines <- function(input, file = "myfile.geojson", ...){
  write_geojson(as(input, "SpatialLinesDataFrame"), file, ...)
}

#' @export
#' @rdname geojson_write
geojson_write.SpatialLinesDataFrame <- function(input, file = "myfile.geojson", ...){
  write_geojson(input, file, ...)
}

#' @export
#' @rdname geojson_write
geojson_write.SpatialGrid <- function(input, file = "myfile.geojson", ...){
  size <- prod(input@grid@cells.dim)
  input <- SpatialGridDataFrame(input, data.frame(val=rep(1, size)))
  write_geojson(input, file, ...)
}

#' @export
#' @rdname geojson_write
geojson_write.SpatialGridDataFrame <- function(input, file = "myfile.geojson", ...){
  write_geojson(as(input, "SpatialPointsDataFrame"), file, ...)
}

#' @export
#' @rdname geojson_write
geojson_write.numeric <- function(input, lat = "latitude", lon = "longitude", polygon=NULL,
                               file = "myfile.geojson", ...){
  if(is.null(polygon)){
    res <- df_to_SpatialPointsDataFrame(input, lon = lon, lat = lat)
  } else {
    res <- df_to_SpatialPolygonsDataFrame(input)
  }
  write_geojson(res, file, ...)
}

#' @export
#' @rdname geojson_write
geojson_write.data.frame <- function(input, lat = "latitude", lon = "longitude", polygon=NULL,
                                  file = "myfile.geojson", ...){
  if(is.null(polygon)){
    res <- df_to_SpatialPointsDataFrame(input, lon = lon, lat = lat)
  } else {
    res <- df_to_SpatialPolygonsDataFrame(input)
  }
  write_geojson(res, file, ...)
  as.geojson(file, "data.frame")
}

#' @export
#' @rdname geojson_write
geojson_write.list <- function(input, lat = "latitude", lon = "longitude", polygon=NULL,
                            file = "myfile.geojson", ...){
  res <- list_to_geo_list(input, lat, lon, polygon)
  list_to_geojson(res, lat=lat, lon=lon, polygon=polygon, ...)
}

#' @export
#' @rdname geojson_write
as.geojson <- function(path, type) structure(list(path=path, type=type), class="geojson")

#' @export
print.geojson <- function(x, ...) {
  cat("<geojson>", "\n", sep = "")
  cat("  Path:       ", x$path, "\n", sep = "")
  cat("  From class: ", x$type, "\n", sep = "")
}

# list_to_geojson <- function(input, file = "myfile.geojson", polygon=NULL, lon, lat, ...){
#   input <- data.frame(rbind_all(lapply(input, function(x){
#     tmp <- data.frame(type=x$type,
#                       geometry_type=x$geometry$type,
#                       longitude=x$geometry$coordinates[1],
#                       latitude=x$geometry$coordinates[2],
#                       x$properties,
#                       stringsAsFactors = FALSE)
#     #     names(tmp)[5:8] <- paste('properties_', names(tmp)[5:8], sep = "")
#     tmp
#   })))
#   if(is.null(polygon)){
#     out <- df_to_SpatialPointsDataFrame(input, lon=lon, lat=lat)
#   } else {
#     out <- df_to_SpatialPolygonsDataFrame(input)
#   }
#   as.geojson(out, file, ...)
# }
#
# df_to_SpatialPolygonsDataFrame <- function(x){
#   x_split <- split(x, f = x$group)
#   res <- lapply(x_split, function(y){
#     coordinates(y) <- c("long","lat")
#     Polygon(y)
#   })
#   res <- Polygons(res, "polygons")
#   hh <- SpatialPolygons(list(res))
#   as(hh, "SpatialPolygonsDataFrame")
# }
#
# df_to_SpatialPointsDataFrame <- function(x, lon, lat) { coordinates(x) <- c(lon,lat); x }
#
# bbox2df <- function(x) c(x[1,1], x[1,2], x[2,1], x[2,2])
#
# sppolytogeolist <- function(x){
#   list(type = "Polygon",
#        bbox = bbox2df(x@bbox),
#        coordinates =
#          lapply(x@polygons, function(l) {
#            apply(l@Polygons[[1]]@coords, 1, as.list)
#          }),
#        properties = NULL
#   )
#   # setNames(Filter(function(x) !is.null(x), x), NULL)
# }
#
# as.geojson <- function(input, file = "myfile.geojson", ...){
#   if (!grepl("\\.geojson$", file)) {
#     file <- paste0(file, ".geojson")
#   }
#   file <- path.expand(file)
#   unlink(file)
#   destpath <- dirname(file)
#   if (!file.exists(destpath)) dir.create(destpath)
#   write_ogr(input, tempfile(), file, ...)
# }
#
# write_ogr <- function(input, dir, file, ...){
#   input@data <- convert_ordered(input@data)
#   writeOGR(input, dir, "", "GeoJSON", ...)
#   file.rename(dir, file)
#   message("Success! File is at ", file)
# }
#
# convert_ordered <- function(df) {
#   data.frame(lapply(df, function(x) {
#     if ("ordered" %in% class(x)) x <- as.character(x)
#     x
#   }),
#   stringsAsFactors = FALSE)
# }
