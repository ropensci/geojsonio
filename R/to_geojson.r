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
#' @param despath A directory path (e.g., ~/mydir)
#' @param outfilename A file name (e.g., myfile), without the .geojson on the end.
#' @param ... Further args, not used.
#' 
#' @details description...
#' 
#' @examples \dontrun{
#' library(maps)
#' data(us.cities)
#' head(us.cities)
#' to_geojson(input=us.cities, lat='lat', lon='long')
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
#' to_geojson(mylist)
#' 
#' # From a numeric vector of length 2
#' vec <- c(32.45,-99.74)
#' to_geojson(vec)
#' 
#' # From SpatialPolygons class
#' poly1 <- Polygons(list(Polygon(cbind(c(32.45,-99.74,49.45,32.45), 
#'    c(32.45,-99.74,32.45,32.45)))), "1")
#' poly2 <- Polygons(list(Polygon(cbind(c(39.45,-108.74,49.45,39.45), 
#'    c(39.45,-99.74,32.45,39.45)))), "2")
#' sp_poly <- SpatialPolygons(list(poly1, poly2), 1:2)
#' to_geojson(sp_poly)
#' 
#' # From SpatialPolygonsDataFrame class
#' sp_polydf <- as(sp_poly, "SpatialPolygonsDataFrame")
#' to_geojson(input = sp_polydf)
#' to_geojson(input = sp_polydf, destpath = "~/things/", outfilename = "that")
#' }

to_geojson <- function(...) UseMethod("to_geojson")

#' @export
#' @rdname to_geojson
to_geojson.SpatialPolygons <- function(input, lat = "latitude", lon = "longitude", polygon=NULL, output='list', ...){
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
    SpatialPolygonsDataFrame_togeojson(res)
  }
}

#' @export
#' @rdname to_geojson
to_geojson.SpatialPolygonsDataFrame <- function(input, destpath = "~/", outfilename = "myfile", ...){
  SpatialPolygonsDataFrame_togeojson(input, destpath = destpath, outfilename = outfilename)
}

#' @export
#' @rdname to_geojson
to_geojson.numeric <- function(input, lat = "latitude", lon = "longitude", polygon=NULL, output='list', ...){
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
    SpatialPolygonsDataFrame_togeojson(res)
  }
}

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
  input <- rbind_all(lapply(input, function(x){
    tmp <- data.frame(type=x$type, geometry_type=x$geometry$type, lon=x$geometry$coordinates[1], lat=x$geometry$coordinates[2],
               x$properties,
               stringsAsFactors = FALSE)
    names(tmp)[5:8] <- paste('properties_', names(tmp)[5:8], sep = "")
    tmp
  }))
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
