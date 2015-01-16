#' Publish an interactive map as a GitHub gist
#' 
#' @export
#' @importFrom gistr gist_create
#' 
#' @param input Input object
#' @param lat Name of latitude variable
#' @param lon Name of longitude variable
#' @param polygon (logical) Are polygons in the object
#' @param object One of FeatureCollection or GeometryCollection
#' @param file File name to use to put up as the gist file
#' @param description Description for the Github gist, or leave to default (=no description)
#' @param public (logical) Want gist to be public or not? Default: TRUE
#' @param browse If TRUE (default) the map opens in your default browser.
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
#' @examples \donttest{
#' library('maps')
#' data(us.cities)
#' file <- "myfile.geojson"
#' geojson_write(us.cities[1:2,], lat='lat', lon='long', file = file)
#' map_gist(file=as.location(file))
#' 
#' # From SpatialPoints class
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
#' library('sp')
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
#' library("maps")
#' data(us.cities)
#' map_gist(us.cities)
#' 
#' ## From a list
#' mylist <- list(list(lat=30, long=120, marker="red"),
#'                list(lat=30, long=130, marker="blue"))
#' map_gist(mylist, lat="lat", lon="long")
#' 
#' # From a numeric vector of length 2 to a point
#' ## not working right now
#' ### vec <- c(32.45,-99.74)
#' ### map_gist(vec)
#' 
#' 
#' ## Use the cartographer package to make maps locally
#' library("cartographer")
#' 
#' # From SpatialPolygons class
#' library('sp')
#' poly1 <- Polygons(list(Polygon(cbind(c(-100,-90,-85,-100),
#'    c(40,50,45,40)))), "1")
#' poly2 <- Polygons(list(Polygon(cbind(c(-90,-80,-75,-90),
#'    c(30,40,35,30)))), "2")
#' sp_poly <- SpatialPolygons(list(poly1, poly2), 1:2)
#' cartographer() %>% 
#'  tile_layer() %>% 
#'  geojson_layer(data = geojson_json(sp_poly))
#'  
#' # From SpatialPolygonsDataFrame class
#' sp_polydf <- as(sp_poly, "SpatialPolygonsDataFrame")
#' cartographer() %>% 
#'  tile_layer() %>% 
#'  geojson_layer(data = geojson_json(sp_polydf))
#' 
#' # From a file
#' land <- system.file("extdata", "land.geojson", package = "cartographer")
#' cartographer() %>% 
#'  geojson_layer(file = land, label = "land")
#' 
#' # Historical usa boundaries
#' library("USAboundaries")
#' us_sp <- us_boundaries(as.Date("1800-01-01"))
#' cartographer(region = "United States") %>% 
#'  tile_layer() %>% 
#'  geojson_layer(data = geojson_json(us_sp), label = "US 1800", clickable = TRUE)
#' }

map_gist <- function(...) UseMethod("map_gist")

#' @export
#' @rdname map_gist
map_gist.location <- function(file, description = "", public = TRUE, browse = TRUE, ...){
  gist_create(files = file[[1]],  description = description, public = public, browse = browse, ...)
}

#' @export
#' @rdname map_gist
map_gist.SpatialPointsDataFrame <- function(input, file="myfile.geojson", description = "", public = TRUE, browse = TRUE, ...){
  gc(input, file, description, public, browse, ...)
}

#' @export
#' @rdname map_gist
map_gist.SpatialPoints <- function(input, file="myfile.geojson", description = "", public = TRUE, browse = TRUE, ...){
  dat <- SpatialPointsDataFrame(input, data.frame(dat=1:NROW(input@coords)))
  gc(dat, file, description, public, browse, ...)
}

#' @export
#' @rdname map_gist
map_gist.SpatialPolygons <- function(input, file="myfile.geojson", description = "", public = TRUE, browse = TRUE, ...){
  gc(input, file, description, public, browse, ...)
}

#' @export
#' @rdname map_gist
map_gist.SpatialPolygonsDataFrame <- function(input, file="myfile.geojson", description = "", public = TRUE, browse = TRUE, ...){
  gc(input, file, description, public, browse, ...)
}

#' @export
#' @rdname map_gist
map_gist.SpatialLines <- function(input, file="myfile.geojson", description = "", public = TRUE, browse = TRUE, ...){
  gc(input, file, description, public, browse, ...)
}

#' @export
#' @rdname map_gist
map_gist.SpatialLinesDataFrame <- function(input, file="myfile.geojson", description = "", public = TRUE, browse = TRUE, ...){
  gc(input, file, description, public, browse, ...)
}

#' @export
#' @rdname map_gist
map_gist.SpatialGrid <- function(input, file="myfile.geojson", description = "", public = TRUE, browse = TRUE, ...){
  gc(input, file, description, public, browse, ...)
}

#' @export
#' @rdname map_gist
map_gist.SpatialGridDataFrame <- function(input, file="myfile.geojson", description = "", public = TRUE, browse = TRUE, ...){
  gc(input, file, description, public, browse, ...)
}

#' @export
#' @rdname map_gist
map_gist.numeric <- function(input, polygon = NULL, file="myfile.geojson", description = "", public = TRUE, browse = TRUE, ...){
  input <- as.geo_list(num_to_geo_list(input, polygon), "numeric")
  gc(input, file, description, public, browse, ...)
}

#' @export
#' @rdname map_gist
map_gist.data.frame <- function(input, lat = "lat", lon = "long", polygon=NULL, 
  object = "FeatureCollection", file="myfile.geojson", description = "", 
  public = TRUE, browse = TRUE, ...)
{
  input <- as.geo_list(df_to_geo_list(input, lat, lon, polygon, object, unnamed=TRUE), "data.frame")
  gc(input, file, description, public, browse, ...)
}

#' @export
#' @rdname map_gist
map_gist.list <- function(input, lat = "lat", lon = "long", polygon=NULL, 
  object = "FeatureCollection", file="myfile.geojson", description = "", 
  public = TRUE, browse = TRUE, ...)
{
  input <- as.geo_list(list_to_geo_list(input, lat, lon, polygon, object), "list")
  gc(input, file, description, public, browse, ...)
}

gc <- function(input, file, description, public, browse, ...){
  gist_create(files = geojson_write(input, file=file), 
              description = description,
              public = public,
              browse = browse, ...)
}


# x <- vec
# x <- data.frame(t(x))
# x <- setNames(x, c(lat, lon))
# out <- df_to_SpatialPointsDataFrame(x, lat, lon)
# SpatialPixelsDataFrame(out, data.frame(dat=1:NROW(out)))
# geojson_write(out)
