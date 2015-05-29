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

test_that("lint works with file or url inputs", {
  file <- system.file("examples", "zillow_or.geojson", package = "geojsonio")
  d <- lint(as.location(file))
  expect_is(as.location(file), "location")
  expect_is(d, "character")
  expect_equal(d, "valid")
  
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

test_that("lint works with SpatialPoints inputs", {
  library("sp")
  a <- c(1,2,3,4,5)
  b <- c(3,2,5,1,4)
  x <- SpatialPoints(cbind(a,b))
  g <- lint(x)
  expect_is(x, "SpatialPoints")
  expect_is(g, "character")
  expect_equal(g, "valid")
})

test_that("lint works with data.frame inputs", {
  h <- lint(us_cities[1:2,], lat = 'lat', lon = 'long')
  expect_is(h, "character")
  expect_equal(h, "valid")
})

test_that("lint works with data.frame inputs", {
  expect_is(lint(c(32.45, -99.74)), "character")
  expect_equal(lint(c(32.45, -99.74)), "valid")
})
