features_names <- sort(c("type", "properties", "geometry"))
top_names <- sort(c("type", "features"))

context("geojson_read")

test_that("geojson_read works with file inputs", {
  skip_on_cran()
  
  file <- system.file("examples", "california.geojson", package = "geojsonio")
  aa <- geojson_read(file)
  
  expect_is(aa, "list")
  expect_equal(aa$type, "FeatureCollection")
  expect_is(aa$features, "list")
  expect_equal(aa$features[[1]]$type, "Feature")
  expect_equal(sort(names(aa$features[[1]])), features_names)
  expect_true(all(top_names %in% names(aa)))
})

test_that("geojson_read works with url inputs", {
  skip_on_cran()
  
  skip_on_cran()
  
  url <- "https://raw.githubusercontent.com/glynnbird/usstatesgeojson/master/california.geojson"
  aa <- geojson_read(url)
   
  expect_is(aa, "list")
  expect_equal(aa$type, "FeatureCollection")
  expect_is(aa$features, "list")
  expect_equal(aa$features[[1]]$type, "Feature")
  expect_equal(sort(names(aa$features[[1]])), features_names)
})

test_that("geojson_read works with as.location inputs", {
  skip_on_cran()
  
  file <- system.file("examples", "california.geojson", package = "geojsonio")
  aa <- geojson_read(as.location(file))
  
  expect_is(aa, "list")
  expect_equal(aa$type, "FeatureCollection")
  expect_is(aa$features, "list")
  expect_equal(aa$features[[1]]$type, "Feature")
  expect_equal(sort(names(aa$features[[1]])), features_names)
  expect_true(all(top_names %in% names(aa)))
})

test_that("geojson_read works outputing spatial class object", {
  skip_on_cran()
  
  file <- system.file("examples", "norway_maple.kml", package = "geojsonio")
  aa <- geojson_read(as.location(file), what = "sp")
  
  expect_is(aa, "SpatialPointsDataFrame")
  expect_is(aa@data, "data.frame")
  expect_is(aa@proj4string, "CRS")
})
