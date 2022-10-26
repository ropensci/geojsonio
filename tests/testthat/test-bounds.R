test_that("bounds works with geo_list input", {
  skip_on_cran()

  # geo_list with numeric data
  vec <- c(-99.74, 32.45)
  x <- geojson_list(vec)
  a <- bounds(x)
  expect_type(a, "double")
  expect_type(a[1], "double")
  expect_equal(length(a), 4)

  # geo_list with data.frame data
  x <- geojson_list(states[1:20, ], lon = "long", lat = "lat")
  b <- supm(bounds(x))
  expect_type(b, "double")
  expect_type(b[1], "double")
  expect_equal(length(b), 4)
})

test_that("bounds works with list input", {
  skip_on_cran()

  mylist <- list(
    list(latitude = 30, longitude = 120, marker = "red"),
    list(latitude = 30, longitude = 130, marker = "blue")
  )
  x <- geojson_list(mylist, lon = "longitude", lat = "latitude")
  c <- supm(bounds(x))
  expect_type(c, "double")
  expect_type(c[1], "double")
  expect_equal(length(c), 4)
})
