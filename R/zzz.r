#' Compact for togeojson
#' @param l Input list
#' @export
togeo_compact <- function(l) Filter(Negate(is.null), l)
