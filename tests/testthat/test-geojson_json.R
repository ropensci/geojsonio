context("geojson_json")

test_that("geojson_json works with numeric inputs", {
  # From a numeric vector of length 2, making a point type
  a <- geojson_json(c(-99.74,32.45))
  expect_is(a, "json")
  expect_equal(
    unclass(a),
    "{\"type\":\"FeatureCollection\",\"features\":[{\"type\":\"Feature\",\"geometry\":{\"type\":\"Point\",\"coordinates\":[-99.74,32.45]},\"properties\":{}}]}"
  )
  expect_is(unclass(a), "character")
  expect_equal(jsonlite::fromJSON(a)$type, "FeatureCollection")

  expect_equal(
    unclass(geojson_json(c(-99.74,32.45), type = "GeometryCollection")),
    "{\"type\":\"GeometryCollection\",\"geometries\":[{\"type\":\"Point\",\"coordinates\":[-99.74,32.45]}]}"
  )

  ## polygon type
  poly <- c(c(-114.345703125,39.436192999314095),
            c(-114.345703125,43.45291889355468),
            c(-106.61132812499999,43.45291889355468),
            c(-106.61132812499999,39.436192999314095),
            c(-114.345703125,39.436192999314095))
  expect_equal(
    unclass(geojson_json(poly, geometry = "polygon")),
    "{\"type\":\"FeatureCollection\",\"features\":[{\"type\":\"Feature\",\"geometry\":{\"type\":\"Polygon\",\"coordinates\":[[[-114.345703125,39.4361929993141],[-114.345703125,43.4529188935547],[-106.611328125,43.4529188935547],[-106.611328125,39.4361929993141],[-114.345703125,39.4361929993141]]]},\"properties\":{}}]}"
  )
})

test_that("geojson_json works with data.frame inputs", {
  # From a data.frame to points
  expect_equal(
    unclass(geojson_json(us_cities[1:2,], lat='lat', lon='long')),
    "{\"type\":\"FeatureCollection\",\"features\":[{\"type\":\"Feature\",\"geometry\":{\"type\":\"Point\",\"coordinates\":[-99.74,32.45]},\"properties\":{\"name\":\"Abilene TX\",\"country.etc\":\"TX\",\"pop\":\"113888\",\"capital\":\"0\"}},{\"type\":\"Feature\",\"geometry\":{\"type\":\"Point\",\"coordinates\":[-81.52,41.08]},\"properties\":{\"name\":\"Akron OH\",\"country.etc\":\"OH\",\"pop\":\"206634\",\"capital\":\"0\"}}]}"
  )

  # from data.frame to polygons
  head(states)
  expect_equal_to_reference(
    object=unclass(geojson_json(states[1:351, ], lat='lat', lon='long', geometry="polygon", group='group')),
    file="numericstates.rds"
  )
})

test_that("geojson_json works with data.frame inputs", {
  # from a list
  mylist <- list(list(latitude=30, longitude=120, marker="red"),
                 list(latitude=30, longitude=130, marker="blue"))
  expect_equal(
    unclass(geojson_json(mylist, lat='latitude', lon='longitude')),
    "{\"type\":\"FeatureCollection\",\"features\":[{\"type\":\"Feature\",\"geometry\":{\"type\":\"Point\",\"coordinates\":[120,30]},\"properties\":{\"marker\":\"red\"}},{\"type\":\"Feature\",\"geometry\":{\"type\":\"Point\",\"coordinates\":[130,30]},\"properties\":{\"marker\":\"blue\"}}]}"
  )

  # from a geo_list
  a <- geojson_list(us_cities[1:2,], lat='lat', lon='long')
  expect_equal(
    unclass(geojson_json(a)),
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
