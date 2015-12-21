#' Publish an interactive map as a GitHub gist
#'
#' @export
#'
#' @param input Input object
#' @param lat Name of latitude variable
#' @param lon Name of longitude variable
#' @param geometry (character) Are polygons in the object
#' @param type (character) One of FeatureCollection or GeometryCollection
#' @param group (character) A grouping variable to perform grouping for polygons - doesn't
#' apply for points
#' @param file File name to use to put up as the gist file
#' @param description Description for the Github gist, or leave to default (=no description)
#' @param public (logical) Want gist to be public or not? Default: TRUE
#' @param browse If TRUE (default) thef map opens in your default browser.
#' @param ... Further arguments passed on to \code{\link[httr]{POST}}
#'
#' @description There are two ways to authorize to work with your GitHub account:
#'
#' \itemize{
#'  \item PAT - Generate a personal access token (PAT) at
#'  \url{https://help.github.com/articles/creating-an-access-token-for-command-line-use} and
#'  record it in the GITHUB_PAT envar in your \code{.Renviron} file.
#'  \item Interactive - Interactively login into your GitHub account and authorise with OAuth.
#' }
#'
#' Using the PAT method is recommended.
#'
#' Using the gist_auth() function you can authenticate seperately first, or if you're not
#' authenticated, this function will run internally with each functionn call. If you have a
#' PAT, that will be used, if not, OAuth will be used.
#'
#' @examples \dontrun{
#' # From file
#' file <- "myfile.geojson"
#' geojson_write(us_cities[1:20, ], lat='lat', lon='long', file = file)
#' map_gist(file=as.location(file))
#'
#' # From SpatialPoints class
#' library("sp")
#' x <- c(1,2,3,4,5)
#' y <- c(3,2,5,1,4)
#' s <- SpatialPoints(cbind(x,y))
#' map_gist(s)
#'
#' # from SpatialPointsDataFrame class
#' x <- c(1,2,3,4,5)
#' y <- c(3,2,5,1,4)
#' s <- SpatialPointsDataFrame(cbind(x,y), mtcars[1:5,])
#' map_gist(s)
#'
#' # from SpatialPolygons class
#' poly1 <- Polygons(list(Polygon(cbind(c(-100,-90,-85,-100),
#'    c(40,50,45,40)))), "1")
#' poly2 <- Polygons(list(Polygon(cbind(c(-90,-80,-75,-90),
#'    c(30,40,35,30)))), "2")
#' sp_poly <- SpatialPolygons(list(poly1, poly2), 1:2)
#' map_gist(sp_poly)
#'
#' # From SpatialPolygonsDataFrame class
#' sp_polydf <- as(sp_poly, "SpatialPolygonsDataFrame")
#' map_gist(sp_poly)
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
#' map_gist(sl1)
#'
#' # From SpatialLinesDataFrame class
#' dat <- data.frame(X = c("Blue", "Green"),
#'                  Y = c("Train", "Plane"),
#'                  Z = c("Road", "River"), row.names = c("a", "b"))
#' sldf <- SpatialLinesDataFrame(sl12, dat)
#' map_gist(sldf)
#'
#' # From SpatialGrid
#' x <- GridTopology(c(0,0), c(1,1), c(5,5))
#' y <- SpatialGrid(x)
#' map_gist(y)
#'
#' # From SpatialGridDataFrame
#' sgdim <- c(3,4)
#' sg <- SpatialGrid(GridTopology(rep(0,2), rep(10,2), sgdim))
#' sgdf <- SpatialGridDataFrame(sg, data.frame(val = 1:12))
#' map_gist(sgdf)
#'
#' # from data.frame
#' ## to points
#' map_gist(us_cities)
#'
#' ## to polygons
#' head(states)
#' map_gist(states[1:351, ], lat='lat', lon='long', geometry="polygon", group='group')
#'
#' ## From a list
#' mylist <- list(list(lat=30, long=120, marker="red"),
#'                list(lat=30, long=130, marker="blue"))
#' map_gist(mylist, lat="lat", lon="long")
#'
#' # From a numeric vector
#' ## of length 2 to a point
#' vec <- c(-99.74,32.45)
#' map_gist(vec)
#'
#' ## this requires numeric class input, so inputting a list will dispatch on the list method
#' poly <- c(c(-114.345703125,39.436192999314095),
#'           c(-114.345703125,43.45291889355468),
#'           c(-106.61132812499999,43.45291889355468),
#'           c(-106.61132812499999,39.436192999314095),
#'           c(-114.345703125,39.436192999314095))
#' map_gist(poly, geometry = "polygon")
#'
#' # From a json object
#' (x <- geojson_json(c(-99.74,32.45)))
#' map_gist(x)
#' ## another example
#' map_gist(geojson_json(us_cities[1:10,], lat='lat', lon='long'))
#'
#' # From a geo_list object
#' (res <- geojson_list(us_cities[1:2,], lat='lat', lon='long'))
#' map_gist(res)
#'
#' # From SpatialPixels
#' pixels <- suppressWarnings(SpatialPixels(SpatialPoints(us_cities[c("long", "lat")])))
#' summary(pixels)
#' map_gist(pixels)
#'
#' # From SpatialPixelsDataFrame
#' pixelsdf <- suppressWarnings(
#'  SpatialPixelsDataFrame(points = canada_cities[c("long", "lat")], data = canada_cities)
#' )
#' map_gist(pixelsdf)
#'
#' # From SpatialRings
#' library("rgeos")
#' r1 <- Ring(cbind(x=c(1,1,2,2,1), y=c(1,2,2,1,1)), ID="1")
#' r2 <- Ring(cbind(x=c(1,1,2,2,1), y=c(1,2,2,1,1)), ID="2")
#' r1r2 <- SpatialRings(list(r1, r2))
#' map_gist(r1r2)
#'
#' # From SpatialRingsDataFrame
#' dat <- data.frame(id = c(1,2), value = 3:4)
#' r1r2df <- SpatialRingsDataFrame(r1r2, data = dat)
#' map_gist(r1r2df)
#' }

