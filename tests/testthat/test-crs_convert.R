# compare_things <- function(a, b) {
#   a$name <- b$name <- NULL
#   expect_equal(a, b)
# }

# if (requireNamespace("sf", quietly = TRUE)) {

#   sfc <-  sf::st_sfc(sf::st_point(c(0,0)), sf::st_point(c(1,1)))
#   sf <-  sf::st_sf(a = 1:2, geom = sfc)
#   sf_4326 <- sf::st_set_crs(sf, 4326)
#   sf_3005 <- sf::st_transform(sf_4326, 3005)

#   pts = cbind(1:5, 1:5)
#   df = data.frame(a = 1:5)
#   spdf <- spdf_4326 <- spdf_3005 <- SpatialPointsDataFrame(pts, df)
#   proj4string(spdf_4326) <- CRS("+init=epsg:4326")
#   spdf_3005 <- supw(as(sf::st_transform(sf::st_as_sf(spdf_4326), 3005), 'Spatial'))

#   test_that("works with sf", {
#     expect_type(st_crs(convert_wgs84(sf_4326))[["proj4string"]],
#               "character")

#     expect_type(st_crs(supm(convert_wgs84(sf_3005)))[["proj4string"]],
#                  "character")
#   })

#   test_that("works with sfc", {
#     supw(st_crs(sfc) <-  4326)
#     expect_type(st_crs(supm(convert_wgs84(sfc)))[["proj4string"]],
#                  "character")

#     supw(st_crs(sfc) <- 3005)
#     expect_type(st_crs(supm(convert_wgs84(sfc)))[["proj4string"]],
#                  "character")
#   })

#   test_that("works with spatial", {
#     expect_type(proj4string(convert_wgs84(spdf_4326)),
#                  "character")

#     expect_type(proj4string(convert_wgs84(spdf_3005)),
#                  "character")
#   })

#   test_that("allows supplying a CRS with Spatial", {
#     expect_type(proj4string(convert_wgs84(spdf, crs = "+init=epsg:3005")),
#                  "character")
#   })

#   test_that("allows supplying a CRS with sf", {
#     expect_type(st_crs(convert_wgs84(sf, crs = 3005))[["proj4string"]],
#                  "character")
#   })

#   test_that("allows supplying a CRS with sfc", {
#     expect_type(st_crs(convert_wgs84(sfc, crs = 3005))[["proj4string"]],
#                  "character")
#   })

#   test_that("is_wgs84 works with sf", {
#     expect_true(is_wgs84(sf_4326))
#     expect_false(supw(is_wgs84(sf_3005)))
#     expect_warning(is_wgs84(sf_3005), "WGS84")
#   })

#   test_that("is_wgs84 works with sfc", {
#     st_crs(sfc) <- 4326
#     expect_true(is_wgs84(sfc))
#     sfc_3005 <- sf::st_transform(sfc, 3005)
#     expect_false(supw(is_wgs84(sfc_3005)))
#     expect_warning(is_wgs84(sfc_3005), "WGS84")
#   })

#   test_that("is_wgs84 works with Spatial", {
#     proj4string(spdf) <- "+init=epsg:4326"
#     expect_true(is_wgs84(spdf))
#     spdf_3005 <- supw(as(sf::st_transform(sf::st_as_sf(spdf), 3005), 'Spatial'))
#     expect_false(supw(is_wgs84(spdf_3005)))
#     expect_warning(is_wgs84(spdf_3005), "WGS84")
#   })

#   test_that("geojson_list: convert_wgs84 works with Spatial classes", {
#     compare_things(
#       geojson_list(spdf_4326, convert_wgs84 = TRUE),
#       geojson_list(spdf_4326, convert_wgs84 = FALSE)
#     )
#     compare_things(geojson_list(spdf_4326),
#       geojson_list(spdf_3005, convert_wgs84 = TRUE))
#     proj4string(spdf_3005) <- NA_character_
#     compare_things(geojson_list(spdf_4326),
#       geojson_list(spdf_3005, convert_wgs84 = TRUE, crs = "+init=epsg:3005"))
#     compare_things(geojson_list(spdf_4326),
#       geojson_list(spdf_3005, convert_wgs84 = TRUE, crs = 3005))
#   })

