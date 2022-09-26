test_that("construction for geo_list + geo_list works as expected", {
  skip_on_cran()

  vec <- c(-99.74, 32.45)
  a <- geojson_list(vec)
  vecs <- list(c(100.0, 0.0), c(101.0, 0.0), c(101.0, 1.0), c(100.0, 1.0), c(100.0, 0.0))
  b <- geojson_list(vecs, geometry = "polygon")
  ab <- a + b

  expect_s3_class(a, "geo_list")
  expect_s3_class(b, "geo_list")
  expect_s3_class(ab, "geo_list")
  expect_equal(
    as.character(jsonlite::toJSON(unclass(ab))),
    "{\"type\":[\"FeatureCollection\"],\"features\":[{\"type\":[\"Feature\"],\"geometry\":{\"type\":[\"Point\"],\"coordinates\":[-99.74,32.45]},\"properties\":{}},{\"type\":[\"Feature\"],\"geometry\":{\"type\":[\"Polygon\"],\"coordinates\":[[[100,0],[101,0],[101,1],[100,1],[100,0]]]},\"properties\":[]}]}"
  )
})

test_that("construction for json + json works as expected", {
  skip_on_cran()

  c <- geojson_json(c(-99.74, 32.45))
  vecs <- list(c(100.0, 0.0), c(101.0, 0.0), c(101.0, 1.0), c(100.0, 1.0), c(100.0, 0.0))
  d <- geojson_json(vecs, geometry = "polygon")
  cd <- c + d

  expect_s3_class(c, "json")
  expect_s3_class(d, "json")
  expect_s3_class(cd, "json")
  expect_equal(
    as.character(cd),
    "{\"type\":\"FeatureCollection\",\"features\":[{\"type\":\"Feature\",\"geometry\":{\"type\":\"Point\",\"coordinates\":[-99.74,32.45]},\"properties\":{}},{\"type\":\"Feature\",\"geometry\":{\"type\":\"Polygon\",\"coordinates\":[[[100,0],[101,0],[101,1],[100,1],[100,0]]]},\"properties\":[]}]}"
  )
})
