#' Get centroid for a geo_list
#' 
#' @export
#' @param x An object of class geo_list
#' @param ... Ignored
#' @return A vector of the form longitude, latitude
#' @examples
#' # numeric
#' vec <- c(-99.74,32.45)
#' x <- geojson_list(vec)
#' centroid(x)
#' 
#' # list
#' mylist <- list(list(latitude=30, longitude=120, marker="red"),
#'                list(latitude=30, longitude=130, marker="blue"))
#' x <- geojson_list(mylist)
#' centroid(x)
#' 
#' # data.frame
#' x <- geojson_list(states[1:20,])
#' centroid(x)
centroid <- function(x, ...) {
  UseMethod("centroid")
}

#' @export
centroid.geo_list <- function(x, ...) {
  all <- lapply(x$features, "[[", c("geometry", "coordinates"))
  long <- sapply(all, "[[", 1)
  lat <- sapply(all, "[[", 2)
  c(mean(long), mean(lat))
}
