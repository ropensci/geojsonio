context("geojson_write")

test_that("precision argument works with polygons", {
  skip_on_travis()
  skip_on_cran()

  poly <- list(c(-114.345703125,39.436192999314095),
               c(-114.345703125,43.45291889355468))
  a <- suppressMessages(geojson_write(poly, geometry = "polygon"))
  expect_is(a, "geojson")
  a_txt <- gsub("\\s+", " ", paste0(readLines("myfile.geojson"), collapse = ""))
  expect_equal(a_txt, "{\"type\": \"FeatureCollection\", \"features\": [{ \"type\": \"Feature\", \"id\": 0, \"properties\": { \"dummy\": 0.000000 }, \"geometry\": { \"type\": \"Polygon\", \"coordinates\": [ [ [ -114.345703125, 39.436192999314095 ], [ -114.345703125, 43.452918893554681 ], [ -114.345703125, 39.436192999314095 ] ] ] } }]}")

  b <- suppressMessages(geojson_write(poly, geometry = "polygon", precision = 2))
  expect_is(b, "geojson")
  b_txt <- gsub("\\s+", " ", paste0(readLines("myfile.geojson"), collapse = ""))
  expect_equal(b_txt, "{\"type\": \"FeatureCollection\", \"features\": [{ \"type\": \"Feature\", \"id\": 0, \"properties\": { \"dummy\": 0.000000 }, \"geometry\": { \"type\": \"Polygon\", \"coordinates\": [ [ [ -114.35, 39.44 ], [ -114.35, 43.45 ], [ -114.35, 39.44 ] ] ] } }]}")
})

test_that("precision argument works with points", {
  skip_on_travis()
  skip_on_cran()

  c <- suppressMessages(geojson_write(us_cities[1:2,], lat = 'lat', lon = 'long', precision = 2))
  expect_is(c, "geojson")
  c_txt <- gsub("\\s+", " ", paste0(readLines("myfile.geojson"), collapse = ""))
  expect_equal(c_txt, "{\"type\": \"FeatureCollection\", \"features\": [{ \"type\": \"Feature\", \"id\": 1, \"properties\": { \"name\": \"Abilene TX\", \"country.etc\": \"TX\", \"pop\": 113888, \"lat\": 32.450000, \"long\": -99.740000, \"capital\": 0 }, \"geometry\": { \"type\": \"Point\", \"coordinates\": [ -99.74, 32.45 ] } },{ \"type\": \"Feature\", \"id\": 2, \"properties\": { \"name\": \"Akron OH\", \"country.etc\": \"OH\", \"pop\": 206634, \"lat\": 41.080000, \"long\": -81.520000, \"capital\": 0 }, \"geometry\": { \"type\": \"Point\", \"coordinates\": [ -81.52, 41.08 ] } }]}")

  d <- suppressMessages(geojson_write(us_cities[1:2,], lat = 'lat', lon = 'long', precision = 1))
  expect_is(d, "geojson")
  d_txt <- gsub("\\s+", " ", paste0(readLines("myfile.geojson"), collapse = ""))
  expect_equal(d_txt, "{\"type\": \"FeatureCollection\", \"features\": [{ \"type\": \"Feature\", \"id\": 1, \"properties\": { \"name\": \"Abilene TX\", \"country.etc\": \"TX\", \"pop\": 113888, \"lat\": 32.450000, \"long\": -99.740000, \"capital\": 0 }, \"geometry\": { \"type\": \"Point\", \"coordinates\": [ -99.7, 32.5 ] } },{ \"type\": \"Feature\", \"id\": 2, \"properties\": { \"name\": \"Akron OH\", \"country.etc\": \"OH\", \"pop\": 206634, \"lat\": 41.080000, \"long\": -81.520000, \"capital\": 0 }, \"geometry\": { \"type\": \"Point\", \"coordinates\": [ -81.5, 41.1 ] } }]}")
})

test_that("precision argument works with sp objects", {
  skip_on_travis()
  skip_on_cran()

  library('sp')
  poly1 <- Polygons(list(Polygon(cbind(c(-100.111,-90.111,-85.111,-100.111),
                                       c(40.111,50.111,45.111,40.111)))), "1")
  poly2 <- Polygons(list(Polygon(cbind(c(-90.111,-80.111,-75.111,-90.111),
                                       c(30.111,40.111,35.111,30.111)))), "2")
  sp_poly <- SpatialPolygons(list(poly1, poly2), 1:2)
  e <- suppressMessages(geojson_write(sp_poly))
  expect_is(e, "geojson")
  e_txt <- gsub("\\s+", " ", paste0(readLines("myfile.geojson"), collapse = ""))
  expect_equal(e_txt, "{\"type\": \"FeatureCollection\", \"features\": [{ \"type\": \"Feature\", \"id\": 1, \"properties\": { \"dummy\": 0.000000 }, \"geometry\": { \"type\": \"Polygon\", \"coordinates\": [ [ [ -100.111, 40.111 ], [ -90.111, 50.111 ], [ -85.111, 45.111 ], [ -100.111, 40.111 ] ] ] } },{ \"type\": \"Feature\", \"id\": 2, \"properties\": { \"dummy\": 0.000000 }, \"geometry\": { \"type\": \"Polygon\", \"coordinates\": [ [ [ -90.111, 30.111 ], [ -80.111, 40.111 ], [ -75.111, 35.111 ], [ -90.111, 30.111 ] ] ] } }]}")

  f <- suppressMessages(geojson_write(sp_poly, precision = 2))
  expect_is(f, "geojson")
  f_txt <- gsub("\\s+", " ", paste0(readLines("myfile.geojson"), collapse = ""))
  expect_equal(f_txt, "{\"type\": \"FeatureCollection\", \"features\": [{ \"type\": \"Feature\", \"id\": 1, \"properties\": { \"dummy\": 0.000000 }, \"geometry\": { \"type\": \"Polygon\", \"coordinates\": [ [ [ -100.11, 40.11 ], [ -90.11, 50.11 ], [ -85.11, 45.11 ], [ -100.11, 40.11 ] ] ] } },{ \"type\": \"Feature\", \"id\": 2, \"properties\": { \"dummy\": 0.000000 }, \"geometry\": { \"type\": \"Polygon\", \"coordinates\": [ [ [ -90.11, 30.11 ], [ -80.11, 40.11 ], [ -75.11, 35.11 ], [ -90.11, 30.11 ] ] ] } }]}")
})
