#' capture writeOGR 
#' 
#' @export
#' @examples \dontrun{
#' library("rgdal")
#' cities <- readOGR(system.file("vectors", package = "rgdal")[1], "cities")
#' cwgr(cities[1:10,], "cities")
#' }
cwgr <- function(obj, layer) {
  capturedWriteOGR(obj, object.size(obj), layer, writeOGR)
}
