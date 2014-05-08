#' Get palette actual name from longer names
#'
#' @import sp rgdal
#' @export
#' @param input Input list, data.frame, or spatial class
#' @param lat Latitude name
#' @param lon Longitude name
#' @param polygon If a polygon is defined in a data.frame, this is the column that defines the grouping
#' of the polygons in the data.frame
#' @param output One of 'list' or 'geojson'
#' @param ... Further args
#' @examples \dontrun{
#' library(maps)
#' data(us.cities)
#' head(us.cities)
#' to_geojson(input=us.cities, lat='lat', lon='long')
#'
#' # polygons
#' library(ggplot2)
#' states <- map_data("state")
#' head(states)
#' ## make list for input to e.g., rMaps
#' res <- to_geojson(input=states, lat='lat', lon='long', group='group')
#' ## make geojson from the list
#' list_to_geojson.SpatialPolygonsDataFrame(res)
#'
#' ## From a list
#' mylist <- list(list(latitude=30, longitude=120, marker="red"),
#'                list(latitude=30, longitude=130, marker="blue"))
#' to_geojson(mylist)
#' }
to_geojson <- function(...){
  UseMethod("to_geojson")
}

#' @method to_geojson data.frame
#' @export
#' @rdname to_geojson
to_geojson.data.frame <- function(input, lat = "latitude", lon = "longitude", polygon=NULL, output='list', ...){
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
    SpatialPolygonsDataFrame_togeojson(res)
  }
}

#' @method to_geojson list
#' @export
#' @rdname to_geojson
to_geojson.list <- function(input, lat = "latitude", lon = "longitude", polygon=NULL, output='list', ...){
  if(output=='list'){
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
    list_to_geojson(input, lat=lat, lon=lon, polygon=polygon)
  }
}

list_to_geojson <- function(input, destpath = "~/", outfilename = "myfile", polygon=NULL, lon, lat){
  input <- do.call(rbind.fill, lapply(input, data.frame))
  if(is.null(polygon)){
    out <- df_to_SpatialPointsDataFrame(input, lon=lon, lat=lat)
  } else {
    out <- df_to_SpatialPolygonsDataFrame(input)
  }
  unlink(paste0(path.expand(destpath), outfilename, ".geojson"))
  writeOGR(out, paste0(path.expand(destpath), outfilename, ".geojson"), outfilename,
           driver = "GeoJSON")
  message(paste0("Success! File is at ", path.expand(destpath), outfilename,
                 ".geojson"))
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

df_to_SpatialPointsDataFrame <- function(x, lon, lat){
  coordinates(x) <- c(lon,lat)
  return( x )
}

SpatialPolygonsDataFrame_togeojson <- function(input, destpath = "~/", outfilename = "myfile"){
  unlink(paste0(path.expand(destpath), outfilename, ".geojson"))
  writeOGR(input, paste0(path.expand(destpath), outfilename, ".geojson"), outfilename,
           driver = "GeoJSON")
  message(paste0("Success! File is at ", path.expand(destpath), outfilename,
                 ".geojson"))
}
