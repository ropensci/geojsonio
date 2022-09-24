skip_on_cran()

context("spatial-methods")

suppressPackageStartupMessages(library("sp"))

sp_poly <- local({
  poly1 <- Polygons(list(Polygon(cbind(
    c(-100, -90, -85, -100),
    c(40, 50, 45, 40)
  ))), "1")
  poly2 <- Polygons(list(Polygon(cbind(
    c(-90, -80, -75, -90),
    c(30, 40, 35, 30)
  ))), "2")
  SpatialPolygons(list(poly1, poly2), 1:2)
})

sp_pts <- local({
  a <- c(1, 2, 3, 4, 5)
  b <- c(3, 2, 5, 1, 4)
  SpatialPoints(cbind(a, b))
})

sp_lines <- local({
  c1 <- cbind(c(1, 2, 3), c(3, 2, 2))
  L1 <- Line(c1)
  Ls1 <- Lines(list(L1), ID = "a")
  SpatialLines(list(Ls1))
})

sp_grid <- local({
  x <- GridTopology(c(0, 0), c(1, 1), c(5, 5))
  SpatialGrid(x)
})

sp_pixels <- local({
  suppressWarnings(SpatialPixels(SpatialPoints(us_cities[c("long", "lat")])))
})


test_that("SpatialPoints to SpatialPointsDataFrame", {
  a <- as(sp_pts, "SpatialPointsDataFrame")

  expect_is(sp_pts, "SpatialPoints")
  expect_is(a, "SpatialPointsDataFrame")
})

test_that("SpatialLines to SpatialLinesDataFrame", {
  a <- as(sp_lines, "SpatialLinesDataFrame")

  expect_is(sp_lines, "SpatialLines")
  expect_is(a, "SpatialLinesDataFrame")
})

test_that("SpatialPixels to SpatialPointsDataFrame", {
  a <- as(sp_pixels, "SpatialPointsDataFrame")

  expect_is(sp_pixels, "SpatialPixels")
  expect_is(a, "SpatialPointsDataFrame")
})
