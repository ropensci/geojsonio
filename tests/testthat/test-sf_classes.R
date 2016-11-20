context("sf classes")
suppressPackageStartupMessages(library(sf, quietly = TRUE))

file <- system.file("examples", "feature_collection.geojson", package = "geojsonio")
testfc <- st_read(file, quiet = TRUE)

test_that("fc utility functions work", {
  expect_equal(get_epsg(testfc), 4326)
  expect_equal(get_epsg(testfc$geometry), 4326)
  expect_equal(get_sf_column_name(testfc), "geometry")
  expect_true(is_wgs84(testfc))
  
  expect_equal(get_geometry_type(testfc$geometry), "GEOMETRY")
  expect_equal(switch_geom_type(get_geometry_type(testfc$geometry)), "GeometryCollection")
  
  testfc_3005 <- st_transform(testfc, 3005)
  expect_false(suppressWarnings(is_wgs84(testfc_3005)))
  expect_warning(is_wgs84(testfc_3005), "WGS84")
  expect_message(detect_convert_crs(testfc_3005), "EPSG:3005 to WGS84")
  expect_true(is_wgs84(suppressMessages(detect_convert_crs(testfc_3005))))
})

## POINT
p_list <- lapply(list(c(3.2,4), c(3,4.6), c(3.8,4.4)), st_point)
pt_sfc <- st_sfc(p_list)
pt_sf <- st_sf(id = c("a", "b", "c"), pt_sfc)

test_that("geojson_list works with points", {
  point_sfc_list <- geojson_list(pt_sfc)
  point_sf_list <- geojson_list(pt_sf)
  
  expect_s3_class(point_sfc_list, "geo_list")
  expect_s3_class(point_sf_list, "geo_list")
  
  expect_length(point_sfc_list, 2)
  expect_equal(point_sfc_list$type, "GeometryCollection")
  expect_length(point_sfc_list$geometries, 3)
  expect_equal(sapply(point_sfc_list$geometries, function(x) length(x$coordinates)), 
               c(2,2,2))
  
  expect_length(point_sf_list, 2)
  expect_equal(point_sf_list$type, "FeatureCollection")
  expect_length(point_sf_list$features, 3)
  expect_equal(lapply(point_sf_list$features, `[[`, "geometry"), 
               point_sfc_list$geometries)
})

## POLYGON
p1 <- rbind(c(0,0), c(1,0), c(3,2), c(2,4), c(1,4), c(0,0))
p2 <- rbind(c(1,1), c(1,2), c(2,2), c(1,1))
pol <-st_polygon(list(p1,p2))
pol_sfc <- st_sfc(pol)
pol_sf <- st_sf(id = "a", pol_sfc)

## MULTIPOLYGON
p3 <- rbind(c(3,0), c(4,0), c(4,1), c(3,1), c(3,0))
p4 <- rbind(c(3.3,0.3), c(3.8,0.3), c(3.8,0.8), c(3.3,0.8), c(3.3,0.3))[5:1,]
p5 <- rbind(c(3,3), c(4,2), c(4,3), c(3,3))
mpol <- st_multipolygon(list(list(p1,p2), list(p3,p4), list(p5)))
mpol_sfc <- st_sfc(mpol)
mpol_sf <- st_sf(id = "a", mpol_sfc)

test_that("geojson_list works with multipolygons", {
  mpol_sfg_list <- geojson_list(mpol)
  mpol_sfc_list <- geojson_list(mpol_sfc)
  mpol_sf_list <- geojson_list(mpol_sf)
  
  expect_s3_class(mpol_sfg_list, "geo_list")
  expect_s3_class(mpol_sfc_list, "geo_list")
  expect_s3_class(mpol_sf_list, "geo_list")
})

test_that("geojson_json works with multipolygons", {
  mpol_sfg_json <- geojson_json(mpol)
  mpol_sfc_json <- geojson_json(mpol_sfc)
  mpol_sf_json <- geojson_json(mpol_sf)
  
  expect_s3_class(mpol_sfg_json, "geo_json")
  expect_s3_class(mpol_sfc_json, "geo_json")
  expect_s3_class(mpol_sf_json, "geo_json")
  
  expect_equal(unclass(mpol_sfg_json), 
               "{\"type\":\"MultiPolygon\",\"coordinates\":[[[[0,0],[1,0],[3,2],[2,4],[1,4],[0,0]],[[1,1],[1,2],[2,2],[1,1]]],[[[3,0],[4,0],[4,1],[3,1],[3,0]],[[3.3,0.3],[3.3,0.8],[3.8,0.8],[3.8,0.3],[3.3,0.3]]],[[[3,3],[4,2],[4,3],[3,3]]]]}")
  
  expect_equal(unclass(mpol_sfg_json), 
               "{\"type\":\"MultiPolygon\",\"coordinates\":[[[[0,0],[1,0],[3,2],[2,4],[1,4],[0,0]],[[1,1],[1,2],[2,2],[1,1]]],[[[3,0],[4,0],[4,1],[3,1],[3,0]],[[3.3,0.3],[3.3,0.8],[3.8,0.8],[3.8,0.3],[3.3,0.3]]],[[[3,3],[4,2],[4,3],[3,3]]]]}")
  
  expect_equal(unclass(mpol_sfg_json), 
               "{\"type\":\"MultiPolygon\",\"coordinates\":[[[[0,0],[1,0],[3,2],[2,4],[1,4],[0,0]],[[1,1],[1,2],[2,2],[1,1]]],[[[3,0],[4,0],[4,1],[3,1],[3,0]],[[3.3,0.3],[3.3,0.8],[3.8,0.8],[3.8,0.3],[3.3,0.3]]],[[[3,3],[4,2],[4,3],[3,3]]]]}")
})

## TO TEST

# ## MULTIPOINT
# p <- rbind(c(3.2,4), c(3,4.6), c(3.8,4.4), c(3.5,3.8), c(3.4,3.6), c(3.9,4.5))
# mp <- st_multipoint(p)
# ## LINESTRING
# s1 <- rbind(c(0,3),c(0,4),c(1,5),c(2,5))
# ls <- st_linestring(s1)
# ## MULTILINESTRING
# s2 <- rbind(c(0.2,3), c(0.2,4), c(1,4.8), c(2,4.8))
# s3 <- rbind(c(0,4.4), c(0.6,5))
# mls <- st_multilinestring(list(s1,s2,s3))
# ## GEOMETRYCOLLECTION
# gc <- st_geometrycollection(list(mp, mpol, ls))
# gc_sfc <- st_sfc(gc)
# gc_sf <- st_sf(id = "a", gc_sfc)
# 
# geojson_list(gc)
# geojson_list(gc_sfc)
# geojson_list(gc_sf)
# 
# geojson_json(gc)
# geojson_json(gc_sfc)
# geojson_json(gc_sf)



## Big test ------------------------------------------------------

# library(bcmaps)
# eco_sf <- st_as_sf(ecoprovinces)
# eco_geojson <- geojson_json(eco_sf)
# writeLines(eco_geojson, "eco.geojson")
