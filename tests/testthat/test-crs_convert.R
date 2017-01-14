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
  expect_equal(st_crs(detect_convert_crs(sf))[["proj4string"]],
               "+proj=longlat +datum=WGS84 +no_defs")
  
  suppressWarnings(st_crs(sf) <- 3005)
  expect_equal(st_crs(detect_convert_crs(sf))[["proj4string"]],
               "+proj=longlat +datum=WGS84 +no_defs")
})

test_that("works with sf", {
  suppressWarnings(st_crs(sfc) <-  4326)
  expect_equal(st_crs(detect_convert_crs(sfc))[["proj4string"]],
               "+proj=longlat +datum=WGS84 +no_defs")
  
  suppressWarnings(st_crs(sfc) <- 3005)
  expect_equal(st_crs(detect_convert_crs(sfc))[["proj4string"]],
               "+proj=longlat +datum=WGS84 +no_defs")
})

test_that("works with spatial", {
suppressWarnings(proj4string(spdf) <- CRS("+init=epsg:4326"))
expect_equal(proj4string(detect_convert_crs(spdf)), 
             "+init=epsg:4326 +proj=longlat +datum=WGS84 +no_defs +ellps=WGS84 +towgs84=0,0,0")

suppressWarnings(proj4string(spdf) <- CRS("+init=epsg:3005"))
expect_equal(proj4string(detect_convert_crs(spdf)), 
             "+init=epsg:4326 +proj=longlat +datum=WGS84 +no_defs +ellps=WGS84 +towgs84=0,0,0")
})
