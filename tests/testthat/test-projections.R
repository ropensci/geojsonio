context("projections")

test_that("projections works with different projection names", {
  skip_on_cran()
  
  aa <- 
  bb <- projections("orthographic")
  
  expect_is(projections("albers"), "character")
  expect_is(projections("orthographic"), "character")
  expect_is(projections("conicEqualArea"), "character")
  expect_is(projections("stereographic"), "character")
  expect_is(projections("conicEquidistant"), "character")
  
  expect_equal(projections("albers"), "d3.geo.albers()")
  expect_equal(projections("orthographic"), "d3.geo.orthographic()")
})

test_that("projections works with rotate parameter", {
  aa <- projections(proj="albers", rotate='[98 + 00 / 60, -35 - 00 / 60]', scale=5700)
  
  expect_is(aa, "character")
  expect_match(aa, "geo.albers")
  expect_match(aa, "rotate")
  expect_match(aa, "scale")
})

test_that("projections works with scale parameter", {
  aa <- projections(proj="albers", scale=5700)
  
  expect_is(aa, "character")
  expect_match(aa, "scale\\(5700\\)")
})

test_that("projections works with translate parameter", {
  aa <- projections(proj="albers", translate='[55 * width / 100, 52 * height / 100]')
  
  expect_is(aa, "character")
  expect_match(aa, "translate")
  expect_match(aa, "width")
})

test_that("projections works with clipAngle parameter", {
  aa <- projections(proj="albers", clipAngle=90)
  
  expect_is(aa, "character")
  expect_match(aa, "clipAngle")
})

test_that("projections fails well", {
  expect_error(projections(), "You must provide a character string to 'proj'")
  ## FIXME - add tests for, and make changes to fxn, for forcing inputs to be of correct type
})
