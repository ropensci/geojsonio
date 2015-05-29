context("as.location")

test_that("as.location returns correct class", {
  skip_on_cran()
  
  url <- "https://raw.githubusercontent.com/glynnbird/usstatesgeojson/master/california.geojson"
  b <- as.location(url)
  
  expect_is(b, "location")
  expect_is(b[[1]], "character")
  expect_null(names(b))
})
