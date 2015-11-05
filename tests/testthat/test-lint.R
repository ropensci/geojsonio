context("lint")

test_that("lint works with character inputs", {
  a <- lint('{"type": "FooBar"}')
  expect_is(a, "list")
  expect_is(a$message, "character")
  expect_equal(a$message, "The type FooBar is unknown")

  # valid
  expect_equal(lint('{"type": "Point", "coordinates": [-80,40]}'), "valid")
  
  # invalid
  expect_is(lint('{ "type": "FeatureCollection" }'), "list")
  expect_is(lint('{"type":"Point","geometry":{"type":"Point","coordinates":[-80,40]},"properties":{}}'), "list")
})

test_that("lint works with geo_list inputs", {
  mylist <- list(list(latitude=30, longitude=120, marker="red"),
                 list(latitude=30, longitude=130, marker="blue"))
  x <- suppressMessages(geojson_list(mylist))
  b <- lint(x)
  expect_is(x, "geo_list")
  expect_is(b, "character")
  expect_equal(b, "valid")
})

test_that("lint works with file inputs", {
  file <- system.file("examples", "zillow_or.geojson", package = "geojsonio")
  d <- lint(as.location(file))
  expect_is(as.location(file), "location")
  expect_is(d, "character")
  expect_equal(d, "valid")
})

test_that("lint works with url inputs", {
  skip_on_cran()
  
  url <- "https://raw.githubusercontent.com/glynnbird/usstatesgeojson/master/california.geojson"
  e <- lint(as.location(url))
  expect_is(as.location(url), "location")
  expect_is(e, "character")
  expect_equal(e, "valid")
})

test_that("lint works with json inputs", {
  x <- jsonlite::minify('{ "type": "FeatureCollection" }')
  f <- lint(x)
  expect_is(x, "json")
  expect_is(f, "list")
  expect_equal(f$message, "\"features\" property required")
})

test_that("lint works with data.frame inputs", {
  h <- lint(us_cities[1:2,], lat = 'lat', lon = 'long')
  expect_is(h, "character")
  expect_equal(h, "valid")
})

test_that("lint works with numeric vector inputs", {
  expect_is(lint(c(32.45, -99.74)), "character")
  expect_equal(lint(c(32.45, -99.74)), "valid")
})

test_that("lint works with list inputs", {
  mylist <- list(list(latitude=30, longitude=120, marker="red"), 
                 list(latitude=30, longitude=130, marker="blue"))
  ii <- suppressMessages(lint(mylist))
  expect_is(ii, "character")
  expect_equal(ii, "valid")
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
  
  expect_is(jj, "character")
  expect_equal(jj, "valid")
})

test_that("lint works with SpatialPolygonsDataFrame inputs", {
  sp_polydf <- as(sp_poly, "SpatialPolygonsDataFrame")
  jj <- lint(sp_polydf)
  
  expect_is(jj, "character")
  expect_equal(jj, "valid")
})

test_that("lint works with SpatialPoints inputs", {
  kk <- lint(sp_pts)
  expect_is(sp_pts, "SpatialPoints")
  expect_is(kk, "character")
  expect_equal(kk, "valid")
})

test_that("lint works with SpatialPointsDataFrame inputs", {
  sp_ptsdf <- as(sp_pts, "SpatialPointsDataFrame")
  ll <- lint(sp_ptsdf)
  expect_is(sp_ptsdf, "SpatialPointsDataFrame")
  expect_is(ll, "character")
  expect_equal(ll, "valid")
})

test_that("lint works with SpatialLines inputs", {
  mm <- lint(sp_lines)
  expect_is(sp_lines, "SpatialLines")
  expect_is(mm, "character")
  expect_equal(mm, "valid")
})

test_that("lint works with SpatialLinesDataFrame inputs", {
  sp_linesdf <- as(sp_lines, "SpatialLinesDataFrame")
  nn <- lint(sp_linesdf)
  expect_is(sp_linesdf, "SpatialLinesDataFrame")
  expect_is(nn, "character")
  expect_equal(nn, "valid")
})


test_that("lint works with SpatialGrid inputs", {
  mm <- lint(sp_grid)
  expect_is(sp_grid, "SpatialGrid")
  expect_is(mm, "character")
  expect_equal(mm, "valid")
})

test_that("lint works with SpatialGridDataFrame inputs", {
  sp_griddf <- SpatialGridDataFrame(sp_grid, data.frame(val = 1:25))
  nn <- lint(sp_griddf)
  expect_is(sp_griddf, "SpatialGridDataFrame")
  expect_is(nn, "character")
  expect_equal(nn, "valid")
})
