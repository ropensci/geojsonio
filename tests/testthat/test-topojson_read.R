context("topojson_read")

test_that("topojson_read works with file inputs", {
  skip_on_cran()

  file <- system.file("examples", "us_states.topojson", package = "geojsonio")
  aa <- topojson_read(file, stringsAsFactors = TRUE)
  df <- as.data.frame(aa)
  
  expect_is(aa, "sf")
  expect_is(df, "data.frame")
  expect_named(df, c("id", "geometry"))
  expect_is(df$id, "factor")
  expect_is(df$geometry, "sfc")
  expect_is(df$geometry[[1]], "sfg")
})

test_that("topojson_read works with file inputs: stringsAsFactors works", {
  skip_on_cran()

  file <- system.file("examples", "us_states.topojson", package = "geojsonio")
  aa <- topojson_read(file, stringsAsFactors = FALSE)
  df <- as.data.frame(aa)
  expect_is(df$id, "character")
})

test_that("topojson_read works with url inputs", {
  skip_on_cran()
  
  url <- "https://raw.githubusercontent.com/shawnbot/d3-cartogram/master/data/us-states.topojson"
  aa <- topojson_read(url)
  df <- as.data.frame(aa)
  
  expect_is(aa, "sf")
  expect_is(df, "data.frame")
  expect_named(df, c("id", "geometry"))
})

test_that("topojson_read works with as.location inputs", {
  skip_on_cran()

  file <- system.file("examples", "us_states.topojson", package = "geojsonio")
  aa <- topojson_read(as.location(file))
  df <- as.data.frame(aa)
  
  expect_is(aa, "sf")
  expect_is(df, "data.frame")
})

test_that("topojson_read works with .json extension", {
  skip_on_cran()
  
  file <- tempfile(fileext = ".json")
  cat('{"type":"Topology","objects":{"foo":{"type":"LineString","arcs":[0]}},"arcs":[[[100,0],[101,1]]],"bbox":[100,0,101,1]}', 
      file = file)
  aa <- topojson_read(file)
  
  expect_is(aa, "sf")
})
