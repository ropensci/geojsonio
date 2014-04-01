#' Get palette actual name from longer names
#' @param list_ A list
#' @param lat Latitude name
#' @param lon Longitude name
#' @export
#' @keywords internal

spocc_rcharts_togeojson <- function(list_, lat = "latitude", lon = "longitude") {
    x <- lapply(list_, function(l) {
        if (is.null(l[[lat]]) || is.null(l[[lon]])) {
            return(NULL)
        }
        list(type = "Feature", geometry = list(type = "Point", coordinates = as.numeric(c(l[[lon]], 
            l[[lat]]))), properties = l[!(names(l) %in% c(lat, lon))])
    })
    setNames(Filter(function(x) !is.null(x), x), NULL)
}