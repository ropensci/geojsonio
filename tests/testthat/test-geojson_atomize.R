test_that("geojson_atomize works with list inputs", {
  skip_on_cran()

  mylist <- list(
    list(latitude = 30, longitude = 120, marker = "red"),
    list(latitude = 30, longitude = 130, marker = "blue")
  )
  lst <- geojson_list(mylist)
  aa <- geojson_atomize(lst)

  expect_type(aa, "list")
  # outputs are features
  expect_equal(vapply(aa, "[[", "", "type"), rep("Feature", 2))
})

test_that("geojson_atomize works with geo_json inputs", {
  skip_on_cran()

  mylist <- list(
    list(latitude = 30, longitude = 120, marker = "red"),
    list(latitude = 30, longitude = 130, marker = "blue")
  )
  js <- geojson_json(mylist)
  aa <- geojson_atomize(js)
  aajs <- jsonlite::fromJSON(aa, FALSE)

  expect_s3_class(aa, "json")
  # outputs are features
  expect_equal(vapply(aajs, "[[", "", "type"), rep("Feature", 2))
})

test_that("geojson_atomize works with character inputs", {
  skip_on_cran()

  mylist <- list(
    list(latitude = 30, longitude = 120, marker = "red"),
    list(latitude = 30, longitude = 130, marker = "blue")
  )
  js <- geojson_json(mylist)
  jsc <- unclass(js)
  aa <- geojson_atomize(jsc)
  aajs <- jsonlite::fromJSON(aa, FALSE)

  expect_s3_class(aa, "json")
  # outputs are features
  expect_equal(vapply(aajs, "[[", "", "type"), rep("Feature", 2))
})

test_that("geojson_atomize fails well", {
  skip_on_cran()
  expect_error(geojson_atomize(), "argument \"x\" is missing")
  expect_error(geojson_atomize(5), "no 'geojson_atomize' method")
  expect_error(geojson_atomize(mtcars), "no 'geojson_atomize' method")
})
