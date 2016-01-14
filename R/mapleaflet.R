#' Make an interactive map locally
#'
#' @export
#'
#' @param input Input object
#' @param lat Name of latitude variable
#' @param lon Name of longitude variable
#' @param basemap Basemap to use. See \code{\link[leaflet]{addProviderTiles}}.
#' Default: \code{Stamen.Toner}
#' @param ... Further arguments passed on to \code{\link[leaflet]{addPolygons}},
#' \code{\link[leaflet]{addMarkers}}, \code{\link[leaflet]{addGeoJSON}}, or
#' \code{\link[leaflet]{addPolylines}}
#' @examples \dontrun{
#' # We'll need leaflet below
#' library("leaflet")
#'
#' # From file
#' file <- "myfile.geojson"
#' geojson_write(us_cities[1:20, ], lat='lat', lon='long', file = file)
#' map_leaf(as.location(file))
#'
#' # From SpatialPoints class
#' library("sp")
#' x <- c(1,2,3,4,20)
#' y <- c(3,2,5,3,4)
#' s <- SpatialPoints(cbind(x,y))
#' map_leaf(s)
#'
#' # from SpatialPointsDataFrame class
#' x <- c(1,2,3,4,5)
#' y <- c(3,2,5,1,4)
#' s <- SpatialPointsDataFrame(cbind(x,y), mtcars[1:5,])
#' map_leaf(s)
#'
#' # from SpatialPolygons class
#' poly1 <- Polygons(list(Polygon(cbind(c(-100,-90,-85,-100),
#'    c(40,50,45,40)))), "1")
#' poly2 <- Polygons(list(Polygon(cbind(c(-90,-80,-75,-90),
#'    c(30,40,35,30)))), "2")
#' sp_poly <- SpatialPolygons(list(poly1, poly2), 1:2)
#' map_leaf(sp_poly)
#'
#' # From SpatialPolygonsDataFrame class
#' sp_polydf <- as(sp_poly, "SpatialPolygonsDataFrame")
#' map_leaf(sp_poly)
#'
#' # From SpatialLines class
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
#' map_leaf(sl1)
#' map_leaf(sl12)
#'
#' # From SpatialLinesDataFrame class
#' dat <- data.frame(X = c("Blue", "Green"),
#'                  Y = c("Train", "Plane"),
#'                  Z = c("Road", "River"), row.names = c("a", "b"))
#' sldf <- SpatialLinesDataFrame(sl12, dat)
#' map_leaf(sldf)
#'
#' # From SpatialGrid
#' x <- GridTopology(c(0,0), c(1,1), c(5,5))
#' y <- SpatialGrid(x)
#' map_leaf(y)
#'
#' # From SpatialGridDataFrame
#' sgdim <- c(3,4)
#' sg <- SpatialGrid(GridTopology(rep(0,2), rep(10,2), sgdim))
#' sgdf <- SpatialGridDataFrame(sg, data.frame(val = 1:12))
#' map_leaf(sgdf)
#'
#' # from data.frame
#' map_leaf(us_cities)
#'
#' ## another example
#' head(states)
#' map_leaf(states[1:351, ])
#'
#' ## From a named list
#' mylist <- list(list(lat=30, long=120, marker="red"),
#'                list(lat=30, long=130, marker="blue"))
#' map_leaf(mylist, lat="lat", lon="long")
#' 
#' ## From an unnamed list
#' poly <- list(c(-114.345703125,39.436192999314095),
#'              c(-114.345703125,43.45291889355468),
#'              c(-106.61132812499999,43.45291889355468),
#'              c(-106.61132812499999,39.436192999314095),
#'              c(-114.345703125,39.436192999314095))
#' map_leaf(poly)
#' ## NOTE: Polygons from lists aren't supported yet
#'
#' # From a json object
#' map_leaf(geojson_json(c(-99.74, 32.45)))
#' map_leaf(geojson_json(c(-119, 45)))
#' map_leaf(geojson_json(c(-99.74, 32.45)))
#' ## another example
#' map_leaf(geojson_json(us_cities[1:10,], lat='lat', lon='long'))
#'
#' # From a geo_list object
#' (res <- geojson_list(us_cities[1:2,], lat='lat', lon='long'))
#' map_leaf(res)
#'
#' # From SpatialPixels
#' pixels <- suppressWarnings(SpatialPixels(SpatialPoints(us_cities[c("long", "lat")])))
#' summary(pixels)
#' map_leaf(pixels)
#'
#' # From SpatialPixelsDataFrame
#' pixelsdf <- suppressWarnings(
#'  SpatialPixelsDataFrame(points = canada_cities[c("long", "lat")], data = canada_cities)
#' )
#' map_leaf(pixelsdf)
#'
#' # From SpatialRings
#' library("rgeos")
#' r1 <- Ring(cbind(x=c(1,1,2,2,1), y=c(1,2,2,1,1)), ID="1")
#' r2 <- Ring(cbind(x=c(1,1,2,2,1), y=c(1,2,2,1,1)), ID="2")
#' r1r2 <- SpatialRings(list(r1, r2))
#' map_leaf(r1r2)
#'
#' # From SpatialRingsDataFrame
#' dat <- data.frame(id = c(1,2), value = 3:4)
#' r1r2df <- SpatialRingsDataFrame(r1r2, data = dat)
#' map_leaf(r1r2df)
#'
#' # basemap toggling ------------------------
#' map_leaf(us_cities, basemap = "Acetate.terrain")
#' map_leaf(us_cities, basemap = "CartoDB.Positron")
#' map_leaf(us_cities, basemap = "OpenTopoMap")
#'
#' # leaflet options ------------------------
#' map_leaf(us_cities) %>%
#'    addPopups(-122.327298, 47.597131, "foo bar", options = popupOptions(closeButton = FALSE))
#'
#' ####### not working yet
#' # From a numeric vector
#' ## of length 2 to a point
#' ## vec <- c(-99.74,32.45)
#' ## map_leaf(vec)
#' }

