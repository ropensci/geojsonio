context("geojson_json")

test_that("geojson_json works with numeric inputs", {
  # From a numeric vector of length 2, making a point type
  a <- geojson_json(c(-99.74,32.45))
  expect_is(a, "json")
  expect_equal(attr(a, "type"), "FeatureCollection")
  expect_equal(attr(a, "no_features"), "1")
  expect_equal(attr(a, "five_feats"), "Point")
  a <- unclass(a)
  attributes(a) <- NULL
  expect_equal(
    a,
    "{\"type\":\"FeatureCollection\",\"features\":[{\"type\":\"Feature\",\"geometry\":{\"type\":\"Point\",\"coordinates\":[-99.74,32.45]},\"properties\":{}}]}"
  )
  expect_is(unclass(a), "character")
  expect_equal(jsonlite::fromJSON(a)$type, "FeatureCollection")

  aa <- unclass(geojson_json(c(-99.74,32.45), type = "GeometryCollection"))
  aa <- unclass(aa)
  attributes(aa) <- NULL
  expect_equal(
    aa,
    "{\"type\":\"GeometryCollection\",\"geometries\":[{\"type\":\"Point\",\"coordinates\":[-99.74,32.45]}]}"
  )

  ## polygon type
  poly <- c(c(-114.345703125,39.436192999314095),
            c(-114.345703125,43.45291889355468),
            c(-106.61132812499999,43.45291889355468),
            c(-106.61132812499999,39.436192999314095),
            c(-114.345703125,39.436192999314095))
  bb <- unclass(geojson_json(poly, geometry = "polygon"))
  bb <- unclass(bb)
  attributes(bb) <- NULL
  expect_equal(
    bb,
    "{\"type\":\"FeatureCollection\",\"features\":[{\"type\":\"Feature\",\"geometry\":{\"type\":\"Polygon\",\"coordinates\":[[[-114.3457031,39.436193],[-114.3457031,43.4529189],[-106.6113281,43.4529189],[-106.6113281,39.436193],[-114.3457031,39.436193]]]},\"properties\":{}}]}"
  )
})

test_that("geojson_json works with data.frame inputs", {
  # From a data.frame to points
  bb <- geojson_json(us_cities[1:2,], lat='lat', lon='long')
  bb <- unclass(bb)
  attributes(bb) <- NULL
  expect_equal(
    bb,
    "{\"type\":\"FeatureCollection\",\"features\":[{\"type\":\"Feature\",\"geometry\":{\"type\":\"Point\",\"coordinates\":[-99.74,32.45]},\"properties\":{\"name\":\"Abilene TX\",\"country.etc\":\"TX\",\"pop\":\"113888\",\"capital\":\"0\"}},{\"type\":\"Feature\",\"geometry\":{\"type\":\"Point\",\"coordinates\":[-81.52,41.08]},\"properties\":{\"name\":\"Akron OH\",\"country.etc\":\"OH\",\"pop\":\"206634\",\"capital\":\"0\"}}]}"
  )

  # from data.frame to polygons
  aa <- unclass(geojson_json(states[1:351, ], lat='lat', lon='long', geometry="polygon", group='group'))
  attributes(aa) <- NULL
  expect_equal_to_reference(object=aa, file="numericstates.rds")
})

test_that("geojson_json works with data.frame inputs", {
  # from a list
  mylist <- list(list(latitude=30, longitude=120, marker="red"),
                 list(latitude=30, longitude=130, marker="blue"))
  bb <- geojson_json(mylist, lat='latitude', lon='longitude')
  bb <- unclass(bb)
  attributes(bb) <- NULL
  expect_equal(
    bb,
    "{\"type\":\"FeatureCollection\",\"features\":[{\"type\":\"Feature\",\"geometry\":{\"type\":\"Point\",\"coordinates\":[120,30]},\"properties\":{\"marker\":\"red\"}},{\"type\":\"Feature\",\"geometry\":{\"type\":\"Point\",\"coordinates\":[130,30]},\"properties\":{\"marker\":\"blue\"}}]}"
  )

  # from a geo_list
  a <- geojson_list(us_cities[1:2,], lat='lat', lon='long')
  a <- unclass(geojson_json(a))
  attributes(a) <- NULL
  expect_equal(
    a,
    "{\"type\":\"FeatureCollection\",\"features\":[{\"type\":\"Feature\",\"geometry\":{\"type\":\"Point\",\"coordinates\":[-99.74,32.45]},\"properties\":{\"name\":\"Abilene TX\",\"country.etc\":\"TX\",\"pop\":\"113888\",\"capital\":\"0\"}},{\"type\":\"Feature\",\"geometry\":{\"type\":\"Point\",\"coordinates\":[-81.52,41.08]},\"properties\":{\"name\":\"Akron OH\",\"country.etc\":\"OH\",\"pop\":\"206634\",\"capital\":\"0\"}}]}"
  )
})

test_that("geojson_json detects inproper polygons passed as lists inputs", {
  good <- list(c(100.0,0.0), c(101.0,0.0), c(101.0,1.0), c(100.0,1.0), c(100.0,0.0))
  bad <- list(c(100.0,0.0), c(101.0,0.0), c(101.0,1.0), c(100.0,1.0), c(100.0,1))

  # fine
  fine <- geojson_json(good, geometry = "polygon")
  expect_is(fine, "json")

  # bad
  expect_error(geojson_json(bad, geometry = "polygon"),
               "First and last point in a polygon must be identical")

  # doesn't matter if geometry != polygon
  expect_is(geojson_json(bad), "json")
})

test_that("geojson_json - acceptable type values for numeric/data.frame/list", {
  expect_error(geojson_json(c(-99.74,32.45), type = "LineString"),
    "'type' must be one of")

  vecs <- list(c(100.0,0.0), c(101.0,0.0), c(101.0,1.0), c(100.0,1.0), c(100.0,0.0))
  expect_error(geojson_json(vecs, geometry="polygon", type = "LineString"),
    "'type' must be one of")

  expect_error(geojson_json(us_cities[1:2,], type = "LineString"),
    "'type' must be one of")
})
