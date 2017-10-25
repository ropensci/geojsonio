#' Convert many input types with spatial data to TopoJSON
#' as a list
#'
#' @export
#' @inheritParams geojson_list
#' @return a list with TopoJSON
#' @details Internally, we call \code{\link{topojson_json}}, then use
#' an internal function to convert that JSON output to a list
#' @examples \dontrun{
#' # From a numeric vector of length 2 to a point
#' vec <- c(-99.74,32.45)
#' topojson_list(vec)
#'
#' # Lists
#' ## From a list
#' mylist <- list(list(latitude=30, longitude=120, marker="red"),
#'                list(latitude=30, longitude=130, marker="blue"))
#' topojson_list(mylist)
#'
#' ## From a list of numeric vectors to a polygon
#' vecs <- list(c(100.0,0.0), c(101.0,0.0), c(101.0,1.0), c(100.0,1.0), c(100.0,0.0))
#' topojson_list(vecs, geometry="polygon")
#'
#' # from data.frame to points
#' (res <- topojson_list(us_cities[1:2,], lat='lat', lon='long'))
#' as.json(res)
#' ## guess lat/long columns
#' topojson_list(us_cities[1:2,])
#' topojson_list(states[1:3,])
#' topojson_list(states[1:351,], geometry="polygon", group='group')
#' topojson_list(canada_cities[1:30,])
#'
#' # from data.frame to polygons
#' head(states)
#' topojson_list(states[1:351, ], lat='lat', lon='long', geometry="polygon", group='group')
#'
#' # From SpatialPolygons class
#' library('sp')
#' poly1 <- Polygons(list(Polygon(cbind(c(-100,-90,-85,-100),
#'    c(40,50,45,40)))), "1")
#' poly2 <- Polygons(list(Polygon(cbind(c(-90,-80,-75,-90),
#'    c(30,40,35,30)))), "2")
#' sp_poly <- SpatialPolygons(list(poly1, poly2), 1:2)
#' topojson_list(sp_poly)
#'
#' # From SpatialPolygonsDataFrame class
#' sp_polydf <- as(sp_poly, "SpatialPolygonsDataFrame")
#' topojson_list(input = sp_polydf)
#'
#' # From SpatialPoints class
#' x <- c(1,2,3,4,5)
#' y <- c(3,2,5,1,4)
#' s <- SpatialPoints(cbind(x,y))
#' topojson_list(s)
#'
#' # From SpatialPointsDataFrame class
#' s <- SpatialPointsDataFrame(cbind(x,y), mtcars[1:5,])
#' topojson_list(s)
#'
#' # From SpatialLines class
#' library("sp")
#' c1 <- cbind(c(1,2,3), c(3,2,2))
#' c2 <- cbind(c1[,1]+.05,c1[,2]+.05)
#' c3 <- cbind(c(1,2,3),c(1,1.5,1))
#' L1 <- Line(c1)
#' L2 <- Line(c2)
#' L3 <- Line(c3)
#' Ls1 <- Lines(list(L1), ID = "a")
#' Ls2 <- Lines(list(L2, L3), ID = "b")
#' sl1 <- SpatialLines(list(Ls1))
#' sl12 <- SpatialLines(list(Ls1, Ls2))
#' topojson_list(sl1)
#' topojson_list(sl12)
#' as.json(topojson_list(sl12))
#' as.json(topojson_list(sl12), pretty=TRUE)
#'
#' # From SpatialLinesDataFrame class
#' dat <- data.frame(X = c("Blue", "Green"),
#'                  Y = c("Train", "Plane"),
#'                  Z = c("Road", "River"), row.names = c("a", "b"))
#' sldf <- SpatialLinesDataFrame(sl12, dat)
#' topojson_list(sldf)
#' as.json(topojson_list(sldf))
#' as.json(topojson_list(sldf), pretty=TRUE)
#'
#' # From SpatialGrid
#' x <- GridTopology(c(0,0), c(1,1), c(5,5))
#' y <- SpatialGrid(x)
#' topojson_list(y)
#'
#' # From SpatialGridDataFrame
#' sgdim <- c(3,4)
#' sg <- SpatialGrid(GridTopology(rep(0,2), rep(10,2), sgdim))
#' sgdf <- SpatialGridDataFrame(sg, data.frame(val = 1:12))
#' topojson_list(sgdf)
#'
#' # From SpatialRings
#' library("rgeos")
#' r1 <- Ring(cbind(x=c(1,1,2,2,1), y=c(1,2,2,1,1)), ID="1")
#' r2 <- Ring(cbind(x=c(1,1,2,2,1), y=c(1,2,2,1,1)), ID="2")
#' r1r2 <- SpatialRings(list(r1, r2))
#' topojson_list(r1r2)
#'
#' # From SpatialRingsDataFrame
#' dat <- data.frame(id = c(1,2), value = 3:4)
#' r1r2df <- SpatialRingsDataFrame(r1r2, data = dat)
#' topojson_list(r1r2df)
#'
#' # From SpatialPixels
#' library("sp")
#' pixels <- suppressWarnings(SpatialPixels(SpatialPoints(us_cities[c("long", "lat")])))
#' summary(pixels)
#' topojson_list(pixels)
#'
#' # From SpatialPixelsDataFrame
#' library("sp")
#' pixelsdf <- suppressWarnings(
#'  SpatialPixelsDataFrame(points = canada_cities[c("long", "lat")], data = canada_cities)
#' )
#' topojson_list(pixelsdf)
#'
#' # From SpatialCollections
#' library("sp")
#' poly1 <- Polygons(list(Polygon(cbind(c(-100,-90,-85,-100), c(40,50,45,40)))), "1")
#' poly2 <- Polygons(list(Polygon(cbind(c(-90,-80,-75,-90), c(30,40,35,30)))), "2")
#' poly <- SpatialPolygons(list(poly1, poly2), 1:2)
#' coordinates(us_cities) <- ~long+lat
#' dat <- SpatialCollections(points = us_cities, polygons = poly)
#' out <- topojson_list(dat)
#' out[[1]]
#' out[[2]]
#' }
#'
#' # From sf classes:
#' if (require(sf)) {
#' ## sfg (a single simple features geometry)
#'   p1 <- rbind(c(0,0), c(1,0), c(3,2), c(2,4), c(1,4), c(0,0))
#'   poly <- rbind(c(1,1), c(1,2), c(2,2), c(1,1))
#'   poly_sfg <-st_polygon(list(p1))
#'   topojson_list(poly_sfg)
#'
#' ## sfc (a collection of geometries)
#'   p1 <- rbind(c(0,0), c(1,0), c(3,2), c(2,4), c(1,4), c(0,0))
#'   p2 <- rbind(c(5,5), c(5,6), c(4,5), c(5,5))
#'   poly_sfc <- st_sfc(st_polygon(list(p1)), st_polygon(list(p2)))
#'   topojson_list(poly_sfc)
#'
#' ## sf (collection of geometries with attributes)
#'   p1 <- rbind(c(0,0), c(1,0), c(3,2), c(2,4), c(1,4), c(0,0))
#'   p2 <- rbind(c(5,5), c(5,6), c(4,5), c(5,5))
#'   poly_sfc <- st_sfc(st_polygon(list(p1)), st_polygon(list(p2)))
#'   poly_sf <- st_sf(foo = c("a", "b"), bar = 1:2, poly_sfc)
#'   topojson_list(poly_sf)
#' }
#'

topojson_list <- function(input, lat = NULL, lon = NULL, group = NULL,
                         geometry = "point", type = "FeatureCollection",
                         convert_wgs84 = FALSE, crs = NULL, ...) {

  res <- topojson_json(input = input, lat = lat, lon = lon,
      group = group, geometry = geometry, type = type,
      convert_wgs84 = convert_wgs84, crs = crs, ...)
  if (inherits(res, c("character", "json", "geojson"))) {
    geojson_file_to_list(res)
  } else if (inherits(res, "list")) {
    lapply(res, geojson_file_to_list)
  } else {
    stop("can't handle object of class ", class(res))
  }
}
