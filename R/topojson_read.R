#' Read a topojson file
#'
#' @export
#'
#' @param file Path to a local file or a URL.
#' @param ... Further args passed on to \code{\link[jsonlite]{toJSON}}
#'
#' @examples \dontrun{
#' # From a file
#' topojson_read("~/asdfafaf")
#'
#' # From a URL
#' topojson_read('<URL>')
#' }

topojson_read <- function(...) UseMethod("topojson_read")

#' @export
#' @rdname topojson_read
topojson_read.file <- function(input, ...) read_topojson(as.path(input))

#' @export
#' @rdname topojson_read
topojson_read.url <- function(input, ...) read_topojson(as.path(input))
