#' topojson projections and extensions
#'
#' @export
#' @param proj Map projection name. One of albers, albersUsa, azimuthalEqualArea,
#' azimuthalEquidistant, conicEqualArea, conicConformal, conicEquidistant, equirectangular,
#' gnomonic, mercator, orthographic, stereographic, or transverseMercator.
#' @param rotate If rotation is specified, sets the projection's three-axis rotation to the
#' specified angles yaw, pitch and roll (or equivalently longitude, latitude and roll)
#' in degrees and returns the projection. If rotation is not specified, returns the current
#' rotation which defaults [0, 0, 0]. If the specified rotation has only two values, rather than
#' three, the roll is assumed to be 0.
#' @param center If center is specified, sets the projection's center to the specified location, a
#' two-element array of longitude and latitude in degrees and returns the projection. If center is
#' not specified, returns the current center which defaults to (0,0)
#' @param translate If point is specified, sets the projection's translation offset to the
#' specified two-element array [x, y] and returns the projection. If point is not specified,
#' returns the current translation offset which defaults to [480, 250]. The translation offset
#' determines the pixel coordinates of the projection's center. The default translation offset
#' places (0,0) at the center of a 960x500 area.
#' @param scale If scale is specified, sets the projection's scale factor to the specified value
#' and returns the projection. If scale is not specified, returns the current scale factor which
#' defaults to 150. The scale factor corresponds linearly to the distance between projected points.
#' However, scale factors are not consistent across projections.
#' @param clipAngle If angle is specified, sets the projection's clipping circle radius to the
#' specified angle in degrees and returns the projection. If angle is null, switches to
#' antimeridian cutting rather than small-circle clipping. If angle is not specified, returns the
#' current clip angle which defaults to null. Small-circle clipping is independent of viewport
#' clipping via clipExtent.
#' @param precision If precision is specified, sets the threshold for the projection's adaptive
#' resampling to the specified value in pixels and returns the projection. This value corresponds
#' to the Douglas-Peucker distance. If precision is not specified, returns the projection's current
#' resampling precision which defaults to Math.SQRT(1/2).
#' @param parallels Depends on the projection used! See
#' \url{https://github.com/mbostock/d3/wiki/Geo-Projections#standard-projections} for help
#' @param clipExtent If extent is specified, sets the projection's viewport clip extent to the
#' specified bounds in pixels and returns the projection. The extent bounds are specified as an
#' array [[x0, y0], [x1, y1]], where x0 is the left-side of the viewport, y0 is the top, x1 is
#' the right and y1 is the bottom. If extent is null, no viewport clipping is performed. If extent
#' is not specified, returns the current viewport clip extent which defaults to null. Viewport
#' clipping is independent of small-circle clipping via clipAngle.
#' @param invert Projects backward from Cartesian coordinates (in pixels) to spherical coordinates
#' (in degrees). Returns an array [longitude, latitude] given the input array [x, y].
#' @examples
#' projections(proj="albers")
#' projections(proj="albers", rotate='[98 + 00 / 60, -35 - 00 / 60]', scale=5700)
#' projections(proj="albers", scale=5700)
#' projections(proj="albers", translate='[55 * width / 100, 52 * height / 100]')
#' projections(proj="albers", clipAngle=90)
#' projections(proj="albers", precision=0.1)
#' projections(proj="albers", parallels='[30, 62]')
#' projections(proj="albers", clipExtent='[[105 - 87, 40], [105 + 87 + 1e-6, 82 + 1e-6]]')
#' projections(proj="albers", invert=60)
#' projections("orthographic")
#'
#' @examples \dontrun{
#' projections("alber")
#' }
projections <- function(proj, rotate=NULL, center=NULL, translate=NULL, scale=NULL,
                        clipAngle=NULL, precision=NULL, parallels=NULL, clipExtent=NULL, invert=NULL){
  if (missing(proj)) stop("You must provide a character string to 'proj'", call. = FALSE)
  vals <- list(
    albers = 'd3.geo.albers()%s',
    albersUsa = 'd3.geo.albersUsa()',
    azimuthalEqualArea = 'd3.geo.azimuthalEqualArea()',
    azimuthalEquidistant = 'd3.geo.azimuthalEquidistant()',
    conicEqualArea = 'd3.geo.conicEqualArea()',
    conicConformal = 'd3.geo.conicConformal()',
    conicEquidistant = 'd3.geo.conicEquidistant()',
    equirectangular = 'd3.geo.equirectangular()',
    gnomonic = 'd3.geo.gnomonic()',
    mercator = 'd3.geo.mercator()',
    orthographic = 'd3.geo.orthographic()',
    stereographic = 'd3.geo.stereographic()',
    transverseMercator = 'd3.geo.transverseMercator()'
  )
  got <- vals[[proj]]
  args <- tg_compact(list(rotate = rotate, center = center, translate = translate, scale = scale,
                             clipAngle = clipAngle, precision = precision, parallels = parallels,
                             clipExtent = clipExtent, invert = invert))
  out <- list()
  for (i in seq_along(args)) {
    out[i] <- sprintf(".%s(%s)", names(args[i]), args[[i]])
  }
  argstogo <- paste(out, collapse = "")
  gotgo <- sprintf(got, argstogo)
  if (is.null(gotgo)) {
    "That projection doesn't exist, check your spelling"
  } else { 
    gotgo 
  }
}