map_leaf <- function(input, lat = NULL, lon = NULL, basemap = "Stamen.Toner", ...) {
  UseMethod("map_leaf")
}

# Spatial classes methods from sp package ----------------------
#' @export
map_leaf.SpatialPoints <- function(input, lat = NULL, lon = NULL, basemap = "Stamen.Toner", ...) {
  check_4_leaflet()
  petiole(input, bounds = sp_bounds(input), basemap, ...)
}

#' @export
map_leaf.SpatialPointsDataFrame <- function(input, lat = NULL, lon = NULL, basemap = "Stamen.Toner", ...) {
  check_4_leaflet()
  petiole(input, bounds = sp_bounds(input), basemap, ...)
}

#' @export
map_leaf.SpatialPolygons <- function(input, lat = NULL, lon = NULL, basemap = "Stamen.Toner", ...) {
  check_4_leaflet()
  petiole(input, bounds = sp_bounds(input), basemap, ...)
}

#' @export
map_leaf.SpatialPolygonsDataFrame <- function(input, lat = NULL, lon = NULL, basemap = "Stamen.Toner", ...) {
  check_4_leaflet()
  petiole(input, bounds = sp_bounds(input), basemap, ...)
}

#' @export
map_leaf.SpatialLines <- function(input, lat = NULL, lon = NULL, basemap = "Stamen.Toner",  ...){
  check_4_leaflet()
  petiole(input, bounds = sp_bounds(input), basemap, ...)
}

#' @export
map_leaf.SpatialLinesDataFrame <- function(input, lat = NULL, lon = NULL, basemap = "Stamen.Toner", ...) {
  check_4_leaflet()
  petiole(input, bounds = sp_bounds(input), basemap, ...)
}

#' @export
map_leaf.SpatialGrid <- function(input, lat = NULL, lon = NULL, basemap = "Stamen.Toner", ...) {
  check_4_leaflet()
  petiole(input, bounds = sp_bounds(input), basemap, ...)
}