map_gist <- function(input, lat = "lat", lon = "long", geometry = "point",
                     group = NULL, type = "FeatureCollection",
                     file = "myfile.geojson", description = "",
                     public = TRUE, browse = TRUE, ...) {

  UseMethod("map_gist")
}

# Spatial classes methods from sp package ----------------------
#' @export
map_gist.SpatialPoints <- function(input, lat = "lat", lon = "long", geometry = "point",
                                   group = NULL, type = "FeatureCollection", file = "myfile.geojson",
                                   description = "", public = TRUE, browse = TRUE, ...){
  check4gistr()
  dat <- SpatialPointsDataFrame(input, data.frame(dat = 1:NROW(input@coords)))
  gistc(dat, file, description, public, browse, ...)
}


#' @export
map_gist.SpatialPointsDataFrame <- function(input, lat = "lat", lon = "long", geometry = "point",
                                            group = NULL, type = "FeatureCollection",
                                            file = "myfile.geojson", description = "",
                                            public = TRUE, browse = TRUE, ...) {
  check4gistr()
  gistc(input, file, description, public, browse, ...)
}

#' @export
map_gist.SpatialPolygons <- function(input, lat = "lat", lon = "long", geometry = "point",
                                     group = NULL, type = "FeatureCollection", file = "myfile.geojson",
                                     description = "", public = TRUE, browse = TRUE, ...) {
  check4gistr()
  gistc(input, file, description, public, browse, ...)
}

#' @export
map_gist.SpatialPolygonsDataFrame <- function(input, lat = "lat", lon = "long", geometry = "point",
                                              group = NULL, type = "FeatureCollection",
                                              file = "myfile.geojson", description = "",
                                              public = TRUE, browse = TRUE, ...) {
  check4gistr()
  gistc(input, file, description, public, browse, ...)
}

#' @export
map_gist.SpatialLines <- function(input, lat = "lat", lon = "long", geometry = "point",
                                  group = NULL, type = "FeatureCollection", file = "myfile.geojson",
                                  description = "", public = TRUE, browse = TRUE, ...){
  check4gistr()
  gistc(input, file, description, public, browse, ...)
}

#' @export
map_gist.SpatialLinesDataFrame <- function(input, lat = "lat", lon = "long", geometry = "point",
                                           group = NULL, type = "FeatureCollection",
                                           file = "myfile.geojson", description = "",
                                           public = TRUE, browse = TRUE, ...) {
  check4gistr()
  gistc(input, file, description, public, browse, ...)
}

#' @export
map_gist.SpatialGrid <- function(input, lat = "lat", lon = "long", geometry = "point",
                                 group = NULL, type = "FeatureCollection",
                                 file = "myfile.geojson", description = "",
                                 public = TRUE, browse = TRUE, ...) {
  check4gistr()
  gistc(input, file, description, public, browse, ...)
}

