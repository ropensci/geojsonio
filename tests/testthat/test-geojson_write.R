test_that("precision argument works with polygons in geojson_write", {
  skip_on_travis()
  skip_on_cran()

  poly <- c(
    c(-114.345703125, 39.436192999314095),
    c(-114.345703125, 43.45291889355468),
    c(-106.61132812499999, 43.45291889355468),
    c(-106.61132812499999, 39.436192999314095),
    c(-114.345703125, 39.436192999314095)
  )
  gwf1 <- withr::local_tempfile(fileext = ".geojson")
  a <- supw(supm(geojson_write(poly, geometry = "polygon", file = gwf1)))
  expect_s3_class(a, "geojson_file")
  a_txt <- gsub("\\s+", " ", paste0(readLines(gwf1), collapse = ""))
  expect_equal(as.numeric(jqr::jq(a_txt, ".features[] | length")), 3)

  gwf2 <- withr::local_tempfile(fileext = ".geojson")
  b <- supw(supm(geojson_write(poly, geometry = "polygon", precision = 2, file = gwf2)))
  expect_s3_class(b, "geojson_file")
  b_txt <- gsub("\\s+", " ", paste0(readLines(gwf2), collapse = ""))
  expect_equal(
    unclass(jqr::jq(b_txt, "del(.name) | del(.crs)")),
    "{\"type\":\"FeatureCollection\",\"features\":[{\"type\":\"Feature\",\"properties\":{\"dummy\":0},\"geometry\":{\"type\":\"Polygon\",\"coordinates\":[[[-114.35,39.44],[-114.35,43.45],[-106.61,43.45],[-106.61,39.44],[-114.35,39.44]]]}}]}"
  )
})

test_that("precision argument works with points in geojson_write", {
  skip_on_travis()
  skip_on_cran()

  gwf3 <- withr::local_tempfile(fileext = ".geojson")
  cc <- supm(geojson_write(us_cities[1:2, ], lat = "lat", lon = "long", precision = 2, file = gwf3))
  expect_s3_class(cc, "geojson_file")
  cc_txt <- gsub("\\s+", " ", paste0(readLines(gwf3), collapse = ""))
  expect_equal(
    unclass(jqr::jq(cc_txt, "del(.name) | del(.crs)")),
    "{\"type\":\"FeatureCollection\",\"features\":[{\"type\":\"Feature\",\"properties\":{\"name\":\"Abilene TX\",\"country.etc\":\"TX\",\"pop\":113888,\"lat\":32.45,\"long\":-99.74,\"capital\":0},\"geometry\":{\"type\":\"Point\",\"coordinates\":[-99.74,32.45]}},{\"type\":\"Feature\",\"properties\":{\"name\":\"Akron OH\",\"country.etc\":\"OH\",\"pop\":206634,\"lat\":41.08,\"long\":-81.52,\"capital\":0},\"geometry\":{\"type\":\"Point\",\"coordinates\":[-81.52,41.08]}}]}"
  )

  gwf4 <- withr::local_tempfile(fileext = ".geojson")
  d <- supm(geojson_write(us_cities[1:2, ], lat = "lat", lon = "long", precision = 1, file = gwf4))
  expect_s3_class(d, "geojson_file")
  d_txt <- gsub("\\s+", " ", paste0(readLines(gwf4), collapse = ""))
  expect_equal(
    unclass(jqr::jq(d_txt, "del(.name) | del(.crs)")),
    "{\"type\":\"FeatureCollection\",\"features\":[{\"type\":\"Feature\",\"properties\":{\"name\":\"Abilene TX\",\"country.etc\":\"TX\",\"pop\":113888,\"lat\":32.45,\"long\":-99.74,\"capital\":0},\"geometry\":{\"type\":\"Point\",\"coordinates\":[-99.7,32.5]}},{\"type\":\"Feature\",\"properties\":{\"name\":\"Akron OH\",\"country.etc\":\"OH\",\"pop\":206634,\"lat\":41.08,\"long\":-81.52,\"capital\":0},\"geometry\":{\"type\":\"Point\",\"coordinates\":[-81.5,41.1]}}]}"
  )
})

