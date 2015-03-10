#' Convert inputs to JSON
#'
#' @export
#' @param x Input, character string
#' @param indent (integer) Number of spaces to indent
pretty <- function(x, indent = 4) {
  jsonlite::prettify(x, indent)
}
