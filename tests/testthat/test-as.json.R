test_that("as.json works with geo_list class inputs", {
  skip_on_cran()

  # From a numeric vector of length 2, making a point type
  a <- geojson_list(c(-99.74, 32.45))
  expect_s3_class(as.json(a), "json")
  expect_type(unclass(a), "list")
  expect_equal(
    unclass(as.json(a)),
    "{\"type\":\"FeatureCollection\",\"features\":[{\"type\":\"Feature\",\"geometry\":{\"type\":\"Point\",\"coordinates\":[-99.74,32.45]},\"properties\":{}}]}"
  )

  b <- geojson_list(c(-99.74, 32.45), type = "GeometryCollection")
  expect_equal(
    unclass(as.json(b)),
    "{\"type\":\"GeometryCollection\",\"geometries\":[{\"type\":\"Point\",\"coordinates\":[-99.74,32.45]}]}"
  )
})

test_that("as.json works with data.frame class inputs", {
  skip_on_cran()

  tf1 <- withr::local_tempfile(fileext = ".geojson")
  cc <- supm(
    geojson_write(us_cities[1:2, ], lat = "lat", lon = "long", file = tf1)
  )
  expect_s3_class(cc, "geojson_file")
  expect_type(unclass(cc), "list")
  expect_s3_class(as.json(cc), "json")
  expect_equal(
    unclass(jqr::jq(unclass(as.json(cc)), "del(.name) | del(.crs)")),
    "{\"type\":\"FeatureCollection\",\"features\":[{\"type\":\"Feature\",\"properties\":{\"name\":\"Abilene TX\",\"country.etc\":\"TX\",\"pop\":113888,\"lat\":32.45,\"long\":-99.74,\"capital\":0},\"geometry\":{\"type\":\"Point\",\"coordinates\":[-99.74,32.45]}},{\"type\":\"Feature\",\"properties\":{\"name\":\"Akron OH\",\"country.etc\":\"OH\",\"pop\":206634,\"lat\":41.08,\"long\":-81.52,\"capital\":0},\"geometry\":{\"type\":\"Point\",\"coordinates\":[-81.52,41.08]}}]}"
  )

  tf11 <- withr::local_tempfile(fileext = ".geojson")
  d <- supw(supm(geojson_write(
    input = states, lat = "lat", lon = "long",
    geometry = "polygon", group = "group", file = tf11
  )))
  expect_s3_class(d, "geojson_file")
  expect_type(unclass(d), "list")
  expect_s3_class(supw(as.json(d)), "json")
})


test_that("as.json works with geojson class inputs", {
  skip_on_cran()

  poly1 <- Polygons(list(Polygon(cbind(
    c(-100, -90, -85, -100),
    c(40, 50, 45, 40)
  ))), "1")
  poly2 <- Polygons(list(Polygon(cbind(
    c(-90, -80, -75, -90),
    c(30, 40, 35, 30)
  ))), "2")
  sp_poly <- SpatialPolygons(list(poly1, poly2), 1:2)
  tf2 <- withr::local_tempfile(fileext = ".geojson")
  e <- supm(geojson_write(sp_poly, file = tf2))
  expect_s3_class(e, "geojson_file")
  expect_type(unclass(e), "list")
  expect_s3_class(as.json(e), "json")
  expect_equal(
    unclass(jqr::jq(unclass(as.json(e)), "del(.name) | del(.crs)")),
    "{\"type\":\"FeatureCollection\",\"features\":[{\"type\":\"Feature\",\"properties\":{\"dummy\":0},\"geometry\":{\"type\":\"Polygon\",\"coordinates\":[[[-100,40],[-90,50],[-85,45],[-100,40]]]}},{\"type\":\"Feature\",\"properties\":{\"dummy\":0},\"geometry\":{\"type\":\"Polygon\",\"coordinates\":[[[-90,30],[-80,40],[-75,35],[-90,30]]]}}]}"
  )
})

test_that("as.json works with topojson list inputs", {
  skip_on_cran()

  z <- SpatialPolygonsDataFrame(
    SpatialPolygons(list(
      Polygons(list(
        Polygon(cbind(x = c(2, 2, 3, 2), y = c(2, 3, 2, 2))),
        Polygon(cbind(x = c(1, 2, 2, 1), y = c(4, 4, 5, 4)))
      ), ID = 1)
    )),
    data = data.frame(a = 1)
  )
  x <- topojson_list(z)
  expect_type(x, "list")
  xjs <- as.json(x)
  expect_s3_class(xjs, "json")
  expect_equal(
    unclass(jqr::jq(unclass(xjs), "del(.name) | del(.crs)")),
    "{\"type\":\"Topology\",\"objects\":{\"foo\":{\"type\":\"GeometryCollection\",\"geometries\":[{\"type\":\"Polygon\",\"arcs\":[[0],[1]],\"properties\":{\"a\":1}}]}},\"arcs\":[[[2,2],[2,3],[3,2],[2,2]],[[1,4],[2,4],[2,5],[1,4]]],\"bbox\":[1,2,3,5]}"
  )
})

test_that("as.json works with file name inputs", {
  skip_on_cran()

  tf3 <- withr::local_tempfile(fileext = ".geojson")
  ee <- supm(
    geojson_write(us_cities[1:2, ], lat = "lat", lon = "long", file = tf3)
  )
  expect_s3_class(ee, "geojson_file")
  expect_type(unclass(ee), "list")
  expect_type(ee$path, "character")
  expect_s3_class(as.json(ee$path), "json")
  expect_equal(
    unclass(jqr::jq(unclass(as.json(ee)), "del(.name) | del(.crs)")),
    "{\"type\":\"FeatureCollection\",\"features\":[{\"type\":\"Feature\",\"properties\":{\"name\":\"Abilene TX\",\"country.etc\":\"TX\",\"pop\":113888,\"lat\":32.45,\"long\":-99.74,\"capital\":0},\"geometry\":{\"type\":\"Point\",\"coordinates\":[-99.74,32.45]}},{\"type\":\"Feature\",\"properties\":{\"name\":\"Akron OH\",\"country.etc\":\"OH\",\"pop\":206634,\"lat\":41.08,\"long\":-81.52,\"capital\":0},\"geometry\":{\"type\":\"Point\",\"coordinates\":[-81.52,41.08]}}]}"
  )
})
