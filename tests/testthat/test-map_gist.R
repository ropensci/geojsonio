skip_if_not(Sys.getenv("GITHUB_PAT") != "")
skip_on_ci()
skip_on_cran()

test_that("map_gist works with file inputs", {
  skip_on_cran()

  file <- local_gist_temp_file()
  supm(geojson_write(us_cities[1:20, ], lat = "lat", lon = "long", file = file))
  g <- temp_map_gist(file = as.location(file), browse = FALSE)

  expect_s3_class(g, "gist")
  expect_type(g$url, "character")
  expect_named(g$files, basename(file))
})

test_that("map_gist works with geo_list inputs", {
  skip_on_cran()

  file <- local_gist_temp_file()

  res <- geojson_list(us_cities[1:2, ], lat = "lat", lon = "long")
  g <- temp_map_gist(res, browse = FALSE, file = file)

  expect_s3_class(res, "geo_list")
  expect_s3_class(g, "gist")
})

test_that("map_gist works with json inputs", {
  skip_on_cran()

  file <- local_gist_temp_file()

  x <- geojson_json(c(-99.74, 32.45))
  g <- temp_map_gist(x, browse = FALSE, file = file)

  expect_s3_class(x, "json")
  expect_s3_class(g, "gist")
  expect_type(g$git_pull_url, "character")
})

test_that("map_gist works with SpatialPoints inputs", {
  skip_on_cran()

  file <- local_gist_temp_file()

  a <- c(1, 2, 3, 4, 5)
  b <- c(3, 2, 5, 1, 4)
  x <- SpatialPoints(cbind(a, b))
  g <- temp_map_gist(x, browse = FALSE, file = file)

  expect_s3_class(g, "gist")
  expect_type(g$url, "character")
  expect_named(g$files, basename(file))
})

test_that("map_gist works with SpatialPointsDataFrame inputs", {
  skip_on_cran()

  file <- local_gist_temp_file()

  a <- c(1, 2, 3, 4, 5)
  b <- c(3, 2, 5, 1, 4)
  s <- SpatialPointsDataFrame(cbind(a, b), mtcars[1:5, ])
  g <- temp_map_gist(s, browse = FALSE, file = file)

  expect_s3_class(g, "gist")
  expect_type(g$url, "character")
  expect_named(g$files, basename(file))
})

test_that("map_gist works with SpatialPolygons inputs", {
  skip_on_cran()

  file <- local_gist_temp_file()

  poly1 <- Polygons(list(Polygon(cbind(
    c(-100, -90, -85, -100),
    c(40, 50, 45, 40)
  ))), "1")
  poly2 <- Polygons(list(Polygon(cbind(
    c(-90, -80, -75, -90),
    c(30, 40, 35, 30)
  ))), "2")
  sp_poly <- SpatialPolygons(list(poly1, poly2), 1:2)
  g <- temp_map_gist(sp_poly, browse = FALSE, file = file)

  expect_s3_class(g, "gist")
  expect_type(g$url, "character")
  expect_named(g$files, basename(file))
})

test_that("map_gist works with data.frame inputs", {
  skip_on_cran()

  file <- local_gist_temp_file()
  g <- temp_map_gist(us_cities[1:50, ], browse = FALSE, file = file)
  expect_s3_class(g, "gist")
})

test_that("map_gist works with data.frame inputs", {
  skip_on_cran()

  file <- local_gist_temp_file()
  g <- temp_map_gist(c(32.45, -99.74), browse = FALSE, file = file)
  expect_s3_class(g, "gist")
})
