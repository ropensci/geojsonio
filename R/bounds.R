#' Get bounds for a list or geo_list
#' 
#' @export
#' @param x An object of class list or geo_list
#' @param ... Ignored
#' @return A vector of the form min longitude, min latitude, max longitude, max latitude
#' @examples
#' # numeric 
#' vec <- c(-99.74,32.45)
#' x <- geojson_list(vec)
#' bounds(x)
#' 
#' # list
#' mylist <- list(list(latitude=30, longitude=120, marker="red"),
#'                list(latitude=30, longitude=130, marker="blue"))
#' x <- geojson_list(mylist)
#' bounds(x)
#' 
#' # data.frame
#' x <- geojson_list(states[1:20,])
#' bounds(x)
bounds <- function(x, ...) {
  UseMethod("bounds")
}

#' @export
bounds.list <- function(x, ...) {
  long <- unlist(lapply(x$geometry$coordinates, function(z) {
    sapply(z, "[[", 1)
  }))
  lat <- unlist(lapply(x$geometry$coordinates, function(z) {
    sapply(z, "[[", 2)
  }))
  c(min(long), min(lat), max(long), max(lat))
}

#' @export
bounds.geo_list <- function(x, ...) {
  all <- lapply(x$features, "[[", c("geometry", "coordinates"))
  long <- sapply(all, "[[", 1)
  lat <- sapply(all, "[[", 2)
  c(min(long), min(lat), max(long), max(lat))
}
