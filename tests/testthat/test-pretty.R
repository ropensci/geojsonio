context("pretty")

test_that("pretty works with json inputs", {
  a <- geojson_json(c(-99.74,32.45)) %>% pretty
  expect_is(a, "json")
  expect_is(unclass(a), "character")
  expect_false(identical(a, geojson_json(c(-99.74,32.45), pretty = TRUE)))
})

test_that("pretty fails correctly with geo_list inputs", {
  expect_error(geojsonio::pretty(geojson_list(c(-99.74,32.45))), 
               "No method for geo_list")
})
