geo$eval("geojson")
geo$eval("
var data = [
  { name: 'Location A', category: 'Store', street: 'Market', lat: 39.984, lng: -75.343 },
  { name: 'Location B', category: 'House', street: 'Broad', lat: 39.284, lng: -75.833 },
  { name: 'Location C', category: 'Office', street: 'South', lat: 39.123, lng: -74.534 }
];
")
geo$eval("var stuff = geojson.parse(data, {Point: ['lat', 'lng']});")
geo$get("stuff", simplifyVector = FALSE)

foo <- function(x) {
  UseMethod("foo")
}

foo.SpatialPointsDataFrame <- function(x) {
  df <- data.frame(x@coords, stringsAsFactors = FALSE)
  dat <- jsonlite::toJSON(df)
  geo$eval(sprintf("var stuff = geojson.parse(%s, {Point: ['lat', 'long']});", dat))
  geo$get("stuff", simplifyVector = FALSE)
}

foo.SpatialPolygons <- function(x) {
  polys <- lapply(x@polygons, function(w) { 
    list(polygon = lapply(w@Polygons, function(z) {
      z@coords
    }))
  })
  # polys <- setNames(polys, c("polygon","polygon"))
  dat <- jsonlite::toJSON(polys)
  # dat <- jsonlite::toJSON(list(list(polygon = polys[[1]]), list(polygon = polys[[2]])))
  geo$eval(sprintf("var stuff = geojson.parse(%s, {'Polygon': 'polygon'});", dat))
  # geo$eval(sprintf("var stuff = geojson.parse(%s, {'Polygon': 'polygon', 'Polygon': 'polygon'});", dat))
  geo$get("stuff", simplifyVector = FALSE)
}

library('sp')
x <- c(1,2,3,4,5)
y <- c(3,2,5,1,4)
s <- SpatialPoints(cbind(x,y))
proj4string(s) <- "+proj=longlat +datum=WGS84"
unclass(geojson_list(s))
foo(s)

coordinates(us_cities) <- ~long+lat
geojson_list(us_cities)

system.time( replicate(10, geojson_list(us_cities)) )
system.time( replicate(10, foo(us_cities) ) )
             

library('sp')
poly1 <- Polygons(list(Polygon(cbind(c(-100,-90,-85,-100),
   c(40,50,45,40)))), "1")
poly2 <- Polygons(list(Polygon(cbind(c(-90,-80,-75,-90),
   c(30,40,35,30)))), "2")
sp_poly <- SpatialPolygons(list(poly1, poly2), 1:2)
geojson_list(sp_poly)

system.time( replicate(100, geojson_list(sp_poly)) )
system.time( replicate(100, foo(sp_poly) ) )
