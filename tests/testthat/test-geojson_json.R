test_that("geojson_json works with numeric inputs", {
  skip_on_cran()

  # From a numeric vector of length 2, making a point type
  a <- geojson_json(c(-99.74, 32.45))
  expect_s3_class(a, "json")
  expect_equal(attr(a, "type"), "FeatureCollection")
  expect_equal(attr(a, "no_features"), "1")
  expect_equal(attr(a, "five_feats"), "Point")
  a <- unclass(a)
  attributes(a) <- NULL
  expect_equal(
    a,
    "{\"type\":\"FeatureCollection\",\"features\":[{\"type\":\"Feature\",\"geometry\":{\"type\":\"Point\",\"coordinates\":[-99.74,32.45]},\"properties\":{}}]}"
  )
  expect_type(unclass(a), "character")
  expect_equal(jsonlite::fromJSON(a)$type, "FeatureCollection")

  aa <- unclass(geojson_json(c(-99.74, 32.45), type = "GeometryCollection"))
  aa <- unclass(aa)
  attributes(aa) <- NULL
  expect_equal(
    aa,
    "{\"type\":\"GeometryCollection\",\"geometries\":[{\"type\":\"Point\",\"coordinates\":[-99.74,32.45]}]}"
  )

  ## polygon type
  poly <- c(
    c(-114.345703125, 39.436192999314095),
    c(-114.345703125, 43.45291889355468),
    c(-106.61132812499999, 43.45291889355468),
    c(-106.61132812499999, 39.436192999314095),
    c(-114.345703125, 39.436192999314095)
  )
  bb <- unclass(geojson_json(poly, geometry = "polygon"))
  bb <- unclass(bb)
  attributes(bb) <- NULL
  expect_equal(
    bb,
    "{\"type\":\"FeatureCollection\",\"features\":[{\"type\":\"Feature\",\"geometry\":{\"type\":\"Polygon\",\"coordinates\":[[[-114.3457031,39.436193],[-114.3457031,43.4529189],[-106.6113281,43.4529189],[-106.6113281,39.436193],[-114.3457031,39.436193]]]},\"properties\":{}}]}"
  )
})

test_that("geojson_json works with data.frame inputs", {
  skip_on_cran()

  # From a data.frame to points
  bb <- geojson_json(us_cities[1:2, ], lat = "lat", lon = "long")
  bb <- unclass(bb)
  attributes(bb) <- NULL
  expect_equal(
    bb,
    "{\"type\":\"FeatureCollection\",\"features\":[{\"type\":\"Feature\",\"geometry\":{\"type\":\"Point\",\"coordinates\":[-99.74,32.45]},\"properties\":{\"name\":\"Abilene TX\",\"country.etc\":\"TX\",\"pop\":\"113888\",\"capital\":\"0\"}},{\"type\":\"Feature\",\"geometry\":{\"type\":\"Point\",\"coordinates\":[-81.52,41.08]},\"properties\":{\"name\":\"Akron OH\",\"country.etc\":\"OH\",\"pop\":\"206634\",\"capital\":\"0\"}}]}"
  )

  # from data.frame to polygons
  aa <- unclass(geojson_json(states[1:351, ], lat = "lat", lon = "long", geometry = "polygon", group = "group"))
  attributes(aa) <- NULL
  expect_snapshot_value(aa, style = "json2")
})

test_that("geojson_json works with data.frame inputs", {
  skip_on_cran()

  # from a list
  mylist <- list(
    list(latitude = 30, longitude = 120, marker = "red"),
    list(latitude = 30, longitude = 130, marker = "blue")
  )
  bb <- geojson_json(mylist, lat = "latitude", lon = "longitude")
  bb <- unclass(bb)
  attributes(bb) <- NULL
  expect_equal(
    bb,
    "{\"type\":\"FeatureCollection\",\"features\":[{\"type\":\"Feature\",\"geometry\":{\"type\":\"Point\",\"coordinates\":[120,30]},\"properties\":{\"marker\":\"red\"}},{\"type\":\"Feature\",\"geometry\":{\"type\":\"Point\",\"coordinates\":[130,30]},\"properties\":{\"marker\":\"blue\"}}]}"
  )

  # from a geo_list
  a <- geojson_list(us_cities[1:2, ], lat = "lat", lon = "long")
  a <- unclass(geojson_json(a))
  attributes(a) <- NULL
  expect_equal(
    a,
    "{\"type\":\"FeatureCollection\",\"features\":[{\"type\":\"Feature\",\"geometry\":{\"type\":\"Point\",\"coordinates\":[-99.74,32.45]},\"properties\":{\"name\":\"Abilene TX\",\"country.etc\":\"TX\",\"pop\":\"113888\",\"capital\":\"0\"}},{\"type\":\"Feature\",\"geometry\":{\"type\":\"Point\",\"coordinates\":[-81.52,41.08]},\"properties\":{\"name\":\"Akron OH\",\"country.etc\":\"OH\",\"pop\":\"206634\",\"capital\":\"0\"}}]}"
  )
})

