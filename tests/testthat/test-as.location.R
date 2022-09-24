test_that("as.location returns correct class", {
  skip_on_cran()

  url <- "https://raw.githubusercontent.com/glynnbird/usstatesgeojson/master/california.geojson"
  b <- as.location(url)

  expect_s3_class(b, "location_")
  expect_type(b[[1]], "character")
  expect_null(names(b))
})

test_that("as.location print method works as expected", {
  skip_on_cran()

  url <- "https://raw.githubusercontent.com/glynnbird/usstatesgeojson/master/california.geojson"
  b <- as.location(url)
  txt <- capture.output(print.location_(b))

  expect_type(txt, "character")
  expect_equal(length(txt), 3)
  expect_true(grepl("location", txt[1]))
  expect_true(grepl("geojson", txt[3]))
})