#   test_that("geojson_list: convert_wgs84 works with sf classes", {
#     expect_equal(geojson_list(sf_4326, convert_wgs84 = TRUE),
#                  geojson_list(sf_4326, convert_wgs84 = FALSE))
#     expect_equal(geojson_list(sf_4326),
#                  geojson_list(sf_3005, convert_wgs84 = TRUE))
#     st_crs(sf_3005) <- NA_crs_
#     expect_equal(geojson_list(sf_4326),
#                  geojson_list(sf_3005, convert_wgs84 = TRUE, crs = "+init=epsg:3005"))
#     expect_equal(geojson_list(sf_4326),
#                  geojson_list(sf_3005, convert_wgs84 = TRUE, crs = 3005))
#   })

#   test_that("geojson_json: convert_wgs84 works with Spatial classes", {
#     compare_things(geojson_list(geojson_json(spdf_4326, convert_wgs84 = TRUE)),
#                  geojson_list(geojson_json(spdf_4326, convert_wgs84 = FALSE)))
#     compare_things(geojson_list(geojson_json(spdf_4326)),
#                  geojson_list(geojson_json(spdf_3005, convert_wgs84 = TRUE)))
#     proj4string(spdf_3005) <- NA_character_
#     compare_things(geojson_list(geojson_json(spdf_4326)),
#                  geojson_list(geojson_json(spdf_3005,
#                                            convert_wgs84 = TRUE,
#                                            crs = "+init=epsg:3005")))
#     compare_things(geojson_list(geojson_json(spdf_4326)),
#                  geojson_list(geojson_json(spdf_3005, convert_wgs84 = TRUE, crs = 3005)))
#   })

#   test_that("geojson_json: convert_wgs84 works with sf classes", {
#     expect_equal(geojson_list(geojson_json(sf_4326, convert_wgs84 = TRUE)),
#                  geojson_list(geojson_json(sf_4326, convert_wgs84 = FALSE)))
#     expect_equal(geojson_list(geojson_json(sf_4326)),
#                  geojson_list(geojson_json(sf_3005, convert_wgs84 = TRUE)))
#     st_crs(sf_3005) <- NA_crs_
#     expect_equal(geojson_list(geojson_json(sf_4326)),
#                  geojson_list(geojson_json(sf_3005,
#                                            convert_wgs84 = TRUE,
#                                            crs = "+init=epsg:3005")))
#     expect_equal(geojson_list(geojson_json(sf_4326)),
#                  geojson_list(geojson_json(sf_3005, convert_wgs84 = TRUE, crs = 3005)))
#   })

#   file_to_list <- function(x) geojson_read(x$path, what = "list")

#   test_that("geojson_write: convert_wgs84 works with Spatial classes", {
#     expect_equal(file_to_list(geojson_write(spdf_4326, convert_wgs84 = TRUE))$crs,
#                  file_to_list(geojson_write(spdf_4326, convert_wgs84 = FALSE))$crs)
#     expect_equal(file_to_list(geojson_write(spdf_4326))$crs,
#                  file_to_list(geojson_write(spdf_3005, convert_wgs84 = TRUE))$crs)
#     proj4string(spdf_3005) <- NA_character_
#     expect_equal(file_to_list(geojson_write(spdf_4326))$crs,
#                  file_to_list(geojson_write(spdf_3005,
#                                             convert_wgs84 = TRUE,
#                                             crs = "+init=epsg:3005"))$crs)
#     expect_equal(file_to_list(geojson_write(spdf_4326))$crs,
#                  file_to_list(geojson_write(spdf_3005, convert_wgs84 = TRUE, crs = 3005))$crs)
#   })

#   test_that("geojson_write: convert_wgs84 works with sf classes", {
#     expect_equal(file_to_list(geojson_write(sf_4326, convert_wgs84 = TRUE))$crs,
#                  file_to_list(geojson_write(sf_4326, convert_wgs84 = FALSE))$crs)
#     expect_equal(file_to_list(geojson_write(sf_4326))$crs,
#                  file_to_list(geojson_write(sf_3005, convert_wgs84 = TRUE))$crs)
#     st_crs(sf_3005) <- NA_crs_
#     expect_equal(file_to_list(geojson_write(sf_4326))$crs,
#                  file_to_list(geojson_write(sf_3005,
#                                             convert_wgs84 = TRUE,
#                                             crs = "+init=epsg:3005"))$crs)
#     expect_equal(file_to_list(geojson_write(sf_4326))$crs,
#                  file_to_list(geojson_write(sf_3005, convert_wgs84 = TRUE, crs = 3005))$crs)
#   })

# }
