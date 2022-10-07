test_that("centroid works with geo_list input", {
  skip_on_cran()

  # numeric input
  vec <- c(-99.74, 32.45)
  x <- geojson_list(vec)
  a <- centroid(x)
  expect_type(a, "double")
  expect_type(a[1], "double")
  expect_equal(length(a), 2)

  # list input
  mylist <- list(
    list(latitude = 30, longitude = 120, marker = "red"),
    list(latitude = 30, longitude = 130, marker = "blue")
  )
  x <- supm(geojson_list(mylist))
  b <- centroid(x)
  expect_type(b, "double")
  expect_type(b[1], "double")
  expect_equal(length(b), 2)

  # data.frame input
  x <- supm(geojson_list(states[1:20, ]))
  c <- centroid(x)
  expect_type(c, "double")
  expect_type(c[1], "double")
  expect_equal(length(c), 2)
})
