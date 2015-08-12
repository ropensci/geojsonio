context("file_to_geojson")

# kml -------------------------------
file <- system.file("examples", "norway_maple.kml", package = "geojsonio")
test_that("file_to_geojson works w/ kml input, web method, output file", {
  aa <- suppressMessages(file_to_geojson(input = file, method = 'web', 
                                         output = 'kml_web'))
  aa_in <- jsonlite::fromJSON(aa)
  
  expect_is(aa, "character")
  expect_true(file.exists(aa))
  expect_match(aa, 'kml_web')
  
  expect_is(aa_in, "list")
  expect_equal(aa_in$type, "FeatureCollection")
  expect_is(aa_in$crs, "list")
  expect_is(aa_in$features, "data.frame")
})

test_that("file_to_geojson works w/ kml input, web method, output memory", {
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
                                         output = 'kml_local'))
  aa_in <- jsonlite::fromJSON(aa)
  
  expect_is(aa, "character")
  expect_true(file.exists(aa))
  expect_match(aa, 'kml_local')
  
  expect_equal(aa_in$type, "FeatureCollection")
  expect_is(aa_in$features, "data.frame")
  
  expect_is(as.json(aa_in), "json")
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
  file <- system.file("examples", "bison.zip", package = "geojsonio")
  
  aa <- suppressMessages(file_to_geojson(input = file, method = 'web', 
                                         output = 'shp_web'))
  aa_in <- jsonlite::fromJSON(aa)
  
  expect_is(aa, "character")
  expect_true(file.exists(aa))
  expect_match(aa, 'shp_web')
  
  expect_is(aa_in, "list")
  expect_equal(aa_in$type, "FeatureCollection")
  expect_is(aa_in$crs, "list")
  
  expect_is(as.json(aa_in), "json")
})

test_that("file_to_geojson works w/ shp file input, local method, output file", {
  file <- system.file("examples", "bison.zip", package = "geojsonio")
  dir <- tempdir()
  unzip(file, exdir = dir)
  shpfile <- file.path(dir, "bison-Bison_bison-20130704-120856.shp")

  aa <- suppressMessages(file_to_geojson(input = shpfile, method = 'local', 
                                         output = 'shp_local'))
  aa_in <- jsonlite::fromJSON(aa)
  
  expect_is(aa, "character")
  expect_true(file.exists(aa))
  expect_match(aa, 'shp_local')
  
  expect_is(aa_in, "list")
  expect_equal(aa_in$type, "FeatureCollection")
  expect_is(aa_in$features, "data.frame")
  
  expect_is(as.json(aa_in), "json")
})

test_that("file_to_geojson fails well", {
  file <- system.file("examples", "norway_maple.kml", package = "geojsonio")
  
  expect_error(file_to_geojson(), "argument \"input\" is missing")
  expect_error(file_to_geojson(file, method = "adfadf"), "'arg' should be one of")
  expect_error(file_to_geojson(file, parse = "foobar"), "parse must be logical")
})
