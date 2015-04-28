context("centroid")

test_that("centroid works with geo_list input", {
  # numeric input
  vec <- c(-99.74, 32.45)
  x <- geojson_list(vec)
  a <- centroid(x)
  expect_is(a, "numeric")
  expect_is(a[1], "numeric")
  expect_equal(length(a), 2)
  
  # list input
  mylist <- list(list(latitude = 30, longitude = 120, marker = "red"),
                 list(latitude = 30, longitude = 130, marker = "blue"))
  x <- suppressMessages(geojson_list(mylist))
  b <- centroid(x)
  expect_is(b, "numeric")
  expect_is(b[1], "numeric")
  expect_equal(length(b), 2)
  
  # data.frame input
  x <- suppressMessages(geojson_list(states[1:20, ]))
  c <- centroid(x)
  expect_is(c, "numeric")
  expect_is(c[1], "numeric")
  expect_equal(length(c), 2)
})
