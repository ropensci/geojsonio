context("file_to_geojson")

# kml -------------------------------
file <- system.file("examples", "norway_maple.kml", package = "geojsonio")

# temp files
ftog1 <- basename(tempfile())
ftog2 <- basename(tempfile())
ftog3 <- basename(tempfile())
ftog4 <- basename(tempfile())

test_that("file_to_geojson works w/ kml input, web method, output file", {
  skip_on_cran()
  
  aa <- suppressMessages(file_to_geojson(input = file, method = 'web',
                                         output = ftog1))
  aa_in <- jsonlite::fromJSON(aa)

  expect_is(aa, "character")
  expect_true(file.exists(aa))
  expect_match(aa, ftog1)

  expect_is(aa_in, "list")
  expect_equal(aa_in$type, "FeatureCollection")
  expect_is(aa_in$crs, "list")
  expect_is(aa_in$features, "data.frame")
  
  # cleanup
  unlink(paste0(ftog1, ".geojson"))
})

test_that("file_to_geojson works w/ kml input, web method, output memory", {
  skip_on_cran()
  
  aa <- suppressMessages(file_to_geojson(input = file, method = 'web',
                                         output = ':memory:'))

  expect_is(aa, "list")
  expect_equal(aa$type, "FeatureCollection")
  expect_is(aa$crs, "list")
  expect_is(aa$features, "list")
  expect_named(aa$features[[1]], c('type', 'properties', 'geometry'))

  expect_is(as.json(aa), "json")
})

test_that("file_to_geojson works w/ kml input, local method, output file", {
  aa <- suppressMessages(file_to_geojson(input = file, method = 'local',
                                         output = ftog2))
  aa_in <- jsonlite::fromJSON(aa)

  expect_is(aa, "character")
  expect_true(file.exists(aa))
  expect_match(aa, ftog2)

  expect_equal(aa_in$type, "FeatureCollection")
  expect_is(aa_in$features, "data.frame")

  expect_is(as.json(aa_in), "json")
  
  # cleanup
  unlink(paste0(ftog2, ".geojson"))
})

test_that("file_to_geojson works w/ kml input, local method, output memory", {
  aa <- suppressMessages(file_to_geojson(input = file, method = 'local',
                                         output = ':memory:'))

  expect_is(aa, "list")
  expect_equal(aa$type, "FeatureCollection")
  expect_is(aa$features, "list")
  expect_named(aa$features[[1]], c('type', 'id', 'properties', 'geometry'))

  expect_is(as.json(aa), "json")
})


# shp -------------------------------
test_that("file_to_geojson works w/ shp zip file input, web method, output file", {
  skip_on_cran()
  
  file <- system.file("examples", "bison.zip", package = "geojsonio")

  aa <- suppressMessages(file_to_geojson(input = file, method = 'web',
                                         output = ftog3))
  aa_in <- jsonlite::fromJSON(aa)

  expect_is(aa, "character")
  expect_true(file.exists(aa))
  expect_match(aa, ftog3)

  expect_is(aa_in, "list")
  expect_equal(aa_in$type, "FeatureCollection")
  expect_is(aa_in$crs, "list")

  expect_is(as.json(aa_in), "json")
  
  # cleanup
  unlink(paste0(ftog3, ".geojson"))
})

test_that("file_to_geojson works w/ shp file input, local method, output file", {
  file <- system.file("examples", "bison.zip", package = "geojsonio")
  dir <- tempdir()
  unzip(file, exdir = dir)
  shpfile <- file.path(dir, "bison-Bison_bison-20130704-120856.shp")

  aa <- suppressMessages(file_to_geojson(input = shpfile, method = 'local',
                                         output = ftog4))
  aa_in <- jsonlite::fromJSON(aa)

  expect_is(aa, "character")
  expect_true(file.exists(aa))
  expect_match(aa, ftog4)

  expect_is(aa_in, "list")
  expect_equal(aa_in$type, "FeatureCollection")
  expect_is(aa_in$features, "data.frame")

  expect_is(as.json(aa_in), "json")
  
  # cleanup
  unlink(paste0(ftog4, ".geojson"))
})

test_that("file_to_geojson fails well", {
  file <- system.file("examples", "norway_maple.kml", package = "geojsonio")

  expect_error(file_to_geojson(), "argument \"input\" is missing")
  expect_error(file_to_geojson(file, method = "adfadf"), "'arg' should be one of")
  expect_error(file_to_geojson(file, parse = "foobar"), "parse must be logical")
})
