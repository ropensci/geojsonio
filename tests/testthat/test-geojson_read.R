test_that("geojson_read works with file inputs", {
  skip_on_cran()

  file <- system.file("examples", "california.geojson", package = "geojsonio")
  aa <- geojson_read(file)

  expect_type(aa, "list")
  expect_equal(aa$type, "FeatureCollection")
  expect_type(aa$features, "list")
  expect_equal(aa$features[[1]]$type, "Feature")
  expect_setequal(
    names(aa$features[[1]]),
    c("type", "properties", "geometry")
  )
  expect_true(all(c("type", "features") %in% names(aa)))
})

test_that("geojson_read works with url inputs", {
  skip_on_cran()

  url <- "https://raw.githubusercontent.com/glynnbird/usstatesgeojson/master/california.geojson"
  aa <- geojson_read(url)

  expect_type(aa, "list")
  expect_equal(aa$type, "FeatureCollection")
  expect_type(aa$features, "list")
  expect_equal(aa$features[[1]]$type, "Feature")
  expect_setequal(
    names(aa$features[[1]]),
    c("type", "properties", "geometry")
  )
})

test_that("geojson_read works with as.location inputs", {
  skip_on_cran()

  file <- system.file("examples", "california.geojson", package = "geojsonio")
  aa <- geojson_read(as.location(file))

  expect_type(aa, "list")
  expect_equal(aa$type, "FeatureCollection")
  expect_type(aa$features, "list")
  expect_equal(aa$features[[1]]$type, "Feature")
  expect_setequal(
    names(aa$features[[1]]),
    c("type", "properties", "geometry")
  )
  expect_true(all(c("type", "features") %in% names(aa)))
})

test_that("geojson_read works outputing spatial class object", {
  skip_on_cran()

  file <- system.file("examples", "norway_maple.kml", package = "geojsonio")
  aa <- geojson_read(as.location(file), what = "sp")

  expect_s4_class(aa, "SpatialPointsDataFrame")
  expect_s3_class(aa@data, "data.frame")
  expect_s4_class(aa@proj4string, "CRS")
})
