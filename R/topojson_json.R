#' Convert many input types with spatial data to TopoJSON
#' as a JSON string
#'
#' @export
#' @inheritParams geojson_json
#' @inheritParams topojson_write
#' @param ... args passed down to [geojson_json()]; see [geojson_json()] for
#' help on what's supported here
#' @details The `type` parameter is automatically converted to
#' `type="auto"` if a sf, sfc, or sfg class is passed to `input`
#' @return An object of class `geo_json` (and `json`)
#' @examples \dontrun{
#' # From a numeric vector of length 2, making a point type
#' topojson_json(c(-99.74, 32.45), pretty = TRUE)
#' topojson_json(c(-99.74, 32.45), type = "GeometryCollection")
#'
#' ## polygon type
#' ### this requires numeric class input, so inputting a list will dispatch on the list method
#' poly <- c(
#'   c(-114.345703125, 39.436192999314095),
#'   c(-114.345703125, 43.45291889355468),
#'   c(-106.61132812499999, 43.45291889355468),
#'   c(-106.61132812499999, 39.436192999314095),
#'   c(-114.345703125, 39.436192999314095)
#' )
#' topojson_json(poly, geometry = "polygon", pretty = TRUE)
#'
#' # Lists
#' ## From a list of numeric vectors to a polygon
#' vecs <- list(c(100.0, 0.0), c(101.0, 0.0), c(101.0, 1.0), c(100.0, 1.0), c(100.0, 0.0))
#' topojson_json(vecs, geometry = "polygon", pretty = TRUE)
#'
#' ## from a named list
#' mylist <- list(
#'   list(latitude = 30, longitude = 120, marker = "red"),
#'   list(latitude = 30, longitude = 130, marker = "blue")
#' )
#' topojson_json(mylist, lat = "latitude", lon = "longitude")
#'
#' # From a data.frame to points
#' topojson_json(us_cities[1:2, ], lat = "lat", lon = "long", pretty = TRUE)
#' topojson_json(us_cities[1:2, ],
#'   lat = "lat", lon = "long",
#'   type = "GeometryCollection", pretty = TRUE
#' )
#'
#' # from data.frame to polygons
#' head(states)
#' ## make list for input to e.g., rMaps
#' topojson_json(states[1:351, ], lat = "lat", lon = "long", geometry = "polygon", group = "group")
#'
#' # from a geo_list
#' a <- geojson_list(us_cities[1:2, ], lat = "lat", lon = "long")
#' topojson_json(a)
#'
#' # sp classes
#'
#' ## From SpatialPolygons class
#' library("sp")
#' poly1 <- Polygons(list(Polygon(cbind(
#'   c(-100, -90, -85, -100),
#'   c(40, 50, 45, 40)
#' ))), "1")
#' poly2 <- Polygons(list(Polygon(cbind(
#'   c(-90, -80, -75, -90),
#'   c(30, 40, 35, 30)
#' ))), "2")
#' sp_poly <- SpatialPolygons(list(poly1, poly2), 1:2)
#' topojson_json(sp_poly)
#' topojson_json(sp_poly, pretty = TRUE)
#'
#' ## data.frame to geojson
#' geojson_write(us_cities[1:2, ], lat = "lat", lon = "long") %>% as.json()
#'
#' # From SpatialPoints class
#' x <- c(1, 2, 3, 4, 5)
#' y <- c(3, 2, 5, 1, 4)
#' s <- SpatialPoints(cbind(x, y))
#' topojson_json(s)
#'
#' ## From SpatialPointsDataFrame class
#' s <- SpatialPointsDataFrame(cbind(x, y), mtcars[1:5, ])
#' topojson_json(s)
#'
#' ## From SpatialLines class
#' library("sp")
#' c1 <- cbind(c(1, 2, 3), c(3, 2, 2))
#' c2 <- cbind(c1[, 1] + .05, c1[, 2] + .05)
#' c3 <- cbind(c(1, 2, 3), c(1, 1.5, 1))
#' L1 <- Line(c1)
#' L2 <- Line(c2)
#' L3 <- Line(c3)
#' Ls1 <- Lines(list(L1), ID = "a")
#' Ls2 <- Lines(list(L2, L3), ID = "b")
#' sl1 <- SpatialLines(list(Ls1))
#' sl12 <- SpatialLines(list(Ls1, Ls2))
#' topojson_json(sl1)
#' topojson_json(sl12)
#'
#' ## From SpatialLinesDataFrame class
#' dat <- data.frame(
#'   X = c("Blue", "Green"),
#'   Y = c("Train", "Plane"),
#'   Z = c("Road", "River"), row.names = c("a", "b")
#' )
#' sldf <- SpatialLinesDataFrame(sl12, dat)
#' topojson_json(sldf)
#' topojson_json(sldf, pretty = TRUE)
#'
#' ## From SpatialGrid
#' x <- GridTopology(c(0, 0), c(1, 1), c(5, 5))
#' y <- SpatialGrid(x)
#' topojson_json(y)
#'
#' ## From SpatialGridDataFrame
#' sgdim <- c(3, 4)
#' sg <- SpatialGrid(GridTopology(rep(0, 2), rep(10, 2), sgdim))
#' sgdf <- SpatialGridDataFrame(sg, data.frame(val = 1:12))
#' topojson_json(sgdf)
#'
#' # From SpatialPixels
#' library("sp")
#' pixels <- suppressWarnings(SpatialPixels(SpatialPoints(us_cities[c("long", "lat")])))
#' summary(pixels)
#' topojson_json(pixels)
#'
#' # From SpatialPixelsDataFrame
#' library("sp")
#' pixelsdf <- suppressWarnings(
#'   SpatialPixelsDataFrame(points = canada_cities[c("long", "lat")], data = canada_cities)
#' )
#' topojson_json(pixelsdf)
#'
#' # From sf classes:
#' if (require(sf)) {
#'   ## sfg (a single simple features geometry)
#'   p1 <- rbind(c(0, 0), c(1, 0), c(3, 2), c(2, 4), c(1, 4), c(0, 0))
#'   poly <- rbind(c(1, 1), c(1, 2), c(2, 2), c(1, 1))
#'   poly_sfg <- st_polygon(list(p1))
#'   topojson_json(poly_sfg)
#'
#'   ## sfc (a collection of geometries)
#'   p1 <- rbind(c(0, 0), c(1, 0), c(3, 2), c(2, 4), c(1, 4), c(0, 0))
#'   p2 <- rbind(c(5, 5), c(5, 6), c(4, 5), c(5, 5))
#'   poly_sfc <- st_sfc(st_polygon(list(p1)), st_polygon(list(p2)))
#'   topojson_json(poly_sfc)
#'
#'   ## sf (collection of geometries with attributes)
#'   p1 <- rbind(c(0, 0), c(1, 0), c(3, 2), c(2, 4), c(1, 4), c(0, 0))
#'   p2 <- rbind(c(5, 5), c(5, 6), c(4, 5), c(5, 5))
#'   poly_sfc <- st_sfc(st_polygon(list(p1)), st_polygon(list(p2)))
#'   poly_sf <- st_sf(foo = c("a", "b"), bar = 1:2, poly_sfc)
#'   topojson_json(poly_sf)
#' }
#'
#' ## Pretty print a json string
#' topojson_json(c(-99.74, 32.45))
#' topojson_json(c(-99.74, 32.45)) %>% pretty()
#' }
topojson_json <- function(input, lat = NULL, lon = NULL, group = NULL,
                          geometry = "point", type = "FeatureCollection", convert_wgs84 = FALSE,
                          crs = NULL, object_name = "foo", quantization = 0, ...) {
  if (inherits(input, c("sf", "sfc", "sfg"))) {
    type <- "auto"
    message("sf/sfc/sfg class detected; using type=\"auto\"")
  }
  geo2topo(geojson_json(
    input = input, lat = lat, lon = lon,
    group = group, geometry = geometry, type = type,
    convert_wgs84 = convert_wgs84, crs = crs, ...
  ),
  object_name = object_name, quantization = quantization
  )
}
