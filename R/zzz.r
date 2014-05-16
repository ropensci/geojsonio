#' Compact for togeojson
#' @param l Input list
#' @export
#' @keywords internal
togeo_compact <- function(l) Filter(Negate(is.null), l)
