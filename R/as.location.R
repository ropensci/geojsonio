#' Convert a path or URL to a location object.
#' 
#' @param x Input.
#' @param ... Ignored.
#' 
#' @export
as.location <- function(x, ...) UseMethod("as.location")

#' @export
#' @rdname as.location
as.location.file <- function(x, ...) as.location(x, ...)

#' @export
#' @rdname as.location
as.location.url <- function(x, ...) as.location(x, ...)
