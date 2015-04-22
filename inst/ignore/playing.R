# geo$eval("geojson")
# geo$eval("
# var data = [
#   { name: 'Location A', category: 'Store', street: 'Market', lat: 39.984, lng: -75.343 },
#   { name: 'Location B', category: 'House', street: 'Broad', lat: 39.284, lng: -75.833 },
#   { name: 'Location C', category: 'Office', street: 'South', lat: 39.123, lng: -74.534 }
# ];
# ")
# geo$eval("var stuff = geojson.parse(data, {Point: ['lat', 'lng']});")
# geo$get("stuff", simplifyVector = FALSE)

foo <- function(x) {
  UseMethod("foo")
}

foo.SpatialPoints <- function(x) {
  df <- data.frame(x@coords, stringsAsFactors = FALSE)
  nms <- guess_latlon(names(df))
  nms_use <- c(nms[[2]], nms[[1]])
  # df <- setNames(df, names(nms))
  dat <- jsonlite::toJSON(df)
  geo$eval(sprintf("var stuff = geojson.parse(%s, {Point: %s});", dat, toJSON(nms_use)))
  geo$get("stuff", simplifyDataFrame = FALSE, simplifyMatrix = FALSE)
}

foo.SpatialPointsDataFrame <- function(x) {
  df <- data.frame(x@coords, stringsAsFactors = FALSE)
  nms <- guess_latlon(names(df))
  nms_use <- c(nms[[2]], nms[[1]])
  dat <- jsonlite::toJSON(df)
  geo$eval(sprintf("var stuff = geojson.parse(%s, {Point: %s});", dat, toJSON(nms_use)))
  geo$get("stuff", simplifyDataFrame = FALSE, simplifyMatrix = FALSE)
}

foo.SpatialPolygons <- function(x) {
  polys <- lapply(x@polygons, function(w) { 
    list(polygon = lapply(w@Polygons, function(z) {
      z@coords
    }))
  })
  dat <- jsonlite::toJSON(polys)
  geo$eval(sprintf("var stuff = geojson.parse(%s, {'Polygon': 'polygon'});", dat))
  geo$get("stuff", simplifyDataFrame = FALSE, simplifyMatrix = FALSE)
}

foo.SpatialPolygonsDataFrame <- function(x) {
  polys <- lapply(x@polygons, function(w) { 
    tmp <- lapply(w@Polygons, function(z) z@coords)
    if (length(tmp) > 1) {
      multi <- list(MultiPolygon = tmp)
      c(multi, id = w@ID, getprop(w@ID, x))
    } else {
      single <- list(Polygon = tmp)
      c(single, id = w@ID, getprop(w@ID, x))
    }
  })
  dat <- jsonlite::toJSON(polys)
  geo$eval(sprintf("var stuff = geojson.parse(%s, {'Polygon': 'Polygon', 'MultiPolygon': 'MultiPolygon'});", dat))
  geo$get("stuff", simplifyDataFrame = FALSE, simplifyMatrix = FALSE)
}

foo.SpatialLines <- function(x) {
  lines <- lapply(x@lines, function(w) { 
    tmp <- lapply(w@Lines, function(z) z@coords)
    if (length(tmp) > 1) {
      multi <- list(MultiLineString = tmp)
      c(multi, id = w@ID)
    } else {
      list(LineString = tmp)
    }
  })
  dat <- jsonlite::toJSON(lines)
  geo$eval(sprintf("var stuff = geojson.parse(%s, {'LineString': 'LineString', 'MultiLineString': 'MultiLineString'});", dat))
  geo$get("stuff", simplifyDataFrame = FALSE, simplifyMatrix = FALSE)
}