test_that("precision argument works with sp objects in geojson_write", {
  skip_on_travis()
  skip_on_cran()

  poly1 <- Polygons(list(Polygon(cbind(
    c(-100.111, -90.111, -85.111, -100.111),
    c(40.111, 50.111, 45.111, 40.111)
  ))), "1")
  poly2 <- Polygons(list(Polygon(cbind(
    c(-90.111, -80.111, -75.111, -90.111),
    c(30.111, 40.111, 35.111, 30.111)
  ))), "2")
  sp_poly <- SpatialPolygons(list(poly1, poly2), 1:2)

  gwf5 <- withr::local_tempfile(fileext = ".geojson")
  e <- supm(geojson_write(sp_poly, file = gwf5))
  expect_s3_class(e, "geojson_file")
  e_txt <- gsub("\\s+", " ", paste0(readLines(gwf5), collapse = ""))
  expect_equal(
    unclass(jqr::jq(e_txt, "del(.name) | del(.crs)")),
    "{\"type\":\"FeatureCollection\",\"features\":[{\"type\":\"Feature\",\"properties\":{\"dummy\":0},\"geometry\":{\"type\":\"Polygon\",\"coordinates\":[[[-100.111,40.111],[-90.111,50.111],[-85.111,45.111],[-100.111,40.111]]]}},{\"type\":\"Feature\",\"properties\":{\"dummy\":0},\"geometry\":{\"type\":\"Polygon\",\"coordinates\":[[[-90.111,30.111],[-80.111,40.111],[-75.111,35.111],[-90.111,30.111]]]}}]}"
  )

  gwf6 <- withr::local_tempfile(fileext = ".geojson")
  f <- supm(geojson_write(sp_poly, precision = 2, file = gwf6))
  expect_s3_class(f, "geojson_file")
  f_txt <- gsub("\\s+", " ", paste0(readLines(gwf6), collapse = ""))
  expect_equal(
    unclass(jqr::jq(f_txt, "del(.name) | del(.crs)")),
    "{\"type\":\"FeatureCollection\",\"features\":[{\"type\":\"Feature\",\"properties\":{\"dummy\":0},\"geometry\":{\"type\":\"Polygon\",\"coordinates\":[[[-100.11,40.11],[-90.11,50.11],[-85.11,45.11],[-100.11,40.11]]]}},{\"type\":\"Feature\",\"properties\":{\"dummy\":0},\"geometry\":{\"type\":\"Polygon\",\"coordinates\":[[[-90.11,30.11],[-80.11,40.11],[-75.11,35.11],[-90.11,30.11]]]}}]}"
  )
})

test_that("geojson_write detects inproper polygons passed as lists inputs", {
  skip_on_cran()

  good <- list(c(100.0, 0.0), c(101.0, 0.0), c(101.0, 1.0), c(100.0, 1.0), c(100.0, 0.0))
  bad <- list(c(100.0, 0.0), c(101.0, 0.0), c(101.0, 1.0), c(100.0, 1.0), c(100.0, 1))

  # fine
  gwf7 <- withr::local_tempfile(fileext = ".geojson")
  fine <- supw(supm(geojson_write(good, geometry = "polygon", file = gwf7)))
  expect_s3_class(fine, "geojson_file")
  expect_type(fine[[1]], "character")

  # bad
  expect_error(
    geojson_write(bad, geometry = "polygon"),
    "First and last point in a polygon must be identical"
  )

  # doesn't matter if geometry != polygon
  expect_s3_class(
    supm(geojson_write(
      bad,
      file = withr::local_tempfile(fileext = ".geojson")
    )),
    "geojson_file"
  )
})

