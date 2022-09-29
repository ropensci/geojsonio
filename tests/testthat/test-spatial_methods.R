test_that("SpatialPoints to SpatialPointsDataFrame", {
  skip_on_cran()
  sp_pts <- local({
    a <- c(1, 2, 3, 4, 5)
    b <- c(3, 2, 5, 1, 4)
    SpatialPoints(cbind(a, b))
  })
  a <- as(sp_pts, "SpatialPointsDataFrame")

  expect_s4_class(sp_pts, "SpatialPoints")
  expect_s4_class(a, "SpatialPointsDataFrame")
})

test_that("SpatialLines to SpatialLinesDataFrame", {
  skip_on_cran()
  sp_lines <- local({
    c1 <- cbind(c(1, 2, 3), c(3, 2, 2))
    L1 <- Line(c1)
    Ls1 <- Lines(list(L1), ID = "a")
    SpatialLines(list(Ls1))
  })
  a <- as(sp_lines, "SpatialLinesDataFrame")

  expect_s4_class(sp_lines, "SpatialLines")
  expect_s4_class(a, "SpatialLinesDataFrame")
})

test_that("SpatialPixels to SpatialPointsDataFrame", {
  skip_on_cran()
  sp_pixels <- suppressWarnings(SpatialPixels(SpatialPoints(us_cities[c("long", "lat")])))
  a <- as(sp_pixels, "SpatialPointsDataFrame")

  expect_s4_class(sp_pixels, "SpatialPixels")
  expect_s4_class(a, "SpatialPointsDataFrame")
})
