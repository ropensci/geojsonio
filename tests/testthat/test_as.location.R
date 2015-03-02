context("testing as.location")

# A file
file <- system.file("examples", "zillow_or.geojson", package = "geojsonio")
a <- as.location(file)

# A URL
url <- "https://raw.githubusercontent.com/glynnbird/usstatesgeojson/master/california.geojson"
b <- as.location(url)

test_that("as.location returns correct class", {
  expect_is(a, "location")
  expect_is(a[[1]], "character")
  expect_null(names(a))
  
  expect_is(b, "location")
  expect_is(b[[1]], "character")
  expect_null(names(b))
})
