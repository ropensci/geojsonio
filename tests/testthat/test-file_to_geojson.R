test_that("file_to_geojson works w/ kml input, web method, output file", {
  skip_on_cran()
  skip_if_offline()

  file <- withr::local_tempfile()

  aa <- supm(file_to_geojson(
    input = example_sys_file("norway_maple.kml"),
    method = "web",
    output = file
  ))
  aa_in <- jsonlite::fromJSON(aa)

  expect_type(aa, "character")
  expect_true(file.exists(aa))
  expect_match(aa, basename(file))

  expect_type(aa_in, "list")
  expect_equal(aa_in$type, "FeatureCollection")
  expect_type(aa_in$crs, "list")
  expect_s3_class(aa_in$features, "data.frame")
})

test_that("file_to_geojson works w/ kml input, web method, output memory", {
  skip_on_cran()
  skip_if_offline()

  aa <- supm(file_to_geojson(
    input = example_sys_file("norway_maple.kml"),
    method = "web",
    output = ":memory:"
  ))

  expect_type(aa, "list")
  expect_equal(aa$type, "FeatureCollection")
  expect_type(aa$crs, "list")
  expect_type(aa$features, "list")
  expect_named(aa$features[[1]], c("type", "properties", "geometry"))

  expect_s3_class(as.json(aa), "json")
})

test_that("file_to_geojson works w/ kml input, local method, output file", {
  skip_on_cran()

  file <- withr::local_tempfile()

  aa <- supm(file_to_geojson(
    input = example_sys_file("norway_maple.kml"),
    method = "local",
    output = file
  ))
  aa_in <- jsonlite::fromJSON(aa)

  expect_type(aa, "character")
  expect_true(file.exists(aa))
  expect_match(aa, basename(file))

  expect_equal(aa_in$type, "FeatureCollection")
  expect_s3_class(aa_in$features, "data.frame")

  expect_s3_class(as.json(aa_in), "json")
})

test_that("file_to_geojson works w/ kml input, local method, output memory", {
  skip_on_cran()

  aa <- supm(file_to_geojson(
    input = example_sys_file("norway_maple.kml"),
    method = "local",
    output = ":memory:"
  ))

  expect_type(aa, "list")
  expect_equal(aa$type, "FeatureCollection")
  expect_type(aa$features, "list")
  expect_named(aa$features[[1]], c("type", "properties", "geometry"))

  expect_s3_class(as.json(aa), "json")
})


# shp -------------------------------
test_that("file_to_geojson works w/ shp zip file input, web method, output file", {
  skip_on_cran()
  skip_if_offline()

  file <- example_sys_file("bison.zip")
  output_file <- withr::local_tempfile()

  aa <- supm(file_to_geojson(
    input = example_sys_file("norway_maple.kml"),
    method = "web",
    output = output_file
  ))
  aa_in <- jsonlite::fromJSON(aa)

  expect_type(aa, "character")
  expect_true(file.exists(aa))
  expect_match(aa, basename(output_file))

  expect_type(aa_in, "list")
  expect_equal(aa_in$type, "FeatureCollection")
  expect_type(aa_in$crs, "list")

  expect_s3_class(as.json(aa_in), "json")
})

test_that("file_to_geojson works w/ shp file input, local method, output file", {
  skip_on_cran()

  file <- example_sys_file("bison.zip")
  output_file <- withr::local_tempfile()
  dir <- withr::local_tempdir()
  unzip(file, exdir = dir)
  shpfile <- file.path(dir, "bison-Bison_bison-20130704-120856.shp")

  aa <- supm(file_to_geojson(
    input = shpfile, method = "local",
    output = output_file
  ))
  aa_in <- jsonlite::fromJSON(aa)

  expect_type(aa, "character")
  expect_true(file.exists(aa))
  expect_match(aa, basename(output_file))

  expect_type(aa_in, "list")
  expect_equal(aa_in$type, "FeatureCollection")
  expect_s3_class(aa_in$features, "data.frame")

  expect_s3_class(as.json(aa_in), "json")
})

