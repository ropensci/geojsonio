context("validate")

test_that("validate works with character inputs", {
  a <- validate('{"type": "FooBar"}')
  expect_is(a, "list")
  expect_is(a$message, "character")
  expect_equal(a$message, "\"FooBar\" is not a valid GeoJSON type.")

  # listid
  expect_equal(validate('{"type": "Point", "coordinates": [-80,40]}')$status, "ok")

  # invalid
  expect_equal(validate('{ "type": "FeatureCollection" }')$status, "error")
  expect_equal(validate('{"type":"Point","geometry":{"type":"Point","coordinates":[-80,40]},"properties":{}}')$status, "error")
})

test_that("validate works with geo_list inputs", {
  mylist <- list(list(latitude=30, longitude=120, marker="red"),
                 list(latitude=30, longitude=130, marker="blue"))
  x <- suppressMessages(geojson_list(mylist))
  b <- validate(x)
  expect_is(x, "geo_list")
  expect_is(b, "list")
  expect_equal(b$status, "ok")
})

test_that("validate works with file inputs", {
  file <- system.file("examples", "zillow_or.geojson", package = "geojsonio")
  d <- validate(as.location(file))
  expect_is(as.location(file), "location")
  expect_is(d, "list")
  expect_equal(d$status, "ok")
})

test_that("validate works with url inputs", {
  skip_on_cran()

  url <- "https://raw.githubusercontent.com/glynnbird/usstatesgeojson/master/california.geojson"
  e <- validate(as.location(url))
  expect_is(as.location(url), "location")
  expect_is(e, "list")
  expect_equal(e$status, "ok")
})

test_that("validate works with json inputs", {
  x <- jsonlite::minify('{ "type": "FeatureCollection" }')
  f <- validate(x)
  expect_is(x, "json")
  expect_is(f, "list")
  expect_equal(f$message, "A FeatureCollection must have a \"features\" property.")
})

test_that("validate works with data.frame inputs", {
  h <- validate(us_cities[1:2,], lat = 'lat', lon = 'long')
  expect_is(h, "list")
  expect_equal(h$status, "ok")
})

test_that("validate works with numeric vector inputs", {
  expect_is(validate(c(32.45, -99.74)), "list")
  expect_equal(validate(c(32.45, -99.74))$status, "ok")
})

test_that("validate works with list inputs", {
  mylist <- list(list(latitude=30, longitude=120, marker="red"),
                 list(latitude=30, longitude=130, marker="blue"))
  ii <- suppressMessages(validate(mylist))
  expect_is(ii, "list")
  expect_equal(ii$status, "ok")
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

test_that("validate works with SpatialPolygons inputs", {
  jj <- validate(sp_poly)

  expect_is(jj, "list")
  expect_equal(jj$status, "ok")
})

test_that("validate works with SpatialPolygonsDataFrame inputs", {
  sp_polydf <- as(sp_poly, "SpatialPolygonsDataFrame")
  jj <- validate(sp_polydf)

  expect_is(jj, "list")
  expect_equal(jj$status, "ok")
})

test_that("validate works with SpatialPoints inputs", {
  kk <- validate(sp_pts)
  expect_is(sp_pts, "SpatialPoints")
  expect_is(kk, "list")
  expect_equal(kk$status, "ok")
})

test_that("validate works with SpatialPointsDataFrame inputs", {
  sp_ptsdf <- as(sp_pts, "SpatialPointsDataFrame")
  ll <- validate(sp_ptsdf)
  expect_is(sp_ptsdf, "SpatialPointsDataFrame")
  expect_is(ll, "list")
  expect_equal(ll$status, "ok")
})

test_that("validate works with SpatialLines inputs", {
  mm <- validate(sp_lines)
  expect_is(sp_lines, "SpatialLines")
  expect_is(mm, "list")
  expect_equal(mm$status, "ok")
})

test_that("validate works with SpatialLinesDataFrame inputs", {
  sp_linesdf <- as(sp_lines, "SpatialLinesDataFrame")
  nn <- validate(sp_linesdf)
  expect_is(sp_linesdf, "SpatialLinesDataFrame")
  expect_is(nn, "list")
  expect_equal(nn$status, "ok")
})


test_that("validate works with SpatialGrid inputs", {
  mm <- validate(sp_grid)
  expect_is(sp_grid, "SpatialGrid")
  expect_is(mm, "list")
  expect_equal(mm$status, "ok")
})

test_that("validate works with SpatialGridDataFrame inputs", {
  sp_griddf <- SpatialGridDataFrame(sp_grid, data.frame(val = 1:25))
  nn <- validate(sp_griddf)
  expect_is(sp_griddf, "SpatialGridDataFrame")
  expect_is(nn, "list")
  expect_equal(nn$status, "ok")
})
