#' Convert many input types with spatial data to geojson.
#'
#' Includes support for lists, data.frame's, and more
#'
#' @import sp rgdal
#' @importFrom dplyr rbind_all
#' @export
#'
#' @param input Input list, data.frame, or spatial class. Inputs can also be dplyr \code{tbl_df}
#' class since it inherits from \code{data.frame}.
#' @param lat Latitude name. Default: latitude
#' @param lon Longitude name. Default: longitude
#' @param polygon If a polygon is defined in a data.frame, this is the column that defines the
#' grouping of the polygons in the \code{data.frame}
#' @param output One of 'list' or 'geojson'. The output from a call to \code{to_geojson()}
#' @param file A path and file name (e.g., myfile), with the .geojson on the end.
#' @param ... Further args passed on to \code{\link[rgdal]{writeOGR}}
#'
#' @details description...
#'
#' @examples \dontrun{
#' library(maps)
#' data(us.cities)
#' head(us.cities)
#' to_geojson(us.cities, lat='lat', lon='long')
#'
#' # polygons
#' library('ggplot2')
#' states <- map_data("state")
#' head(states)
#' ## make list for input to e.g., rMaps
#' res <- to_geojson(input=states, lat='lat', lon='long', group='group')
#'
#' ## From a list
#' mylist <- list(list(latitude=30, longitude=120, marker="red"),
#'                list(latitude=30, longitude=130, marker="blue"))
#' to_geojson(mylist, output = "geojson")
#'
#' # From a numeric vector of length 2
#' vec <- c(32.45,-99.74)
#' to_geojson(vec)
#'
#' # From SpatialPolygons class
#' library('sp')
#' poly1 <- Polygons(list(Polygon(cbind(c(-100,-90,-85,-100),
#'    c(40,50,45,40)))), "1")
#' poly2 <- Polygons(list(Polygon(cbind(c(-90,-80,-75,-90),
#'    c(30,40,35,30)))), "2")
#' sp_poly <- SpatialPolygons(list(poly1, poly2), 1:2)
#' to_geojson(sp_poly)
#' to_geojson(sp_poly, output="geojson")
#'
#' # From SpatialPolygonsDataFrame class
#' sp_polydf <- as(sp_poly, "SpatialPolygonsDataFrame")
#' to_geojson(input = sp_polydf, output = "geojson")
#' to_geojson(input = sp_polydf, output = "geojson", file = "~/stuff")
#' to_geojson(input = sp_polydf, output = "list")
#' }

to_geojson <- function(...) UseMethod("to_geojson")

#' @export
#' @rdname to_geojson
to_geojson.SpatialPolygons <- function(input, output='list', file = "myfile.geojson", ...)
{
  if(output=='list') sptogeolist(input) else as.geojson(as(input, "SpatialPolygonsDataFrame"), file, ...)
}

#' @export
#' @rdname to_geojson
to_geojson.SpatialPolygonsDataFrame <- function(input, output='list', file = "myfile.geojson", ...)
{
  if(output=='list') sptogeolist(input) else as.geojson(input, file, ...)
}

#' @export
#' @rdname to_geojson
to_geojson.SpatialPointsDataFrame <- function(input, output='list', file = "myfile.geojson", ...)
{
  if(output=='list') sptogeolist(input) else as.geojson(input, file, ...)
}

#' @export
#' @rdname to_geojson
to_geojson.numeric <- function(input, lat = "latitude", lon = "longitude", polygon=NULL,
                               output='list', file = "myfile.geojson", ...)
{
  if(output=='list'){
    type <- ifelse(is.null(polygon), "Point", "Polygon")
    res <- tryCatch(as.numeric(input), warning = function(e) e)
    if(is(res, "simpleWarning")) stop("Coordinates are not numeric", call. = FALSE) else {
      list(type = type,
           geometry = list(type = "Point", coordinates = input),
           properties = NULL)
    }
  } else {
    if(is.null(polygon)){
      res <- df_to_SpatialPointsDataFrame(input, lon = lon, lat = lat)
    } else {
      res <- df_to_SpatialPolygonsDataFrame(input)
    }
    as.geojson(res, file, ...)
  }
}

