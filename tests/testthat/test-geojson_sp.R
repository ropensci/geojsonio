context("geojson_sp")

test_that("geojson_sp works with geo_list inputs", {
  skip_on_cran()

  # numeric vector of length 2, making a point type
  vec <- c(-99.74,32.45)
  a <- geojson_sp(geojson_list(vec))
  expect_is(a, "SpatialPointsDataFrame")
  
  # from a list to a data.frame
  mylist <- list(list(latitude=30, longitude=120, marker="red"),
                 list(latitude=30, longitude=130, marker="blue"))
  b <- geojson_sp(suppressMessages(geojson_list(mylist)))
  expect_is(b, "SpatialPointsDataFrame")
  
  # from a list of numeric vectors to a polygon
  # vecs <- list(c(100.0,0.0), c(101.0,0.0), c(101.0,1.0), c(100.0,1.0), c(100.0,0.0))
  # d <- geojson_sp(geojson_list(vecs, geometry="polygon"))
  # expect_is(d, "SpatialPolygonsDataFrame")
})

test_that("geojson_sp works with string inputs", {
  skip_on_cran()

  x <- unclass(geojson_json(c(-99.74,32.45)))
  a <- geojson_sp(x)
  expect_is(a, "Spatial")
})

test_that("geojson_sp works with json inputs", {
  skip_on_cran()
  
  # numeric vector of length 2, making a point type
  vec <- c(-99.74,32.45)
  a <- geojson_sp(geojson_json(vec))
  expect_is(a, "SpatialPointsDataFrame")
  
  # from a list to a data.frame
  mylist <- list(list(latitude=30, longitude=120, marker="red"),
                 list(latitude=30, longitude=130, marker="blue"))
  b <- geojson_sp(suppressMessages(geojson_json(mylist)))
  expect_is(b, "SpatialPointsDataFrame")
  
  # from a polygon
  poly <- structure('{"type":"FeatureCollection","features":[{
"type": "Feature",
"properties": {},
"geometry": {
"type": "Polygon",
"coordinates": [
[
[53, -42],
[57, -42],
[57, -47],
[53, -47],
[53, -42]
]
]
}}]
}', class = c("json", "geo_json"))
  d <- geojson_sp(poly)
  # expect_is(d, "SpatialPolygonsDataFrame")  
})
