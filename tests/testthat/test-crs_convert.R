context("detect and convert crs")

sm <- function(x) suppressMessages(x)

if (suppressPackageStartupMessages(require("sf", quietly = TRUE))) {
  
  suppressPackageStartupMessages(library(sp))
  
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
    expect_is(st_crs(convert_wgs84(sf_4326))[["proj4string"]],
              "character")

    expect_is(st_crs(sm(convert_wgs84(sf_3005)))[["proj4string"]],
                 "character")
  })
  
  test_that("works with sfc", {
    suppressWarnings(st_crs(sfc) <-  4326)
    expect_is(st_crs(sm(convert_wgs84(sfc)))[["proj4string"]],
                 "character")

    suppressWarnings(st_crs(sfc) <- 3005)
    expect_is(st_crs(sm(convert_wgs84(sfc)))[["proj4string"]],
                 "character")
  })

  test_that("works with spatial", {
    expect_is(proj4string(convert_wgs84(spdf_4326)),
                 "character")

    expect_is(proj4string(convert_wgs84(spdf_3005)),
                 "character")
  })

  test_that("allows supplying a CRS with Spatial", {
    expect_is(proj4string(convert_wgs84(spdf, crs = "+init=epsg:3005")),
                 "character")
  })

  test_that("allows supplying a CRS with sf", {
    expect_is(st_crs(convert_wgs84(sf, crs = 3005))[["proj4string"]],
                 "character")
  })

  test_that("allows supplying a CRS with sfc", {
    expect_is(st_crs(convert_wgs84(sfc, crs = 3005))[["proj4string"]],
                 "character")
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
  
  test_that("geojson_list: convert_wgs84 works with Spatial classes", {
    expect_equal(geojson_list(spdf_4326, convert_wgs84 = TRUE), 
                 geojson_list(spdf_4326, convert_wgs84 = FALSE))
    expect_equal(geojson_list(spdf_4326), 
                 geojson_list(spdf_3005, convert_wgs84 = TRUE))
    proj4string(spdf_3005) <- NA_character_
    expect_equal(geojson_list(spdf_4326), 
                 geojson_list(spdf_3005, convert_wgs84 = TRUE, crs = "+init=epsg:3005"))
    expect_equal(geojson_list(spdf_4326), 
                 geojson_list(spdf_3005, convert_wgs84 = TRUE, crs = 3005))
  })
  
  test_that("geojson_list: convert_wgs84 works with sf classes", {
    expect_equal(geojson_list(sf_4326, convert_wgs84 = TRUE), 
                 geojson_list(sf_4326, convert_wgs84 = FALSE))
    expect_equal(geojson_list(sf_4326), 
                 geojson_list(sf_3005, convert_wgs84 = TRUE))
    st_crs(sf_3005) <- NA_crs_
    expect_equal(geojson_list(sf_4326), 
                 geojson_list(sf_3005, convert_wgs84 = TRUE, crs = "+init=epsg:3005"))
    expect_equal(geojson_list(sf_4326), 
                 geojson_list(sf_3005, convert_wgs84 = TRUE, crs = 3005))
  })
  
  test_that("geojson_json: convert_wgs84 works with Spatial classes", {
    expect_equal(geojson_list(geojson_json(spdf_4326, convert_wgs84 = TRUE)), 
                 geojson_list(geojson_json(spdf_4326, convert_wgs84 = FALSE)))
    expect_equal(geojson_list(geojson_json(spdf_4326)), 
                 geojson_list(geojson_json(spdf_3005, convert_wgs84 = TRUE)))
    proj4string(spdf_3005) <- NA_character_
    expect_equal(geojson_list(geojson_json(spdf_4326)), 
                 geojson_list(geojson_json(spdf_3005, 
                                           convert_wgs84 = TRUE, 
                                           crs = "+init=epsg:3005")))
    expect_equal(geojson_list(geojson_json(spdf_4326)), 
                 geojson_list(geojson_json(spdf_3005, convert_wgs84 = TRUE, crs = 3005)))
  })
  
  test_that("geojson_json: convert_wgs84 works with sf classes", {
    expect_equal(geojson_list(geojson_json(sf_4326, convert_wgs84 = TRUE)), 
                 geojson_list(geojson_json(sf_4326, convert_wgs84 = FALSE)))
    expect_equal(geojson_list(geojson_json(sf_4326)), 
                 geojson_list(geojson_json(sf_3005, convert_wgs84 = TRUE)))
    st_crs(sf_3005) <- NA_crs_
    expect_equal(geojson_list(geojson_json(sf_4326)), 
                 geojson_list(geojson_json(sf_3005, 
                                           convert_wgs84 = TRUE, 
                                           crs = "+init=epsg:3005")))
    expect_equal(geojson_list(geojson_json(sf_4326)), 
                 geojson_list(geojson_json(sf_3005, convert_wgs84 = TRUE, crs = 3005)))
  })
  
  file_to_list <- function(x) geojson_read(x$path, method = "local", what = "list")
  
  test_that("geojson_write: convert_wgs84 works with Spatial classes", {
    expect_equal(file_to_list(geojson_write(spdf_4326, convert_wgs84 = TRUE)), 
                 file_to_list(geojson_write(spdf_4326, convert_wgs84 = FALSE)))
    expect_equal(file_to_list(geojson_write(spdf_4326)), 
                 file_to_list(geojson_write(spdf_3005, convert_wgs84 = TRUE)))
    proj4string(spdf_3005) <- NA_character_
    expect_equal(file_to_list(geojson_write(spdf_4326)), 
                 file_to_list(geojson_write(spdf_3005, 
                                            convert_wgs84 = TRUE, 
                                            crs = "+init=epsg:3005")))
    expect_equal(file_to_list(geojson_write(spdf_4326)), 
                 file_to_list(geojson_write(spdf_3005, convert_wgs84 = TRUE, crs = 3005)))
  })
  
  test_that("geojson_write: convert_wgs84 works with sf classes", {
    expect_equal(file_to_list(geojson_write(sf_4326, convert_wgs84 = TRUE)), 
                 file_to_list(geojson_write(sf_4326, convert_wgs84 = FALSE)))
    expect_equal(file_to_list(geojson_write(sf_4326)), 
                 file_to_list(geojson_write(sf_3005, convert_wgs84 = TRUE)))
    st_crs(sf_3005) <- NA_crs_
    expect_equal(file_to_list(geojson_write(sf_4326)), 
                 file_to_list(geojson_write(sf_3005, 
                                            convert_wgs84 = TRUE, 
                                            crs = "+init=epsg:3005")))
    expect_equal(file_to_list(geojson_write(sf_4326)), 
                 file_to_list(geojson_write(sf_3005, convert_wgs84 = TRUE, crs = 3005)))
  })
  
}
