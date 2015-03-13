#' Convert json input to pretty printed output
#'
#' @export
#' @param x Input, character string
#' @param indent (integer) Number of spaces to indent
#' @details Only works with json class input. This is a simple wrapper around
#' \code{\link[jsonlite]{prettify}}, so you can easily use that yourself.
pretty <- function(x, indent = 4) {
  UseMethod("pretty")
}

#' @export
pretty.json <- function(x, indent = 4) {
  jsonlite::prettify(x, indent)
}

#' @export
pretty.geo_list <- function(x, indent = 4) {
  stop("No method for geo_list", call. = FALSE)
}