#' @export
map_leaf.SpatialGridDataFrame <- function(input, lat = NULL, lon = NULL, basemap = "Stamen.Toner", ...) {
  check_4_leaflet()
  petiole(input, bounds = sp_bounds(input), basemap, ...)
}

#' @export
map_leaf.SpatialPixels <- function(input, lat = NULL, lon = NULL, basemap = "Stamen.Toner", ...) {
  check_4_leaflet()
  petiole(input, bounds = sp_bounds(input), basemap, ...)
}

#' @export
map_leaf.SpatialPixelsDataFrame <- function(input, lat = NULL, lon = NULL, basemap = "Stamen.Toner", ...) {
  check_4_leaflet()
  petiole(input, bounds = sp_bounds(input), basemap, ...)
}

# spatial classes methods from rgeos package --------------------------
#' @export
map_leaf.SpatialRings <- function(input, lat = NULL, lon = NULL, basemap = "Stamen.Toner", ...) {
  check_4_leaflet()
  petiole(input, bounds = sp_bounds(input), basemap, ...)
}

#' @export
map_leaf.SpatialRingsDataFrame <- function(input, lat = NULL, lon = NULL, basemap = "Stamen.Toner", ...) {
  check_4_leaflet()
  petiole(input, bounds = sp_bounds(input), basemap, ...)
}

# R classes: numeric, data.frame, list ------------------------
# map_leaf.numeric <- function(input, basemap = "Stamen.Toner", ...) {
#   check_4_leaflet()
#   petiole(input, basemap, ...)
# }

#' @export
map_leaf.data.frame <- function(input, lat = NULL, lon = NULL, basemap = "Stamen.Toner", ...) {
  check_4_leaflet()
  petiole(input, bounds = df_bounds(input, lat, lon), basemap, ...)
}

#' @export
map_leaf.list <- function(input, lat = NULL, lon = NULL, basemap = "Stamen.Toner", ...) {
  check_4_leaflet()
  if (is.named(input)) {
    input <- rbind_fill(lapply(input, data.frame, stringsAsFactors = FALSE))
  } else {
    input <- rbind_fill(lapply(input, function(z) {
      data.frame(as.list(setNames(z, c('lng', 'lat'))), stringsAsFactors = FALSE) 
    }))
  }
  petiole(input, bounds = df_bounds(input, lat, lon), basemap, ...)
}

# Other methods: location, json, geo_list ------------------------
#' @export
map_leaf.location <- function(input, lat = NULL, lon = NULL, basemap = "Stamen.Toner", ...) {
  check_4_leaflet()
  input <- as.json(jsonlite::fromJSON(input, FALSE))
  petiole(input, bounds = geojson_bounds(input), basemap = basemap, ...)
}

#' @export
map_leaf.json <- function(input, lat = NULL, lon = NULL, basemap = "Stamen.Toner", ...) {
  check_4_leaflet()
  petiole(input, bounds = geojson_bounds(input), basemap, ...)
}

#' @export
map_leaf.character <- function(input, lat = NULL, lon = NULL, basemap = "Stamen.Toner", ...) {
  check_4_leaflet()
  petiole(input, bounds = geojson_bounds(input), basemap, ...)
}

#' @export
map_leaf.geo_list <- function(input, lat = NULL, lon = NULL, basemap = "Stamen.Toner", ...) {
  check_4_leaflet()
  input <- as.json(input)
  petiole(input, bounds = geojson_bounds(input), basemap, ...)
}

# Helper functions ------------------------
petiole <- function(x, bounds = NULL, basemap, ...) {
  ll <- leaflet::leaflet()
  ll <- leaflet::addProviderTiles(ll, basemap)
  ll <- leaflet::fitBounds(ll, lng1 = bounds[1], lat1 = bounds[2],
                  lng2 = bounds[3], lat2 = bounds[4])
  rachis(x, ll, ...)
}

