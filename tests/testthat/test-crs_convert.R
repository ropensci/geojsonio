context("detect and convert crs")
suppressPackageStartupMessages(library(sf))
suppressPackageStartupMessages(library(sp))
library(jsonlite)

sfc <-  st_sfc(st_point(c(0,0)), st_point(c(1,1)))
sf <-  st_sf(a = 1:2, geom = sfc)
sf_4326 <- st_set_crs(sf, 4326)
sf_3005 <- st_transform(sf_4326, 3005)

pts = cbind(1:5, 1:5)
df = data.frame(a = 1:5)
spdf <- spdf_4326 <- spdf_3005 <- SpatialPointsDataFrame(pts, df)
proj4string(spdf_4326) <- CRS("+init=epsg:4326")
spdf_3005 <- spTransform(spdf_4326, CRS("+init=epsg:3005"))

test_that("works with sf", {
  expect_equal(st_crs(convert_crs(sf_4326))[["proj4string"]],
               "+proj=longlat +datum=WGS84 +no_defs")
  
  expect_equal(st_crs(convert_crs(sf_3005))[["proj4string"]],
               "+proj=longlat +datum=WGS84 +no_defs")
})

test_that("works with sfc", {
  suppressWarnings(st_crs(sfc) <-  4326)
  expect_equal(st_crs(convert_crs(sfc))[["proj4string"]],
               "+proj=longlat +datum=WGS84 +no_defs")
  
  suppressWarnings(st_crs(sfc) <- 3005)
  expect_equal(st_crs(convert_crs(sfc))[["proj4string"]],
               "+proj=longlat +datum=WGS84 +no_defs")
})

test_that("works with spatial", {
  expect_equal(proj4string(convert_crs(spdf_4326)), 
               "+init=epsg:4326 +proj=longlat +datum=WGS84 +no_defs +ellps=WGS84 +towgs84=0,0,0")

  expect_equal(proj4string(convert_crs(spdf_3005)), 
               "+init=epsg:4326 +proj=longlat +datum=WGS84 +no_defs +ellps=WGS84 +towgs84=0,0,0")
})

test_that("allows supplying a CRS with Spatial", {
  expect_equal(proj4string(convert_crs(spdf, crs = "+init=epsg:3005")), 
               "+init=epsg:4326 +proj=longlat +datum=WGS84 +no_defs +ellps=WGS84 +towgs84=0,0,0")
})

test_that("allows supplying a CRS with sf", {
  expect_equal(st_crs(convert_crs(sf, crs = 3005))[["proj4string"]], 
               "+proj=longlat +datum=WGS84 +no_defs")
})

test_that("allows supplying a CRS with sfc", {
  expect_equal(st_crs(convert_crs(sfc, crs = 3005))[["proj4string"]], 
               "+proj=longlat +datum=WGS84 +no_defs")
})

test_that("is_wgs84 works with sf", {
  expect_true(is_wgs84(sf_4326))
  expect_false(suppressWarnings(is_wgs84(sf_3005)))
  expect_warning(is_wgs84(sf_3005), "WGS84")
})

test_that("is_wgs84 works with sfc", {
  st_crs(sfc) <- 4326
  expect_true(is_wgs84(sfc))
  sfc_3005 <- st_transform(sfc, 3005)
  expect_false(suppressWarnings(is_wgs84(sfc_3005)))
  expect_warning(is_wgs84(sfc_3005), "WGS84")
})

test_that("is_wgs84 works with Spatial", {
  proj4string(spdf) <- "+init=epsg:4326"
  expect_true(is_wgs84(spdf))
  spdf_3005 <- spTransform(spdf, "+init=epsg:3005")
  expect_false(suppressWarnings(is_wgs84(spdf_3005)))
  expect_warning(is_wgs84(spdf_3005), "WGS84")
})

test_that("geojson_list: convert_crs works with Spatial classes", {
  expect_equal(geojson_list(spdf_4326, convert_crs = TRUE), 
               geojson_list(spdf_4326, convert_crs = FALSE))
  expect_equal(geojson_list(spdf_4326), 
               geojson_list(spdf_3005, convert_crs = TRUE))
  proj4string(spdf_3005) <- NA_character_
  expect_equal(geojson_list(spdf_4326), 
               geojson_list(spdf_3005, convert_crs = TRUE, crs = "+init=epsg:3005"))
  expect_equal(geojson_list(spdf_4326), 
               geojson_list(spdf_3005, convert_crs = TRUE, crs = 3005))
})

test_that("geojson_list: convert_crs works with sf classes", {
  expect_equal(geojson_list(sf_4326, convert_crs = TRUE), 
               geojson_list(sf_4326, convert_crs = FALSE))
  expect_equal(geojson_list(sf_4326), 
               geojson_list(sf_3005, convert_crs = TRUE))
  st_crs(sf_3005) <- NA_crs_
  expect_equal(geojson_list(sf_4326), 
               geojson_list(sf_3005, convert_crs = TRUE, crs = "+init=epsg:3005"))
  expect_equal(geojson_list(sf_4326), 
               geojson_list(sf_3005, convert_crs = TRUE, crs = 3005))
})

test_that("geojson_json: convert_crs works with Spatial classes", {
  expect_equal(jsonlite::fromJSON(geojson_json(spdf_4326, convert_crs = TRUE)), 
               jsonlite::fromJSON(geojson_json(spdf_4326, convert_crs = FALSE)))
  expect_equal(jsonlite::fromJSON(geojson_json(spdf_4326)), 
               jsonlite::fromJSON(geojson_json(spdf_3005, convert_crs = TRUE)))
  proj4string(spdf_3005) <- NA_character_
  expect_equal(jsonlite::fromJSON(geojson_json(spdf_4326)), 
               jsonlite::fromJSON(geojson_json(spdf_3005, 
                                               convert_crs = TRUE, 
                                               crs = "+init=epsg:3005")))
  expect_equal(jsonlite::fromJSON(geojson_json(spdf_4326)), 
               jsonlite::fromJSON(geojson_json(spdf_3005, convert_crs = TRUE, crs = 3005)))
})

test_that("geojson_json: convert_crs works with sf classes", {
  expect_equal(geojson_json(sf_4326, convert_crs = TRUE), 
               geojson_json(sf_4326, convert_crs = FALSE))
  expect_equal(jsonlite::fromJSON(geojson_json(sf_4326)), 
               jsonlite::fromJSON(geojson_json(sf_3005, convert_crs = TRUE)))
  st_crs(sf_3005) <- NA_crs_
  expect_equal(jsonlite::fromJSON(geojson_json(sf_4326)), 
               jsonlite::fromJSON(geojson_json(sf_3005, 
                                               convert_crs = TRUE, 
                                               crs = "+init=epsg:3005")))
  expect_equal(jsonlite::fromJSON(geojson_json(sf_4326)), 
               jsonlite::fromJSON(geojson_json(sf_3005, convert_crs = TRUE, crs = 3005)))
})