#' @export
#' @rdname to_geojson
to_geojson.data.frame <- function(input, lat = "latitude", lon = "longitude", polygon=NULL, output='list', file = "myfile.geojson", ...){
  if(output=='list'){
    input <- apply(input, 1, as.list)
    x <- lapply(input, function(l) {
      if (is.null(l[[lat]]) || is.null(l[[lon]])) {
        return(NULL)
      }
      type <- ifelse(is.null(polygon), "Point", "Polygon")
      list(type = type,
           geometry = list(type = "Point",
                           coordinates = as.numeric(c(l[[lon]], l[[lat]]))),
           properties = l[!(names(l) %in% c(lat, lon))])
    })
    setNames(Filter(function(x) !is.null(x), x), NULL)
  } else {
    if(is.null(polygon)){
      res <- df_to_SpatialPointsDataFrame(input, lon = lon, lat = lat)
    } else {
      res <- df_to_SpatialPolygonsDataFrame(input)
    }
    as.geojson(res, file, ...)
  }
}

#' @export
#' @rdname to_geojson
to_geojson.list <- function(input, lat = "latitude", lon = "longitude", polygon=NULL, output='list', file = "myfile.geojson", ...){
  x <- lapply(input, function(l) {
    if (is.null(l[[lat]]) || is.null(l[[lon]])) {
      return(NULL)
    }
    type <- ifelse(is.null(polygon), "Point", "Polygon")
    list(type = type,
         geometry = list(type = "Point",
                         coordinates = as.numeric(c(l[[lon]], l[[lat]]))),
         properties = l[!(names(l) %in% c(lat, lon))])
  })
  res <- setNames(Filter(function(x) !is.null(x), x), NULL)
  if(output == 'list'){ res } else {
    list_to_geojson(input, lat=lat, lon=lon, polygon=polygon, ...)
  }
}

list_to_geojson <- function(input, file = "myfile.geojson", polygon=NULL, lon, lat, ...){
  input <- data.frame(rbind_all(lapply(input, function(x){
    tmp <- data.frame(type=x$type,
                      geometry_type=x$geometry$type,
                      longitude=x$geometry$coordinates[1],
                      latitude=x$geometry$coordinates[2],
               x$properties,
               stringsAsFactors = FALSE)
#     names(tmp)[5:8] <- paste('properties_', names(tmp)[5:8], sep = "")
    tmp
  })))
  if(is.null(polygon)){
    out <- df_to_SpatialPointsDataFrame(input, lon=lon, lat=lat)
  } else {
    out <- df_to_SpatialPolygonsDataFrame(input)
  }
  as.geojson(out, file, ...)
}

df_to_SpatialPolygonsDataFrame <- function(x){
  x_split <- split(x, f = x$group)
  res <- lapply(x_split, function(y){
    coordinates(y) <- c("long","lat")
    Polygon(y)
  })
  res <- Polygons(res, "polygons")
  hh <- SpatialPolygons(list(res))
  as(hh, "SpatialPolygonsDataFrame")
}

df_to_SpatialPointsDataFrame <- function(x, lon, lat) { coordinates(x) <- c(lon,lat); x }

bbox2df <- function(x){
  c(x[1,1], x[1,2], x[2,1], x[2,2])
}

sptogeolist <- function(x){
  list(type = "Polygon",
       bbox = bbox2df(x@bbox),
       coordinates =
         lapply(x@polygons, function(l) {
           apply(l@Polygons[[1]]@coords, 1, as.list)
         }),
       properties = NULL
  )
  # setNames(Filter(function(x) !is.null(x), x), NULL)  
}

as.geojson <- function(input, file = "myfile.geojson", ...){
  if (!grepl("\\.geojson$", file)) {
    file <- paste0(file, ".geojson")
  }
  file <- path.expand(file)
  unlink(file)
  destpath <- dirname(file)
  if (!file.exists(destpath)) dir.create(destpath)
  write_ogr(input, tempfile(), file, ...)
}

write_ogr <- function(input, dir, file, ...){
  input@data <- convert_ordered(input@data)
  writeOGR(input, dir, "", "GeoJSON", ...)
  file.rename(dir, file)
  message("Success! File is at ", file)
}

convert_ordered <- function(df) {
  data.frame(lapply(df, function(x) {
    if ("ordered" %in% class(x)) x <- as.character(x)
    x
  }), 
  stringsAsFactors = FALSE)
}