# rachis ------------------------
rachis <- function(x, leaflet_obj, ...) {
  UseMethod("rachis")
}

rachis.SpatialPoints <- function(x, leaflet_obj, ...) {
  leaflet::addMarkers(leaflet_obj, data = x, ...)
}

rachis.SpatialPointsDataFrame <- function(x, leaflet_obj, ...) {
  leaflet::addMarkers(leaflet_obj, data = x, ...)
}

rachis.SpatialPolygons <- function(x, leaflet_obj, ...) {
  leaflet::addPolygons(leaflet_obj, data = x, ...)
}

rachis.SpatialPolygonsDataFrame <- function(x, leaflet_obj, ...) {
  leaflet::addPolygons(leaflet_obj, data = x, ...)
}

rachis.SpatialLines <- function(x, leaflet_obj, ...) {
  leaflet::addPolylines(leaflet_obj, data = x, ...)
}

rachis.SpatialLinesDataFrame <- function(x, leaflet_obj, ...) {
  leaflet::addPolylines(leaflet_obj, data = x, ...)
}

rachis.SpatialGrid <- function(x, leaflet_obj, ...) {
  leaflet::addMarkers(leaflet_obj, data = as(x, "SpatialPoints"), ...)
}

rachis.SpatialGridDataFrame <- function(x, leaflet_obj, ...) {
  leaflet::addMarkers(leaflet_obj, data = as(x, "SpatialPoints"), ...)
}

rachis.SpatialPixels <- function(x, leaflet_obj, ...) {
  leaflet::addMarkers(leaflet_obj, data = as(x, "SpatialPoints"), ...)
}

rachis.SpatialPixelsDataFrame <- function(x, leaflet_obj, ...) {
  leaflet::addMarkers(leaflet_obj, data = as(x, "SpatialPoints"), ...)
}

rachis.SpatialRings <- function(x, leaflet_obj, ...) {
  leaflet::addPolygons(leaflet_obj, data = as(x, "SpatialPolygonsDataFrame"), ...)
}

rachis.SpatialRingsDataFrame <- function(x, leaflet_obj, ...) {
  leaflet::addPolygons(leaflet_obj, data = as(x, "SpatialPolygonsDataFrame"), ...)
}

rachis.data.frame <- function(x, leaflet_obj, ...) {
  leaflet::addMarkers(leaflet_obj, data = x, ...)
}

# rachis.numeric <- function(x, leaflet_obj, ...) {
#   leaflet::addMarkers(leaflet_obj, lng = x[1], lat = x[2], ...)
# }

rachis.json <- function(x, leaflet_obj, ...) {
  leaflet::addGeoJSON(leaflet_obj, geojson = x, ...)
}

rachis.character <- function(x, leaflet_obj, ...) {
  leaflet::addGeoJSON(leaflet_obj, geojson = x, ...)
}

rachis.geo_list <- function(x, leaflet_obj, ...) {
  leaflet::addGeoJSON(leaflet_obj, geojson = x, ...)
}

# check that leaflet is installed
check_4_leaflet <- function() {
  if (!requireNamespace("leaflet", quietly = TRUE)) {
    stop("Please install leaflet", call. = FALSE)
  }
}

# get bounds ------------------
sp_bounds <- function(x) {
  box <- x@bbox
  c(as.numeric(box[, "min"]),
    as.numeric(box[, "max"]))
}

df_bounds <- function(x, lat = NULL, lon = NULL) {
  nms <- guess_latlon(names(x), lat, lon)
  c(min(x[nms$lon]), min(x[nms$lat]), max(x[nms$lon]), max(x[nms$lat]))
}

geojson_bounds <- function(x) {
  ext$eval(sprintf("var out = extent(%s);", jsonlite::minify(x)))
  b <- ext$get("out")
  if (b[1] == b[3] || b[2] == b[4]) {
    unlist(Map("+", b, c(-1, -1, 1, 1)))
  } else {
    b
  }
}
