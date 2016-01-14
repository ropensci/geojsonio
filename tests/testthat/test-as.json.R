context("as.json")

test_that("as.json works with geo_list class inputs", {
  # From a numeric vector of length 2, making a point type
  a <- geojson_list(c(-99.74, 32.45))
  expect_is(as.json(a), "json")
  expect_is(unclass(a), "list")
  expect_equal(
    unclass(as.json(a)),
    "{\"type\":\"FeatureCollection\",\"features\":[{\"type\":\"Feature\",\"geometry\":{\"type\":\"Point\",\"coordinates\":[-99.74,32.45]},\"properties\":{}}]}"
  )
  
  b <- geojson_list(c(-99.74, 32.45), type = "GeometryCollection")
  expect_equal(
    unclass(as.json(b)),
    "{\"type\":\"GeometryCollection\",\"geometries\":[{\"type\":\"Point\",\"coordinates\":[-99.74,32.45]}]}"
  )
})

test_that("as.json works with geojson class inputs", {
  tf1 <- tempfile(fileext = ".geojson")
  cc <- suppressMessages(geojson_write(us_cities[1:2,], lat='lat', lon='long', file = tf1))
  expect_is(cc, "geojson")
  expect_is(unclass(cc), "list")
  expect_is(as.json(cc, verbose = FALSE), "json")
  expect_equal(
    unclass(as.json(cc, verbose = FALSE)),
    "{\"type\":\"FeatureCollection\",\"features\":[{\"type\":\"Feature\",\"geometry\":{\"type\":\"Point\",\"coordinates\":[-99.74,32.45]},\"properties\":{\"name\":\"Abilene TX\",\"country.etc\":\"TX\",\"pop\":\"113888\",\"capital\":\"0\",\"coords.x1\":\"-99.74\",\"coords.x2\":\"32.45\",\"optional\":\"TRUE\"}},{\"type\":\"Feature\",\"geometry\":{\"type\":\"Point\",\"coordinates\":[-81.52,41.08]},\"properties\":{\"name\":\"Akron OH\",\"country.etc\":\"OH\",\"pop\":\"206634\",\"capital\":\"0\",\"coords.x1\":\"-81.52\",\"coords.x2\":\"41.08\",\"optional\":\"TRUE\"}}]}"
  )
  
  tf11 <- tempfile(fileext = ".geojson")
  d <- suppressMessages(geojson_write(input=states, lat='lat', lon='long', geometry='group', group="group", file = tf11))
  expect_is(d, "geojson")
  expect_is(unclass(d), "list")
  expect_is(as.json(d, verbose = FALSE), "json")
  
  library('sp')
  poly1 <- Polygons(list(Polygon(cbind(c(-100,-90,-85,-100),
     c(40,50,45,40)))), "1")
  poly2 <- Polygons(list(Polygon(cbind(c(-90,-80,-75,-90),
     c(30,40,35,30)))), "2")
  sp_poly <- SpatialPolygons(list(poly1, poly2), 1:2)
  tf2 <- tempfile(fileext = ".geojson")
  e <- suppressMessages(geojson_write(sp_poly, file = tf2))
  expect_is(e, "geojson")
  expect_is(unclass(e), "list")
  expect_is(as.json(e, verbose = FALSE), "json")
  expect_equal(
    unclass(as.json(e, verbose = FALSE)),
    "{\"type\":\"FeatureCollection\",\"crs\":{\"type\":\"name\",\"properties\":{\"name\":\"urn:ogc:def:crs:OGC:1.3:CRS84\"}},\"features\":[{\"type\":\"Feature\",\"id\":1,\"properties\":{\"dummy\":0},\"geometry\":{\"type\":\"Polygon\",\"coordinates\":[[[-100,40],[-90,50],[-85,45],[-100,40]]]}},{\"type\":\"Feature\",\"id\":2,\"properties\":{\"dummy\":0},\"geometry\":{\"type\":\"Polygon\",\"coordinates\":[[[-90,30],[-80,40],[-75,35],[-90,30]]]}}]}"
  )
})

test_that("as.json works with file name inputs", {
  tf3 <- tempfile(fileext = ".geojson")
  ee <- suppressMessages(geojson_write(us_cities[1:2,], lat = 'lat', lon = 'long', file = tf3))
  expect_is(ee, "geojson")
  expect_is(unclass(ee), "list")
  expect_is(ee$path, "character")
  expect_is(as.json(ee$path, verbose = FALSE), "json")
  expect_equal_to_reference(
    unclass(as.json(ee, verbose = FALSE)), 
    "us_citites_two_row.rds"
  )
})
