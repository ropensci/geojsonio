#' Get palette actual name from longer names
#' 
#' @import 
#' @export
#' @param input
#' @param lat Latitude name
#' @param lon Longitude name

to_geojson <- function(...){
  UseMethod("classification")
}

#' @method to_geojson default
#' @export
#' @rdname to_geojson
to_geojson.default <- function(input, lat = "latitude", lon = "longitude", ...){
    x <- lapply(input, function(l) {
        if (is.null(l[[lat]]) || is.null(l[[lon]])) {
            return(NULL)
        }
        list(type = "Feature", geometry = list(type = "Point", coordinates = as.numeric(c(l[[lon]], 
            l[[lat]]))), properties = l[!(names(l) %in% c(lat, lon))])
    })
    setNames(Filter(function(x) !is.null(x), x), NULL)
}

#' @method to_geojson data.frame
#' @export
#' @rdname to_geojson
to_geojson.data.frame <- function(input, lat = "latitude", lon = "longitude", ...){
  x <- lapply(input, function(l) {
    if (is.null(l[[lat]]) || is.null(l[[lon]])) {
      return(NULL)
    }
    list(type = "Feature", geometry = list(type = "Point", coordinates = as.numeric(c(l[[lon]], 
                                                                                      l[[lat]]))), properties = l[!(names(l) %in% c(lat, lon))])
  })
  setNames(Filter(function(x) !is.null(x), x), NULL)
}

#' @method to_geojson list
#' @export
#' @rdname to_geojson
to_geojson.list <- function(input, lat = "latitude", lon = "longitude", ...){
  x <- lapply(input, function(l) {
    if (is.null(l[[lat]]) || is.null(l[[lon]])) {
      return(NULL)
    }
    list(type = "Feature", geometry = list(type = "Point", coordinates = as.numeric(c(l[[lon]], 
                                                                                      l[[lat]]))), properties = l[!(names(l) %in% c(lat, lon))])
  })
  setNames(Filter(function(x) !is.null(x), x), NULL)
}

#' @method to_geojson sp
#' @export
#' @rdname to_geojson
to_geojson.sp <- function(input, lat = "latitude", lon = "longitude", ...){
  x <- lapply(input, function(l) {
    if (is.null(l[[lat]]) || is.null(l[[lon]])) {
      return(NULL)
    }
    list(type = "Feature", geometry = list(type = "Point", coordinates = as.numeric(c(l[[lon]], 
                                                                                      l[[lat]]))), properties = l[!(names(l) %in% c(lat, lon))])
  })
  setNames(Filter(function(x) !is.null(x), x), NULL)
}