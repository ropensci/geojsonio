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
  c <- suppressMessages(geojson_write(us_cities[1:2,], lat='lat', lon='long'))
  expect_is(c, "geojson")
  expect_is(unclass(c), "list")
  expect_is(as.json(c, verbose = FALSE), "json")
  expect_equal(
    unclass(as.json(c, verbose = FALSE)),
    "{\"type\":\"FeatureCollection\",\"features\":[{\"type\":\"Feature\",\"geometry\":{\"type\":\"Point\",\"coordinates\":[32.45,-99.74]},\"properties\":{\"name\":\"Abilene TX\",\"country.etc\":\"TX\",\"pop\":\"113888\",\"lat\":\"32.45\",\"long\":\"-99.74\",\"capital\":\"0\",\"optional\":\"TRUE\"}},{\"type\":\"Feature\",\"geometry\":{\"type\":\"Point\",\"coordinates\":[41.08,-81.52]},\"properties\":{\"name\":\"Akron OH\",\"country.etc\":\"OH\",\"pop\":\"206634\",\"lat\":\"41.08\",\"long\":\"-81.52\",\"capital\":\"0\",\"optional\":\"TRUE\"}}]}"
  )
  
  d <- suppressMessages(geojson_write(input=states, lat='lat', lon='long', geometry='group', group="group"))
  expect_is(d, "geojson")
  expect_is(unclass(d), "list")
  expect_is(as.json(d, verbose = FALSE), "json")
  expect_equal(
    unclass(as.json(d, verbose = FALSE)),
    "{\"type\":\"MultiPoint\",\"bbox\":[-124.681343078613,-67.0074157714844,25.1299285888672,49.3832321166992],\"coordinates\":[[-99.3725000862868,31.5053507944716]],\"properties\":{}}"
  )
  
  library('sp')
  poly1 <- Polygons(list(Polygon(cbind(c(-100,-90,-85,-100),
     c(40,50,45,40)))), "1")
  poly2 <- Polygons(list(Polygon(cbind(c(-90,-80,-75,-90),
     c(30,40,35,30)))), "2")
  sp_poly <- SpatialPolygons(list(poly1, poly2), 1:2)
  e <- suppressMessages(geojson_write(sp_poly))
  expect_is(e, "geojson")
  expect_is(unclass(e), "list")
  expect_is(as.json(e, verbose = FALSE), "json")
  expect_equal(
    unclass(as.json(e, verbose = FALSE)),
    "{\"type\":\"MultiPoint\",\"bbox\":[-100,-75,30,50],\"coordinates\":[[-91.6666666666667,45],[-81.6666666666667,35]],\"properties\":{}}"
  )
})

#### FIXME - add tests for character input, file names that is.