test_that("geojson_json detects inproper polygons passed as lists inputs", {
  skip_on_cran()

  good <- list(c(100.0, 0.0), c(101.0, 0.0), c(101.0, 1.0), c(100.0, 1.0), c(100.0, 0.0))
  bad <- list(c(100.0, 0.0), c(101.0, 0.0), c(101.0, 1.0), c(100.0, 1.0), c(100.0, 1))

  # fine
  fine <- geojson_json(good, geometry = "polygon")
  expect_s3_class(fine, "json")

  # bad
  expect_error(
    geojson_json(bad, geometry = "polygon"),
    "First and last point in a polygon must be identical"
  )

  # doesn't matter if geometry != polygon
  expect_s3_class(geojson_json(bad), "json")
})

test_that("geojson_json - acceptable type values for numeric/data.frame/list", {
  skip_on_cran()

  expect_error(
    geojson_json(c(-99.74, 32.45), type = "LineString"),
    "'type' must be one of"
  )

  vecs <- list(c(100.0, 0.0), c(101.0, 0.0), c(101.0, 1.0), c(100.0, 1.0), c(100.0, 0.0))
  expect_error(
    geojson_json(vecs, geometry = "polygon", type = "LineString"),
    "'type' must be one of"
  )

  expect_error(
    geojson_json(us_cities[1:2, ], type = "LineString"),
    "'type' must be one of"
  )
})

test_that("skipping geoclass in geojson_json works with type = skip", {
  skip_on_cran()

  x <- geojson_sp(geojson_json(c(-99.74, 32.45)))
  expect_match(attr(geojson_json(x), "type"), "FeatureCollection")
  expect_null(attr(geojson_json(x, type = "skip"), "type"))
})

test_that("geojson_json precision", {
  skip_on_cran()

  withr::local_options(digits = 15)

  # numeric
  x <- geojson_json(c(-99.123456789, 32.12345678), precision = 10)
  expect_equal(num_digits(x), c(9, 8))

  # list
  vecs <- list(c(100.1, 0.1), c(101.01, 0.012), c(101.12345678, 1.1), c(100, 1), c(100.123456, 0))
  x <- geojson_json(vecs, precision = 10)
  expect_equal(num_digits(x), c(1, 1, 2, 3, 8, 1, 0, 0, 6, 0))

  # data.frame
  df <- data.frame(
    lat = c(45.123, 48.12), lon = c(-122, -122.1234567),
    city = c("Portland", "Seattle")
  )
  x <- geojson_json(df, lat = "lat", lon = "lon", precision = 3)
  expect_equal(num_digits(x), c(0, 3, 3, 2))
  x <- geojson_json(df, lat = "lat", lon = "lon", precision = 7)
  expect_equal(num_digits(x), c(0, 3, 7, 2))

  # from geojson_list output
  a <- geojson_list(df, precision = 5, lat = "lat", lon = "lon")
  x <- geojson_json(a, precision = 5)
  expect_equal(num_digits(x), c(0, 3, 5, 2))
})

test_that("geojson_json precision for sp classes", {
  skip_on_cran()
  withr::local_options(digits = 15)
  
  poly1 <- Polygons(list(Polygon(cbind(
    c(-100.1, -90.12, -85.123, -100.1234),
    c(40, 50, 45, 40)
  ))), "1")
  poly2 <- Polygons(list(Polygon(cbind(
    c(-90, -80, -75, -90),
    c(30, 40, 35, 30)
  ))), "2")
  sp_poly <- SpatialPolygons(list(poly1, poly2), 1:2)
  expect_equal(
    num_digits(geojson_json(sp_poly)),
    c(1, 2, 3, 4, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0)
  )
  expect_equal(
    num_digits(geojson_json(sp_poly, precision = 2)),
    c(1, 2, 2, 2, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0)
  )
})

test_that("geojson_json precision for sf classes", {
  skip_on_cran()
  skip_if_not_installed("sf")

  withr::local_options(digits = 15)

  p1 <- rbind(c(0, 0), c(1, 0), c(3, 2), c(2, 4), c(1, 4.1234567), c(0, 0))
  p2 <- rbind(c(5.123, 5.1), c(5, 6), c(4, 5), c(5.123, 5.1))
  poly_sfc <- sf::st_sfc(sf::st_polygon(list(p1)), sf::st_polygon(list(p2)))
  expect_equal(
    num_digits(geojson_json(poly_sfc)),
    c(0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 7, 0, 3, 0, 0, 3, 1, 0, 0, 1)
  )
  expect_equal(
    num_digits(geojson_json(poly_sfc, precision = 2)),
    c(0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 7, 0, 3, 0, 0, 3, 1, 0, 0, 1)
  )
})
