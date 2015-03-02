context("testing as.location")

# A URL
url <- "https://raw.githubusercontent.com/glynnbird/usstatesgeojson/master/california.geojson"
b <- as.location(url)

test_that("as.location returns correct class", {
  expect_is(b, "location")
  expect_is(b[[1]], "character")
  expect_null(names(b))
})
