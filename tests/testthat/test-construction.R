context("construction")

test_that("construction for geo_list + geo_list works as expected", {
  vec <- c(-99.74,32.45)
  a <- geojson_list(vec)
  vecs <- list(c(100.0,0.0), c(101.0,0.0), c(101.0,1.0), c(100.0,1.0), c(100.0,0.0))
  b <- geojson_list(vecs, geometry="polygon")
  ab <- a + b
  
  expect_is(a, "geo_list")
  expect_is(b, "geo_list")
  expect_is(ab, "geo_list")
  expect_equal(as.character(jsonlite::toJSON(unclass(ab))), 
               "{\"type\":[\"FeatureCollection\"],\"features\":[{\"type\":[\"Feature\"],\"geometry\":{\"type\":[\"Point\"],\"coordinates\":[-99.74,32.45]},\"properties\":{}},{\"type\":[\"Feature\"],\"geometry\":{\"type\":[\"Polygon\"],\"coordinates\":[[[100,0],[101,0],[101,1],[100,1],[100,0]]]},\"properties\":[]}]}"
  )
})
  
test_that("construction for json + json works as expected", {
  c <- geojson_json(c(-99.74,32.45))
  vecs <- list(c(100.0,0.0), c(101.0,0.0), c(101.0,1.0), c(100.0,1.0), c(100.0,0.0))
  d <- geojson_json(vecs, geometry="polygon")
  cd <- c + d
  
  expect_is(c, "json")
  expect_is(d, "json")
  expect_is(cd, "json")
  expect_equal(as.character(cd), 
               "{\"type\":\"FeatureCollection\",\"features\":[{\"type\":\"Feature\",\"geometry\":{\"type\":\"Point\",\"coordinates\":[-99.74,32.45]},\"properties\":{}},{\"type\":\"Feature\",\"geometry\":{\"type\":\"Polygon\",\"coordinates\":[[[100,0],[101,0],[101,1],[100,1],[100,0]]]},\"properties\":[]}]}"
  )
})
