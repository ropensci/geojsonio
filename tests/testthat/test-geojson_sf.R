test_that("geojson_sf works with geo_list inputs", {
  skip_on_cran()

  # numeric vector of length 2, making a point type
  vec <- c(-99.74, 32.45)
  a <- geojson_sf(geojson_list(vec))
  expect_s3_class(a, "sf")

  # from a list to a data.frame
  mylist <- list(
    list(latitude = 30, longitude = 120, marker = "red"),
    list(latitude = 30, longitude = 130, marker = "blue")
  )
  b <- geojson_sf(suppressMessages(geojson_list(mylist)))
  expect_s3_class(b, "sf")

  # from a list of numeric vectors to a polygon
  # vecs <- list(c(100.0,0.0), c(101.0,0.0), c(101.0,1.0), c(100.0,1.0), c(100.0,0.0))
  # d <- geojson_sf(geojson_list(vecs, geometry="polygon"))
  # expect_s4_class(d, "SpatialPolygonsDataFrame")
})

test_that("geojson_sf works with string inputs", {
  skip_on_cran()

  x <- unclass(geojson_json(c(-99.74, 32.45)))
  a <- geojson_sf(x)
  expect_s3_class(a, "sf")
})

test_that("geojson_sf works with json inputs", {
  skip_on_cran()

  # numeric vector of length 2, making a point type
  vec <- c(-99.74, 32.45)
  a <- geojson_sf(geojson_json(vec))
  expect_s3_class(a, "sf")

  # from a list to a data.frame
  mylist <- list(
    list(latitude = 30, longitude = 120, marker = "red"),
    list(latitude = 30, longitude = 130, marker = "blue")
  )
  b <- geojson_sf(suppressMessages(geojson_json(mylist)))
  expect_s3_class(b, "sf")

  # from a polygon
  poly <- structure('{
    "type":"FeatureCollection",
    "features":[{
      "type": "Feature",
      "properties": {},
      "geometry": {
        "type": "Polygon",
        "coordinates": [[[53, -42],[57, -42],[57, -47],[53, -47],[53, -42]]]
      }
    }]
  }', class = c("json", "geo_json"))
  d <- geojson_sf(poly)
  expect_s3_class(d, "sf")
})
