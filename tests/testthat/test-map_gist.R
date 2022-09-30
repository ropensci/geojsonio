skip_if_not(Sys.getenv("GITHUB_PAT") != "")
skip_on_ci()
skip_on_cran()

test_that("map_gist works with file inputs", {
  skip_on_cran()

  file <- withr::local_tempfile(fileext = ".geojson")
  supm(geojson_write(us_cities[1:20, ], lat = "lat", lon = "long", file = file))
  a <- map_gist(file = as.location(file), browse = FALSE)
  expect_s3_class(a, "gist")
  expect_type(a$url, "character")
  expect_named(a$files, basename(file))

  supm(gistr::delete(a))
})

test_that("map_gist works with geo_list inputs", {
  skip_on_cran()

  file <- withr::local_tempfile(fileext = ".geojson")

  res <- geojson_list(us_cities[1:2, ], lat = "lat", lon = "long")
  b <- supm(map_gist(res, browse = FALSE, file = file))
  expect_s3_class(res, "geo_list")
  expect_s3_class(b, "gist")

  supm(gistr::delete(b))
})

test_that("map_gist works with json inputs", {
  skip_on_cran()

  file <- withr::local_tempfile(fileext = ".geojson")

  x <- geojson_json(c(-99.74, 32.45))
  f <- supm(map_gist(x, browse = FALSE, file = file))
  expect_s3_class(x, "json")
  expect_s3_class(f, "gist")
  expect_type(f$git_pull_url, "character")

  supm(gistr::delete(f))
})

test_that("map_gist works with SpatialPoints inputs", {
  skip_on_cran()

  file <- withr::local_tempfile(fileext = ".geojson")

  a <- c(1, 2, 3, 4, 5)
  b <- c(3, 2, 5, 1, 4)
  x <- SpatialPoints(cbind(a, b))
  g <- supm(map_gist(x, browse = FALSE, file = file))
  expect_s3_class(g, "gist")
  expect_type(g$url, "character")
  expect_named(g$files, basename(file))

  supm(gistr::delete(g))
})

test_that("map_gist works with SpatialPointsDataFrame inputs", {
  skip_on_cran()

  file <- withr::local_tempfile(fileext = ".geojson")

  a <- c(1, 2, 3, 4, 5)
  b <- c(3, 2, 5, 1, 4)
  s <- SpatialPointsDataFrame(cbind(a, b), mtcars[1:5, ])
  h <- supm(map_gist(s, browse = FALSE, file = file))
  expect_s3_class(h, "gist")
  expect_type(h$url, "character")
  expect_named(h$files, basename(file))

  supm(gistr::delete(h))
})

test_that("map_gist works with SpatialPolygons inputs", {
  skip_on_cran()

  file <- withr::local_tempfile(fileext = ".geojson")

  poly1 <- Polygons(list(Polygon(cbind(
    c(-100, -90, -85, -100),
    c(40, 50, 45, 40)
  ))), "1")
  poly2 <- Polygons(list(Polygon(cbind(
    c(-90, -80, -75, -90),
    c(30, 40, 35, 30)
  ))), "2")
  sp_poly <- SpatialPolygons(list(poly1, poly2), 1:2)
  i <- supm(map_gist(sp_poly, browse = FALSE, file = file))
  expect_s3_class(i, "gist")
  expect_type(i$url, "character")
  expect_named(i$files, basename(file))

  supm(gistr::delete(i))
})

test_that("map_gist works with data.frame inputs", {
  skip_on_cran()

  file <- withr::local_tempfile(fileext = ".geojson")

  j <- supm(map_gist(us_cities[1:50, ], browse = FALSE, file = file))
  expect_s3_class(j, "gist")

  supm(gistr::delete(j))
})

test_that("map_gist works with data.frame inputs", {
  skip_on_cran()

  file <- withr::local_tempfile(fileext = ".geojson")

  k <- supm(map_gist(c(32.45, -99.74), browse = FALSE, file = file))
  expect_s3_class(k, "gist")

  supm(gistr::delete(k))
})
