context("topojson_json")

test_that("topojson_json works with numeric inputs", {
  aa <- topojson_json(c(-99.74,32.45), quiet = TRUE)
  expect_is(aa, "json")
})

test_that("topojson_json works with numeric inputs for polygons", {
  poly <- c(c(-114.345703125,39.436192999314095),
            c(-114.345703125,43.45291889355468),
            c(-106.61132812499999,43.45291889355468),
            c(-106.61132812499999,39.436192999314095),
            c(-114.345703125,39.436192999314095))
  aa <- topojson_json(poly, type = "GeometryCollection", quiet = TRUE)
  expect_is(aa, "json")
})

test_that("topojson_json works with list inputs", {
  vecs <- list(c(100.0,0.0), c(101.0,0.0), c(101.0,1.0), c(100.0,1.0),
    c(100.0,0.0))
  aa <- topojson_json(vecs, geometry="polygon")
  expect_is(aa, "json")
})

test_that("topojson_json works with data.frame inputs", {
  aa <- topojson_json(us_cities[1:2,], lat='lat', lon='long')
  expect_is(aa, "json")
})