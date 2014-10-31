#' Read topojson from a local file or a URL
#'
#' @export
#'
#' @param x Path to a local file or a URL.
#' @param ... Further args passed on to \code{\link[rgdal]{readOGR}}
#'
#' @examples \donttest{
#' # From a file
#' file <- system.file("examples", "us_states.topojson", package = "togeojson")
#' geojson_read(file)
#'
#' # From a URL
#' url <- "https://raw.githubusercontent.com/shawnbot/d3-cartogram/master/data/us-states.topojson"
#' topojson_read(url)
#' 
#' # Use as.location first if you want
#' topojson_read(as.location("~/zillow_or.geojson"))
#' }

topojson_read <- function(...) UseMethod("topojson_read")

#' @export
#' @rdname topojson_read
topojson_read.character <- function(x, ...) read_json(as.location(x), ...)

#' @export
#' @rdname topojson_read
topojson_read.location <- function(x, ...) read_json(as.location(x))
