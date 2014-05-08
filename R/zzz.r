#' Compact for togeojson
#' @param l
#' @export
togeo_compact <- function(l) Filter(Negate(is.null), l)