foo.SpatialLinesDataFrame <- function(x) {
  lines <- lapply(x@lines, function(w) { 
    tmp <- lapply(w@Lines, function(z) z@coords)
    if (length(tmp) > 1) {
      multi <- list(MultiLineString = tmp)
      c(multi, id = w@ID, getprop(w@ID, x))
    } else {
      single <- list(LineString = tmp)
      c(single, id = w@ID, getprop(w@ID, x))
    }
  })
  dat <- jsonlite::toJSON(lines)
  geo$eval(sprintf("var stuff = geojson.parse(%s, {'LineString': 'LineString', 'MultiLineString': 'MultiLineString'});", dat))
  geo$get("stuff", simplifyDataFrame = FALSE, simplifyMatrix = FALSE)
}

getprop <- function(i, j) {
  as.list(j@data[row.names(j@data) %in% i, ])
}

# spatialpoints
library('sp')
x <- c(1,2,3,4,5)
y <- c(3,2,5,1,4)
s <- SpatialPoints(cbind(x,y))
proj4string(s) <- "+proj=longlat +datum=WGS84"
unclass(geojson_list(s))
foo(s)
system.time( replicate(1000, geojson_list(s)) )
system.time( replicate(1000, foo(s) ) )

# SpatialPointsDataFrame
coordinates(us_cities) <- ~long + lat
geojson_list(us_cities)
system.time( replicate(10, geojson_list(us_cities)) )
system.time( replicate(10, foo(us_cities) ) )
             
# SpatialPolygons
library('sp')
poly1 <- Polygons(list(Polygon(cbind(c(-100,-90,-85,-100),
   c(40,50,45,40)))), "a")
poly2 <- Polygons(list(Polygon(cbind(c(-90,-80,-75,-90),
   c(30,40,35,30)))), "b")
sp_poly <- SpatialPolygons(list(poly1, poly2), 1:2)
geojson_list(sp_poly)

# multipoly <- Polygons(list(
#   Polygon(cbind(c(-100,-90,-85,-100), c(40,50,45,40))),
#   Polygon(cbind(c(-90,-80,-75,-90), c(30,40,35,30)))
# ), "c")
# sp_multipoly <- SpatialPolygons(list(multipoly, poly1), 1:2)
file <- system.file("examples", "multipolygon_eg.geojson", package = "geojsonio")
sp_multipoly <- rgdal::readOGR(file, ogrListLayers(file)[1])
sp_multipoly@data <- data.frame(x = "hello", row.names = row.names(sp_multipoly))
plot(sp_multipoly)
geojson_list(sp_multipoly)
foo(sp_multipoly)

system.time( replicate(500, geojson_list(sp_poly)) )
system.time( replicate(500, foo(sp_poly) ) )

# SpatialPolygonsDataFrame
# sp_polydf <- as(sp_poly, "SpatialPolygonsDataFrame")
df <- data.frame(x = c("bears", "tigers"), y = c("cities", "towns"), row.names = row.names(sp_poly))
sp_polydf <- SpatialPolygonsDataFrame(sp_poly, df)
geojson_list(sp_polydf)
foo(sp_polydf)

# SpatialLines
c1 <- cbind(c(1, 2, 3), c(3, 2, 2))
c2 <- cbind(c1[, 1] + .05, c1[, 2] + .05)
c3 <- cbind(c(1, 2, 3), c(1, 1.5, 1))
L1 <- Line(c1)
L2 <- Line(c2)
L3 <- Line(c3)
Ls1 <- Lines(list(L1), ID = "a")
Ls2 <- Lines(list(L2, L3), ID = "b")
sl1 <- SpatialLines(list(Ls1))
sl12 <- SpatialLines(list(Ls1, Ls2))
geojson_list(sl12)

foo(sl1)
foo(sl12)
foo(sl1) %>% view

# SpatialLinesDataFrame
dat <- data.frame(X = c("Blue", "Green"),
                 Y = c("Train", "Plane"),
                 Z = c("Road", "River"), row.names = c("a", "b"))
sldf <- SpatialLinesDataFrame(sl12, dat)
geojson_list(sldf)

foo(sldf)
foo(sldf) %>% view

system.time( replicate(500, geojson_list(sldf)) )
system.time( replicate(500, foo(sldf) ) )
