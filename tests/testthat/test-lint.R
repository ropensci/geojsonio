context("lint")

test_that("lint works with character inputs", {
  a <- lint('{"type": "FooBar"}')
  expect_false(a)
  # expect_is(attributes(a)$message, "character")
  # expect_equal(a$message, "The type FooBar is unknown")

  # valid
  expect_true(lint('{"type": "Point", "coordinates": [-80,40]}'))
  res <- lint('{"type": "Point", "coordinates": [-80,40]}', verbose = TRUE)
  expect_null(attributes(res))
  
  # invalid
  expect_false(lint('{ "type": "FeatureCollection" }'))
  expect_false(lint('{"type":"Point","geometry":{"type":"Point","coordinates":[-80,40]},"properties":{}}'))
  res <- lint('{"type":"Point","geometry":{"type":"Point","coordinates":[-80,40]},"properties":{}}', verbose = TRUE)
  expect_named(attributes(res), "errors")
  expect_equal(attributes(res)$errors$message, "\"coordinates\" property required")
  
  # with stop
  expect_error(lint('{ "type": "FeatureCollection" }', error = TRUE), 
               "\"features\" property required")
  expect_error(lint('{"type":"Point","geometry":{"type":"Point","coordinates":[-80,40]},"properties":{}}', error = TRUE), 
               "\"coordinates\" property required")
})

test_that("lint works with geo_list inputs", {
  mylist <- list(list(latitude=30, longitude=120, marker="red"),
                 list(latitude=30, longitude=130, marker="blue"))
  x <- suppressMessages(geojson_list(mylist))
  b <- lint(x)
  expect_is(x, "geo_list")
  expect_true(b)
})

test_that("lint works with file inputs", {
  file <- system.file("examples", "zillow_or.geojson", package = "geojsonio")
  d <- lint(as.location(file))
  expect_is(as.location(file), "location")
  expect_true(d)
})

test_that("lint works with url inputs", {
  skip_on_cran()
  
  url <- "https://raw.githubusercontent.com/glynnbird/usstatesgeojson/master/california.geojson"
  e <- lint(as.location(url))
  expect_is(as.location(url), "location")
  expect_true(e)
})

test_that("lint works with json inputs", {
  x <- jsonlite::minify('{ "type": "FeatureCollection" }')
  f <- lint(x)
  expect_is(x, "json")
  expect_false(f)
})

test_that("lint works with data.frame inputs", {
  h <- lint(us_cities[1:2,], lat = 'lat', lon = 'long')
  expect_true(h)
})

test_that("lint works with numeric vector inputs", {
  expect_true(lint(c(32.45, -99.74)))
  expect_true(lint(c(32.45, -99.74)))
})

test_that("lint works with list inputs", {
  mylist <- list(list(latitude=30, longitude=120, marker="red"), 
                 list(latitude=30, longitude=130, marker="blue"))
  ii <- suppressMessages(lint(mylist))
  expect_true(ii)
})



## spatial classes --------------
sp_poly <- local({
  library('sp')
  poly1 <- Polygons(list(Polygon(cbind(c(-100,-90,-85,-100),
                                       c(40,50,45,40)))), "1")
  poly2 <- Polygons(list(Polygon(cbind(c(-90,-80,-75,-90),
                                       c(30,40,35,30)))), "2")
  SpatialPolygons(list(poly1, poly2), 1:2)
})

sp_pts <- local({
  library("sp")
  a <- c(1,2,3,4,5)
  b <- c(3,2,5,1,4)
  SpatialPoints(cbind(a,b))
})

sp_lines <- local({
  library("sp")
  c1 <- cbind(c(1,2,3), c(3,2,2))
  L1 <- Line(c1)
  Ls1 <- Lines(list(L1), ID = "a")
  SpatialLines(list(Ls1))
})

sp_grid <- local({
  library("sp")
  x <- GridTopology(c(0,0), c(1,1), c(5,5))
  SpatialGrid(x)
})

test_that("lint works with SpatialPolygons inputs", {
  jj <- lint(sp_poly)
  expect_true(jj)
})

test_that("lint works with SpatialPolygonsDataFrame inputs", {
  sp_polydf <- as(sp_poly, "SpatialPolygonsDataFrame")
  jj <- lint(sp_polydf)
  
  expect_true(jj)
})

test_that("lint works with SpatialPoints inputs", {
  kk <- lint(sp_pts)
  expect_is(sp_pts, "SpatialPoints")
  expect_true(kk)
})

test_that("lint works with SpatialPointsDataFrame inputs", {
  sp_ptsdf <- as(sp_pts, "SpatialPointsDataFrame")
  ll <- lint(sp_ptsdf)
  expect_is(sp_ptsdf, "SpatialPointsDataFrame")
  expect_true(ll)
})

test_that("lint works with SpatialLines inputs", {
  mm <- lint(sp_lines)
  expect_is(sp_lines, "SpatialLines")
  expect_true(mm)
})

test_that("lint works with SpatialLinesDataFrame inputs", {
  sp_linesdf <- as(sp_lines, "SpatialLinesDataFrame")
  nn <- lint(sp_linesdf)
  expect_is(sp_linesdf, "SpatialLinesDataFrame")
  expect_true(nn)
})


test_that("lint works with SpatialGrid inputs", {
  mm <- lint(sp_grid)
  expect_is(sp_grid, "SpatialGrid")
  expect_true(mm)
})

test_that("lint works with SpatialGridDataFrame inputs", {
  sp_griddf <- SpatialGridDataFrame(sp_grid, data.frame(val = 1:25))
  nn <- lint(sp_griddf)
  expect_is(sp_griddf, "SpatialGridDataFrame")
  expect_true(nn)
})
