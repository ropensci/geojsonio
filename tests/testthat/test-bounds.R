context("bounds")

test_that("bounds works with geo_list input", {
  # geo_list with numeric data
  vec <- c(-99.74, 32.45)
  x <- geojson_list(vec)
  a <- bounds(x)
  expect_is(a, "numeric")
  expect_is(a[1], "numeric")
  expect_equal(length(a), 4)
  
  # geo_list with data.frame data
  x <- geojson_list(states[1:20, ])
  b <- suppressMessages(bounds(x))
  expect_is(b, "numeric")
  expect_is(b[1], "numeric")
  expect_equal(length(b), 4)
})

test_that("bounds works with list input", {
  mylist <- list(list(latitude = 30, longitude = 120, marker = "red"),
                 list(latitude = 30, longitude = 130, marker = "blue"))
  x <- geojson_list(mylist)
  c <- suppressMessages(bounds(x))
  expect_is(c, "numeric")
  expect_is(c[1], "numeric")
  expect_equal(length(c), 4)
})
