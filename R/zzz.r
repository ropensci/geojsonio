#' Compact for togeojson
#' @param l Input list
#' @keywords internal
togeo_compact <- function(l) Filter(Negate(is.null), l)