## Testing with url
# kml
kml_url <- "https://raw.githubusercontent.com/ropensci/geojsonio/master/inst/examples/norway_maple.kml"

test_that("file_to_geojson works w/ url kml input, web method, local output", {
  skip_on_cran()
  skip_if_offline()
  file <- withr::local_tempfile()

  aa <- supm(file_to_geojson(input = kml_url, method = "web", output = file))

  aa_in <- jsonlite::fromJSON(aa)

  expect_type(aa, "character")
  expect_true(file.exists(aa))
  expect_match(aa, basename(file))

  expect_type(aa_in, "list")
  expect_equal(aa_in$type, "FeatureCollection")
  expect_s3_class(aa_in$features, "data.frame")

  expect_s3_class(as.json(aa_in), "json")
})

test_that("file_to_geojson works w/ url kml input, local method, local output", {
  skip_on_cran()
  skip_if_offline()
  file <- withr::local_tempfile()
  aa <- supm(file_to_geojson(kml_url, method = "local", output = file))

  aa_in <- jsonlite::fromJSON(aa)

  expect_type(aa, "character")
  expect_true(file.exists(aa))
  expect_match(aa, basename(file))

  expect_type(aa_in, "list")
  expect_equal(aa_in$type, "FeatureCollection")
  expect_s3_class(aa_in$features, "data.frame")

  expect_s3_class(as.json(aa_in), "json")
})

test_that("file_to_geojson works w/ url kml input, web method, memory output", {
  skip_on_cran()
  skip_if_offline()

  aa <- supm(file_to_geojson(kml_url, method = "web", output = ":memory:"))

  expect_type(aa, "list")
  expect_equal(aa$type, "FeatureCollection")
  expect_type(aa$features, "list")
  expect_named(aa$features[[1]], c("type", "properties", "geometry"))

  expect_s3_class(as.json(aa), "json")
})

test_that("file_to_geojson works w/ url kml input, local method, memory output", {
  skip_on_cran()
  skip_if_offline()

  aa <- supm(file_to_geojson(kml_url, method = "local", output = ":memory:"))

  expect_type(aa, "list")
  expect_equal(aa$type, "FeatureCollection")
  expect_type(aa$features, "list")
  expect_named(aa$features[[1]], c("type", "properties", "geometry"))

  expect_s3_class(as.json(aa), "json")
})

# shp
shp_url <- "https://raw.githubusercontent.com/ropensci/geojsonio/master/inst/examples/bison.zip"

test_that("file_to_geojson works w/ url shp zip file input, web method, output file", {
  skip_on_cran()
  skip_if_offline()

  file <- withr::local_tempfile()

  aa <- supm(file_to_geojson(
    input = shp_url, method = "web",
    output = file
  ))
  aa_in <- jsonlite::fromJSON(aa)

  expect_type(aa, "character")
  expect_true(file.exists(aa))
  expect_match(aa, basename(file))

  expect_type(aa_in, "list")
  expect_equal(aa_in$type, "FeatureCollection")
  expect_type(aa_in$crs, "list")

  expect_s3_class(as.json(aa_in), "json")
})

test_that("file_to_geojson works w/ url shp zip file input, web method, memory output", {
  skip_on_cran()
  skip_if_offline()

  aa <- supm(file_to_geojson(
    input = shp_url, method = "web",
    output = ":memory:"
  ))

  expect_type(aa, "list")
  expect_equal(aa$type, "FeatureCollection")
  expect_type(aa$features, "list")
  expect_named(aa$features[[1]], c("type", "properties", "geometry"))

  expect_s3_class(as.json(aa), "json")
})

test_that("file_to_geojson fails well", {
  skip_on_cran()

  file <- example_sys_file("norway_maple.kml")

  expect_error(file_to_geojson(), "argument \"input\" is missing")
  expect_error(file_to_geojson(file, method = "adfadf"), "'arg' should be one of")
  expect_error(file_to_geojson(file, parse = "foobar"), "parse must be logical")
})