test_that("geojson_write unclasses columns with special classes so writeOGR works", {
  skip_on_cran()

  poly1 <- Polygons(list(Polygon(cbind(
    c(-100, -90, -85, -100),
    c(40, 50, 45, 40)
  ))), "1")
  spdf <- SpatialPolygonsDataFrame(
    SpatialPolygons(list(poly1), 1L),
    data.frame(
      a = structure(1.5, class = "units"),
      b = ordered("z")
    )
  )
  gwf8 <- withr::local_tempfile(fileext = ".geojson")
  expect_s3_class(
    supm(geojson_write(spdf, file = gwf8)), 
    "geojson_file"
  )
  if (requireNamespace("sf", quietly = TRUE)) {
    spdf2 <- as(sf::st_read(gwf8, quiet = TRUE, stringsAsFactors = FALSE), "Spatial")
    expect_type(spdf2@data$a, "double")
    expect_type(spdf2@data$b, "character")
  }
})

test_that("geojson_write passes toJSON args", {
  skip_on_cran()
  expected_na_no_pretty <- "{\"type\":\"FeatureCollection\",\"features\":[{\"type\":\"Feature\",\"properties\":{\"x\":1.1},\"geometry\":{\"type\":\"Point\",\"coordinates\":[3.2,4]}},{\"type\":\"Feature\",\"properties\":{\"x\":2.2},\"geometry\":{\"type\":\"Point\",\"coordinates\":[3,4.6]}},{\"type\":\"Feature\",\"properties\":{\"x\":\"NA\"},\"geometry\":{\"type\":\"Point\",\"coordinates\":[3.8,4.4]}}]}"
  expected_null_pretty <- c(
    "{", "  \"type\": \"FeatureCollection\",", "  \"features\": [",
    "    {", "      \"type\": \"Feature\",", "      \"properties\": {",
    "        \"x\": 1.1", "      },", "      \"geometry\": {", "        \"type\": \"Point\",",
    "        \"coordinates\": [3.2, 4]", "      }", "    },", "    {",
    "      \"type\": \"Feature\",", "      \"properties\": {", "        \"x\": 2.2",
    "      },", "      \"geometry\": {", "        \"type\": \"Point\",",
    "        \"coordinates\": [3, 4.6]", "      }", "    },", "    {",
    "      \"type\": \"Feature\",", "      \"properties\": {", "        \"x\": null",
    "      },", "      \"geometry\": {", "        \"type\": \"Point\",",
    "        \"coordinates\": [3.8, 4.4]", "      }", "    }", "  ]",
    "}"
  )

  if (requireNamespace("sf", quietly = TRUE)) {
    p_list <- lapply(list(c(3.2, 4), c(3, 4.6), c(3.8, 4.4)), sf::st_point)
    pt_sfc <- sf::st_sfc(p_list)
    pt_sf <- sf::st_sf(x = c(1.1, 2.2, NA_real_), pt_sfc)

    gwf9 <- withr::local_tempfile(fileext = ".geojson")

    supm(geojson_write(pt_sf, file = gwf9))
    expect_equal(readLines(gwf9, warn = FALSE), expected_na_no_pretty)

    gwf10 <- withr::local_tempfile(fileext = ".geojson")
    supm(geojson_write(pt_sf, file = gwf10, na = "null", pretty = TRUE))
    expect_equal(readLines(gwf10, warn = FALSE), expected_null_pretty)
  }

  pt_geo_list <-
    structure(
      list(
        type = "FeatureCollection",
        features = list(
          list(
            type = "Feature",
            properties = list(x = 1.1),
            geometry = list(type = "Point", coordinates = c(3.2, 4))
          ),
          list(
            type = "Feature",
            properties = list(x = 2.2),
            geometry = list(type = "Point", coordinates = c(3, 4.6))
          ),
          list(
            type = "Feature",
            properties = list(x = NA_real_),
            geometry = list(type = "Point", coordinates = c(3.8, 4.4))
          )
        )
      ),
      class = "geo_list"
    )

  gwf11 <- withr::local_tempfile(fileext = ".geojson")

  supm(geojson_write(pt_geo_list, file = gwf11))
  expect_equal(readLines(gwf11, warn = FALSE), expected_na_no_pretty)

  gwf12 <- withr::local_tempfile(fileext = ".geojson")
  supm(geojson_write(pt_geo_list, file = gwf12, na = "null", pretty = TRUE))
  expect_equal(readLines(gwf12, warn = FALSE), expected_null_pretty)
})