#' @export
map_gist.SpatialGridDataFrame <- function(input, lat = "lat", lon = "long", geometry = "point",
                                          group = NULL, type = "FeatureCollection",
                                          file = "myfile.geojson", description = "",
                                          public = TRUE, browse = TRUE, ...) {
  check4gistr()
  gistc(input, file, description, public, browse, ...)
}

#' @export
map_gist.SpatialPixels <- function(input, lat = "lat", lon = "long", geometry = "point",
                                   group = NULL, type = "FeatureCollection",
                                   file = "myfile.geojson", description = "",
                                   public = TRUE, browse = TRUE, ...) {
  check4gistr()
  gistc(input, file, description, public, browse, ...)
}

#' @export
map_gist.SpatialPixelsDataFrame <- function(input, lat = "lat", lon = "long", geometry = "point",
                                            group = NULL, type = "FeatureCollection",
                                            file = "myfile.geojson", description = "",
                                            public = TRUE, browse = TRUE, ...) {
  check4gistr()
  gistc(input, file, description, public, browse, ...)
}

# spatial classes methods from rgeos package --------------------------
#' @export
map_gist.SpatialRings <- function(input, lat = "lat", lon = "long", geometry = "point",
                                  group = NULL, type = "FeatureCollection",
                                  file = "myfile.geojson", description = "",
                                  public = TRUE, browse = TRUE, ...) {
  check4gistr()
  gistc(input, file, description, public, browse, ...)
}

#' @export
map_gist.SpatialRingsDataFrame <- function(input, lat = "lat", lon = "long", geometry = "point",
                                           group = NULL, type = "FeatureCollection",
                                           file = "myfile.geojson", description = "",
                                           public = TRUE, browse = TRUE, ...) {
  check4gistr()
  gistc(input, file, description, public, browse, ...)
}

# R classes: numeric, data.frame, list ------------------------
#' @export
map_gist.numeric <- function(input, lat = "lat", lon = "long", geometry = "point", group = NULL,
                             type = "FeatureCollection", file = "myfile.geojson", description = "",
                             public = TRUE, browse = TRUE, ...) {
  check4gistr()
  input <- as.geo_list(num_to_geo_list(input, geometry), "numeric")
  gistc(input, file, description, public, browse, ...)
}

#' @export
map_gist.data.frame <- function(input, lat = "lat", lon = "long", geometry = "point", group = NULL,
                                type = "FeatureCollection", file = "myfile.geojson", description = "",
                                public = TRUE, browse = TRUE, ...) {
  check4gistr()
  input <- as.geo_list(df_to_geo_list(input, lat, lon, geometry, type, group), "data.frame")
  gistc(input, file, description, public, browse, ...)
}

#' @export
map_gist.list <- function(input, lat = "lat", lon = "long", geometry = "point", group = NULL,
                          type = "FeatureCollection", file = "myfile.geojson", description = "",
                          public = TRUE, browse = TRUE, ...) {
  check4gistr()
  input <- as.geo_list(list_to_geo_list(input, lat, lon, geometry, type, group = group), "list")
  gistc(input, file, description, public, browse, ...)
}

# Other methods: location, json, geo_list ------------------------
#' @export
map_gist.location <- function(input, lat = "lat", lon = "long", geometry = "point",
                              group = NULL, type = "FeatureCollection", file = "myfile.geojson",
                              description = "", public = TRUE, browse = TRUE, ...) {
  check4gistr()
  gistr::gist_create(files = file[[1]],  description = description, public = public, browse = browse, ...)
}

#' @export
map_gist.json <- function(input, lat = "lat", lon = "long", geometry = "point",
                              group = NULL, type = "FeatureCollection", file = "myfile.geojson",
                              description = "", public = TRUE, browse = TRUE, ...) {
  check4gistr()
  gistc(input, file, description, public, browse, ...)
}

#' @export
map_gist.geo_list <- function(input, lat = "lat", lon = "long", geometry = "point",
                          group = NULL, type = "FeatureCollection", file = "myfile.geojson",
                          description = "", public = TRUE, browse = TRUE, ...) {
  check4gistr()
  gistc(input, file, description, public, browse, ...)
}

# Helper functions ------------------------
gistc <- function(input, file, description, public, browse, ...){
  gistr::gist_create(files = geojson_write(input, file = file)$path,
              description = description,
              public = public,
              browse = browse, ...)
}

check4gistr <- function() {
  if (!requireNamespace("gistr", quietly = TRUE)) {
    stop("Please install gistr", call. = FALSE)
  }
}
