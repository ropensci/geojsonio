context("detect and convert crs")
suppressPackageStartupMessages(library(sf))
suppressPackageStartupMessages(library(sp))

sfc <-  st_sfc(st_point(c(0,0)), st_point(c(1,1)))
sf <-  st_sf(a = 1:2, geom = sfc)
pts = cbind(1:5, 1:5)
df = data.frame(a = 1:5)
spdf <- SpatialPointsDataFrame(pts, df)

test_that("works with sf", {
  suppressWarnings(st_crs(sf) <-  4326)
  expect_equal(st_crs(convert_crs(sf))[["proj4string"]],
               "+proj=longlat +datum=WGS84 +no_defs")
  
  suppressWarnings(st_crs(sf) <- 3005)
  expect_equal(st_crs(convert_crs(sf))[["proj4string"]],
               "+proj=longlat +datum=WGS84 +no_defs")
})

test_that("works with sf", {
  suppressWarnings(st_crs(sfc) <-  4326)
  expect_equal(st_crs(convert_crs(sfc))[["proj4string"]],
               "+proj=longlat +datum=WGS84 +no_defs")
  
  suppressWarnings(st_crs(sfc) <- 3005)
  expect_equal(st_crs(convert_crs(sfc))[["proj4string"]],
               "+proj=longlat +datum=WGS84 +no_defs")
})

test_that("works with spatial", {
  suppressWarnings(proj4string(spdf) <- CRS("+init=epsg:4326"))
  expect_equal(proj4string(convert_crs(spdf)), 
               "+init=epsg:4326 +proj=longlat +datum=WGS84 +no_defs +ellps=WGS84 +towgs84=0,0,0")
  
  suppressWarnings(proj4string(spdf) <- CRS("+init=epsg:3005"))
  expect_equal(proj4string(convert_crs(spdf)), 
               "+init=epsg:4326 +proj=longlat +datum=WGS84 +no_defs +ellps=WGS84 +towgs84=0,0,0")
})

test_that("allows supplying a CRS with Spatial", {
  expect_equal(proj4string(convert_crs(spdf, init_crs = "+init=epsg:3005")), 
               "+init=epsg:4326 +proj=longlat +datum=WGS84 +no_defs +ellps=WGS84 +towgs84=0,0,0")
})

test_that("allows supplying a CRS with sf", {
  expect_equal(st_crs(convert_crs(sf, init_crs = 3005))[["proj4string"]], 
               "+proj=longlat +datum=WGS84 +no_defs")
})

test_that("allows supplying a CRS with sfc", {
  expect_equal(st_crs(convert_crs(sfc, init_crs = 3005))[["proj4string"]], 
               "+proj=longlat +datum=WGS84 +no_defs")
})

test_that("is_wgs84 works with sf", {
  st_crs(sf) <- 4326
  expect_true(is_wgs84(sf))
  sf_3005 <- st_transform(sf, 3005)
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
