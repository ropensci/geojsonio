library("leaflet")
supp_invis <- function(x) suppressMessages(invisible(x))

test_that("map_leaf works with file inputs", {
  skip_on_cran()
  file <- "myfile.geojson"
  supp_invis(geojson_write(us_cities[1:20, ], lat = "lat", lon = "long", file = file))
  a_map <- map_leaf(as.location(file))
  expect_s3_class(as.location(file), "location_")
  expect_s3_class(a_map, "leaflet")
  expect_null(a_map$width)
  expect_s3_class(a_map$x$calls[[2]]$args[[1]], "json")
  expect_equal(a_map$x$calls[[2]]$method, "addGeoJSON")
})

test_that("map_leaf works with character inputs", {
  skip_on_cran()
  b_map <- geojson_json(c(-99.74, 32.45)) %>%
    as.character() %>%
    map_leaf()
  expect_s3_class(b_map, "leaflet")
  expect_equal(
    b_map$x$calls[[2]]$args[[1]],
    "{\"type\":\"FeatureCollection\",\"features\":[{\"type\":\"Feature\",\"geometry\":{\"type\":\"Point\",\"coordinates\":[-99.74,32.45]},\"properties\":{}}]}"
  )
})

test_that("map_leaf works with geo_list inputs", {
  skip_on_cran()
  mylist <- list(
    list(latitude = 30, longitude = 120, marker = "red"),
    list(latitude = 30, longitude = 130, marker = "blue")
  )
  x <- suppressMessages(geojson_list(mylist))
  c_map <- map_leaf(x)
  expect_s3_class(x, "geo_list")
  expect_s3_class(c_map, "leaflet")
})

test_that("map_leaf works with url inputs", {
  skip_on_cran()

  url <- "https://raw.githubusercontent.com/glynnbird/usstatesgeojson/master/california.geojson"
  e_map <- map_leaf(as.location(url))
  expect_s3_class(as.location(url), "location_")
  expect_s3_class(e_map, "leaflet")
})

test_that("map_leaf works with json inputs", {
  skip_on_cran()
  x <- geojson_json(c(-99.74, 32.45))
  f_map <- map_leaf(x)
  expect_s3_class(x, "json")
  expect_s3_class(f_map, "leaflet")
})

test_that("map_leaf works with data.frame inputs", {
  skip_on_cran()
  h_map <- supp_invis(map_leaf(us_cities, basemap = "CartoDB.Positron"))
  expect_s3_class(h_map, "leaflet")
})

test_that("map_leaf works with numeric vector inputs - error - not working yet", {
  skip_on_cran()
  expect_error(map_leaf(c(32.45, -99.74)))
})

test_that("map_leaf works with list inputs", {
  skip_on_cran()
  poly <- list(
    c(-114.345703125, 39.436192999314095),
    c(-114.345703125, 43.45291889355468),
    c(-106.61132812499999, 43.45291889355468),
    c(-106.61132812499999, 39.436192999314095),
    c(-114.345703125, 39.436192999314095)
  )
  ii_map <- supp_invis(map_leaf(poly))
  expect_s3_class(ii_map, "leaflet")
})



## spatial classes --------------
sp_poly <- local({
  library("sp")
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
  library("sp")
  a <- c(1, 2, 3, 4, 5)
  b <- c(3, 2, 5, 1, 4)
  SpatialPoints(cbind(a, b))
})

sp_lines <- local({
  library("sp")
  c1 <- cbind(c(1, 2, 3), c(3, 2, 2))
  L1 <- Line(c1)
  Ls1 <- Lines(list(L1), ID = "a")
  SpatialLines(list(Ls1))
})

sp_grid <- local({
  library("sp")
  x <- GridTopology(c(0, 0), c(1, 1), c(5, 5))
  SpatialGrid(x)
})

test_that("map_leaf works with SpatialPolygons inputs", {
  skip_on_cran()
  jj <- map_leaf(sp_poly)

  expect_s3_class(jj, "leaflet")
})

test_that("map_leaf works with SpatialPolygonsDataFrame inputs", {
  skip_on_cran()
  sp_polydf <- as(sp_poly, "SpatialPolygonsDataFrame")
  jj <- map_leaf(sp_polydf)

  expect_s3_class(jj, "leaflet")
})

test_that("map_leaf works with SpatialPoints inputs", {
  skip_on_cran()
  kk <- map_leaf(sp_pts)
  expect_s4_class(sp_pts, "SpatialPoints")
  expect_s3_class(kk, "leaflet")
})

test_that("map_leaf works with SpatialPointsDataFrame inputs", {
  skip_on_cran()
  sp_ptsdf <- as(sp_pts, "SpatialPointsDataFrame")
  ll <- map_leaf(sp_ptsdf)
  expect_s4_class(sp_ptsdf, "SpatialPointsDataFrame")
  expect_s3_class(ll, "leaflet")
})

test_that("map_leaf works with SpatialLines inputs", {
  skip_on_cran()
  mm <- map_leaf(sp_lines)
  expect_s4_class(sp_lines, "SpatialLines")
  expect_s3_class(mm, "leaflet")
})

test_that("map_leaf works with SpatialLinesDataFrame inputs", {
  skip_on_cran()
  sp_linesdf <- as(sp_lines, "SpatialLinesDataFrame")
  nn <- map_leaf(sp_linesdf)
  expect_s4_class(sp_linesdf, "SpatialLinesDataFrame")
  expect_s3_class(nn, "leaflet")
})


test_that("map_leaf works with SpatialGrid inputs", {
  skip_on_cran()
  mm <- map_leaf(sp_grid)
  expect_s4_class(sp_grid, "SpatialGrid")
  expect_s3_class(mm, "leaflet")
})

test_that("map_leaf works with SpatialGridDataFrame inputs", {
  skip_on_cran()
  sp_griddf <- SpatialGridDataFrame(sp_grid, data.frame(val = 1:25))
  nn <- map_leaf(sp_griddf)
  expect_s4_class(sp_griddf, "SpatialGridDataFrame")
  expect_s3_class(nn, "leaflet")
})
