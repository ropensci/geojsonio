context("geojson_write")

test_that("precision argument works with polygons", {
  skip_on_travis()
  skip_on_cran()

  poly <- list(c(-114.345703125, 39.436192999314095),
               c(-114.345703125, 43.45291889355468),
               c(-114.345703125, 39.436192999314095))
  gwf1 <- tempfile(fileext = ".geojson")
  a <- suppressMessages(geojson_write(poly, geometry = "polygon", file = gwf1))
  expect_is(a, "geojson")
  a_txt <- gsub("\\s+", " ", paste0(readLines(gwf1), collapse = ""))
  expect_equal(a_txt, "{\"type\": \"FeatureCollection\", \"features\": [{ \"type\": \"Feature\", \"id\": 0, \"properties\": { \"dummy\": 0.000000 }, \"geometry\": { \"type\": \"Polygon\", \"coordinates\": [ [ [ -114.345703125, 39.436192999314095 ], [ -114.345703125, 43.452918893554681 ], [ -114.345703125, 39.436192999314095 ] ] ] } }]}")

  gwf2 <- tempfile(fileext = ".geojson")
  b <- suppressMessages(geojson_write(poly, geometry = "polygon", precision = 2, file = gwf2))
  expect_is(b, "geojson")
  b_txt <- gsub("\\s+", " ", paste0(readLines(gwf2), collapse = ""))
  expect_equal(b_txt, "{\"type\": \"FeatureCollection\", \"features\": [{ \"type\": \"Feature\", \"id\": 0, \"properties\": { \"dummy\": 0.000000 }, \"geometry\": { \"type\": \"Polygon\", \"coordinates\": [ [ [ -114.35, 39.44 ], [ -114.35, 43.45 ], [ -114.35, 39.44 ] ] ] } }]}")
})

test_that("precision argument works with points", {
  skip_on_travis()
  skip_on_cran()

  gwf3 <- tempfile(fileext = ".geojson")
  cc <- suppressMessages(geojson_write(us_cities[1:2,], lat = 'lat', lon = 'long', precision = 2, file = gwf3))
  expect_is(cc, "geojson")
  cc_txt <- gsub("\\s+", " ", paste0(readLines(gwf3), collapse = ""))
  expect_equal(cc_txt, "{\"type\": \"FeatureCollection\", \"features\": [{ \"type\": \"Feature\", \"id\": 1, \"properties\": { \"name\": \"Abilene TX\", \"country.etc\": \"TX\", \"pop\": 113888, \"lat\": 32.450000, \"long\": -99.740000, \"capital\": 0 }, \"geometry\": { \"type\": \"Point\", \"coordinates\": [ -99.74, 32.45 ] } },{ \"type\": \"Feature\", \"id\": 2, \"properties\": { \"name\": \"Akron OH\", \"country.etc\": \"OH\", \"pop\": 206634, \"lat\": 41.080000, \"long\": -81.520000, \"capital\": 0 }, \"geometry\": { \"type\": \"Point\", \"coordinates\": [ -81.52, 41.08 ] } }]}")

  gwf4 <- tempfile(fileext = ".geojson")
  d <- suppressMessages(geojson_write(us_cities[1:2,], lat = 'lat', lon = 'long', precision = 1, file = gwf4))
  expect_is(d, "geojson")
  d_txt <- gsub("\\s+", " ", paste0(readLines(gwf4), collapse = ""))
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
  
  gwf5 <- tempfile(fileext = ".geojson")
  e <- suppressMessages(geojson_write(sp_poly, file = gwf5))
  expect_is(e, "geojson")
  e_txt <- gsub("\\s+", " ", paste0(readLines(gwf5), collapse = ""))
  expect_equal(e_txt, "{\"type\": \"FeatureCollection\", \"features\": [{ \"type\": \"Feature\", \"id\": 1, \"properties\": { \"dummy\": 0.000000 }, \"geometry\": { \"type\": \"Polygon\", \"coordinates\": [ [ [ -100.111, 40.111 ], [ -90.111, 50.111 ], [ -85.111, 45.111 ], [ -100.111, 40.111 ] ] ] } },{ \"type\": \"Feature\", \"id\": 2, \"properties\": { \"dummy\": 0.000000 }, \"geometry\": { \"type\": \"Polygon\", \"coordinates\": [ [ [ -90.111, 30.111 ], [ -80.111, 40.111 ], [ -75.111, 35.111 ], [ -90.111, 30.111 ] ] ] } }]}")

  gwf6 <- tempfile(fileext = ".geojson")
  f <- suppressMessages(geojson_write(sp_poly, precision = 2, file = gwf6))
  expect_is(f, "geojson")
  f_txt <- gsub("\\s+", " ", paste0(readLines(gwf6), collapse = ""))
  expect_equal(f_txt, "{\"type\": \"FeatureCollection\", \"features\": [{ \"type\": \"Feature\", \"id\": 1, \"properties\": { \"dummy\": 0.000000 }, \"geometry\": { \"type\": \"Polygon\", \"coordinates\": [ [ [ -100.11, 40.11 ], [ -90.11, 50.11 ], [ -85.11, 45.11 ], [ -100.11, 40.11 ] ] ] } },{ \"type\": \"Feature\", \"id\": 2, \"properties\": { \"dummy\": 0.000000 }, \"geometry\": { \"type\": \"Polygon\", \"coordinates\": [ [ [ -90.11, 30.11 ], [ -80.11, 40.11 ], [ -75.11, 35.11 ], [ -90.11, 30.11 ] ] ] } }]}")
})

test_that("geojson_write detects inproper polygons passed as lists inputs", {
  good <- list(c(100.0,0.0), c(101.0,0.0), c(101.0,1.0), c(100.0,1.0), c(100.0,0.0))
  bad <- list(c(100.0,0.0), c(101.0,0.0), c(101.0,1.0), c(100.0,1.0), c(100.0,1))
  
  # fine
  gwf7 <- tempfile(fileext = ".geojson")
  fine <- suppressMessages(geojson_write(good, geometry = "polygon", file = gwf7))
  expect_is(fine, "geojson")
  expect_is(fine[[1]], "character")
  
  # bad
  expect_error(geojson_write(bad, geometry = "polygon"),
               "First and last point in a polygon must be identical")
  
  # doesn't matter if geometry != polygon
  expect_is(suppressMessages(geojson_write(bad)), "geojson")
})
