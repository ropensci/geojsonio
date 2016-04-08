#' capture writeOGR 
#' 
#' @export
#' @param obj Object, e.g, a data.frame
#' @param layer layer name, default: \code{""}
#' @param layer_options layer options, as a character vector
#' @examples \dontrun{
#' library("rgdal")
#' cities <- readOGR(system.file("vectors", package = "rgdal")[1], "cities")
#' cwgr(cities[1:10,], "cities")
#' 
#' coordinates(states) <- ~long+lat
#' cwgr(states[1:100,], "states")
#' }
cwgr <- function(obj, layer = "", layer_options = "") {
  capturedWriteOGR(obj, object.size(obj), layer, writeOGR, layer_options)
}
