context("map_gist")

test_that("map_gist works with file inputs", {
  skip_on_cran()
  
  tfile <- tempfile(fileext = ".geojson")
  geojson_write(us_cities[1:20, ], lat='lat', lon='long', file = tfile)
  a <- map_gist(file=as.location(tfile), browse = FALSE)
  expect_is(a, "gist")
  expect_is(a$url, "character")
  expect_named(a$files, basename(tfile))
  
  gdel(a)
})

test_that("map_gist works with geo_list inputs", {
  skip_on_cran()
  
  res <- geojson_list(us_cities[1:2,], lat='lat', lon='long')
  b <- map_gist(res, browse = FALSE)
  expect_is(res, "geo_list")
  expect_is(b, "gist")
  
  gdel(b)
})

test_that("map_gist works with json inputs", {
  skip_on_cran()
  
  x <- geojson_json(c(-99.74,32.45))
  f <- map_gist(x, browse = FALSE)
  expect_is(x, "json")
  expect_is(f, "gist")
  expect_is(f$git_pull_url, "character")
  
  gdel(f)
})

test_that("map_gist works with SpatialPoints inputs", {
  skip_on_cran()
  
  library("sp")
  a <- c(1,2,3,4,5)
  b <- c(3,2,5,1,4)
  x <- SpatialPoints(cbind(a,b))
  g <- map_gist(x, browse = FALSE)
  expect_is(g, "gist")
  expect_is(g$url, "character")
  expect_named(g$files, "myfile.geojson")
  
  gdel(g)
})

test_that("map_gist works with SpatialPointsDataFrame inputs", {
  skip_on_cran()
  
  library("sp")
  a <- c(1,2,3,4,5)
  b <- c(3,2,5,1,4)
  s <- SpatialPointsDataFrame(cbind(a, b), mtcars[1:5,])
  h <- map_gist(s, browse = FALSE)
  expect_is(h, "gist")
  expect_is(h$url, "character")
  expect_named(h$files, "myfile.geojson")
  
  gdel(h)
})

test_that("map_gist works with SpatialPolygons inputs", {
  skip_on_cran()
  
  poly1 <- Polygons(list(Polygon(cbind(c(-100,-90,-85,-100),
                                       c(40,50,45,40)))), "1")
  poly2 <- Polygons(list(Polygon(cbind(c(-90,-80,-75,-90),
                                       c(30,40,35,30)))), "2")
  sp_poly <- SpatialPolygons(list(poly1, poly2), 1:2)
  i <- map_gist(sp_poly, browse = FALSE)
  expect_is(i, "gist")
  expect_is(i$url, "character")
  expect_named(i$files, "myfile.geojson")
  
  gdel(i)
})

test_that("map_gist works with data.frame inputs", {
  skip_on_cran()
  
  j <- map_gist(us_cities[1:50,], browse = FALSE)
  expect_is(j, "gist")
  
  gdel(j)
})

test_that("map_gist works with data.frame inputs", {
  skip_on_cran()
  
  k <- map_gist(c(32.45, -99.74), browse = FALSE)
  expect_is(k, "gist")
  
  gdel(k)
})
