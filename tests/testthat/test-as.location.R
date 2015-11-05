context("as.location")

test_that("as.location returns correct class", {
  skip_on_cran()
  
  url <- "https://raw.githubusercontent.com/glynnbird/usstatesgeojson/master/california.geojson"
  b <- as.location(url)
  
  expect_is(b, "location")
  expect_is(b[[1]], "character")
  expect_null(names(b))
})

test_that("as.location print method works as expected", {
  skip_on_cran()
  
  url <- "https://raw.githubusercontent.com/glynnbird/usstatesgeojson/master/california.geojson"
  b <- as.location(url)
  txt <- capture.output(print.location(b))
  
  expect_is(txt, "character")
  expect_equal(length(txt), 3)
  expect_true(grepl("location", txt[1]))
  expect_true(grepl("geojson", txt[3]))
})
