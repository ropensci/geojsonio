context("geojson_list")

test_that("geojson_list works with numeric inputs", {
  # From a numeric vector of length 2, making a point type
  a <- geojson_list(c(-99.74,32.45))
  expect_is(a, "geo_list")
  expect_equal(
    unclass(a),
    structure(list(type = "FeatureCollection", features = list(structure(list(
      type = "Feature", geometry = structure(list(type = "Point",
                                                  coordinates = c(-99.74, 32.45)), .Names = c("type", "coordinates"
                                                  )), properties = NULL), .Names = c("type", "geometry", "properties"
                                                  )))), .Names = c("type", "features"), from = "numeric")
  )
  expect_is(unclass(a), "list")
  expect_equal(a$type, "FeatureCollection")
  expect_equal(a$features[[1]]$type, "Feature")
  expect_equal(attr(a, "from"), "numeric")

  expect_equal(
    unclass(geojson_list(c(-99.74,32.45), type = "GeometryCollection")),
    structure(list(type = "GeometryCollection", geometries = list(
      structure(list(type = "Point", coordinates = c(-99.74, 32.45
      )), .Names = c("type", "coordinates")))), .Names = c("type",
                                                           "geometries"), from = "numeric")
  )

  ## polygon type
  poly <- c(c(-114.345703125,39.436192999314095),
            c(-114.345703125,43.45291889355468),
            c(-106.61132812499999,43.45291889355468),
            c(-106.61132812499999,39.436192999314095),
            c(-114.345703125,39.436192999314095))
  expect_equal(
    unclass(geojson_list(poly, geometry = "polygon")),
    structure(list(type = "FeatureCollection", features = list(structure(list(
        type = "Feature", geometry = structure(list(type = "Polygon",
            coordinates = list(list(c(-114.345703125, 39.4361929993141
            ), c(-114.345703125, 43.4529188935547), c(-106.611328125,
            43.4529188935547), c(-106.611328125, 39.4361929993141
            ), c(-114.345703125, 39.4361929993141)))), .Names = c("type",
        "coordinates")), properties = NULL), .Names = c("type", "geometry",
    "properties")))), .Names = c("type", "features"), from = "numeric")
  )
})

test_that("geojson_list works with data.frame inputs", {
  # From a data.frame to points
  expect_equal(
    unclass(geojson_list(us_cities[1:2,], lat='lat', lon='long')),
    structure(list(type = "FeatureCollection", features = list(structure(list(
    type = "Feature", geometry = structure(list(type = "Point",
        coordinates = c(-99.74, 32.45)), .Names = c("type", "coordinates"
    )), properties = structure(list(name = "Abilene TX", country.etc = "TX",
            pop = "113888", capital = "0"), .Names = c("name", "country.etc",
        "pop", "capital"))), .Names = c("type", "geometry", "properties"
    )), structure(list(type = "Feature", geometry = structure(list(
        type = "Point", coordinates = c(-81.52, 41.08)), .Names = c("type",
    "coordinates")), properties = structure(list(name = "Akron OH",
        country.etc = "OH", pop = "206634", capital = "0"), .Names = c("name",
    "country.etc", "pop", "capital"))), .Names = c("type", "geometry",
    "properties")))), .Names = c("type", "features"), from = "data.frame")
  )

  # from data.frame to polygons
  expect_equal_to_reference(
    object=unclass(geojson_list(states[1:351, ], lat='lat', lon='long', geometry="polygon", group='group')),
    file="numericstates_list.rds"
  )
})

test_that("geojson_list works with data.frame inputs", {
  # from a list
  mylist <- list(list(latitude=30, longitude=120, marker="red"),
                 list(latitude=30, longitude=130, marker="blue"))
  expect_equal(
    unclass(geojson_list(mylist, lat='latitude', lon='longitude')),
    structure(list(type = "FeatureCollection", features = list(structure(list(
    type = "Feature", geometry = structure(list(type = "Point",
        coordinates = c(120, 30)), .Names = c("type", "coordinates"
    )), properties = structure(list(marker = "red"), .Names = "marker")), .Names = c("type",
    "geometry", "properties")), structure(list(type = "Feature",
        geometry = structure(list(type = "Point", coordinates = c(130,
        30)), .Names = c("type", "coordinates")), properties = structure(list(
            marker = "blue"), .Names = "marker")), .Names = c("type",
    "geometry", "properties")))), .Names = c("type", "features"), from = "list")
  )
})

test_that("geojson_list works with data.frame inputs", {
  # from a SpatialPoints class
  x <- c(1,2,3,4,5)
  y <- c(3,2,5,1,4)
  s <- SpatialPoints(cbind(x,y))
  aa <- geojson_list(s)

  expect_is(aa, "geo_list")
  expect_equal(attr(aa, "from"), "SpatialPoints")
  expect_equal(aa$type, "FeatureCollection")
  expect_is(aa$features, "list")
  expect_equal(
    unclass(geojson_list(s)),
    structure(list(type = "FeatureCollection", features = list(structure(list(
    type = "Feature", id = 1L, properties = structure(list(dat = 1L), .Names = "dat"),
    geometry = structure(list(type = "Point", coordinates = c(1,
    3)), .Names = c("type", "coordinates"))), .Names = c("type",
"id", "properties", "geometry")), structure(list(type = "Feature",
    id = 2L, properties = structure(list(dat = 2L), .Names = "dat"),
    geometry = structure(list(type = "Point", coordinates = c(2,
    2)), .Names = c("type", "coordinates"))), .Names = c("type",
"id", "properties", "geometry")), structure(list(type = "Feature",
    id = 3L, properties = structure(list(dat = 3L), .Names = "dat"),
    geometry = structure(list(type = "Point", coordinates = c(3,
    5)), .Names = c("type", "coordinates"))), .Names = c("type",
"id", "properties", "geometry")), structure(list(type = "Feature",
    id = 4L, properties = structure(list(dat = 4L), .Names = "dat"),
    geometry = structure(list(type = "Point", coordinates = c(4,
    1)), .Names = c("type", "coordinates"))), .Names = c("type",
"id", "properties", "geometry")), structure(list(type = "Feature",
    id = 5L, properties = structure(list(dat = 5L), .Names = "dat"),
    geometry = structure(list(type = "Point", coordinates = c(5,
    4)), .Names = c("type", "coordinates"))), .Names = c("type",
"id", "properties", "geometry")))), .Names = c("type", "features"
), from = "SpatialPoints")
  )
})

test_that("geojson_list detects inproper polygons passed as lists inputs", {
  vecs <- list(c(100.0,0.0), c(101.0,0.0), c(101.0,1.0), c(100.0,1.0), c(100.0,0.0))
  fine <- geojson_list(vecs, geometry = "polygon")
  
  expect_is(fine, "geo_list")
  
  vecs <- list(c(100.0,0.0), c(101.0,0.0), c(101.0,1.0), c(100.0,1.0), c(100.0,1))
  expect_error(geojson_list(vecs, geometry = "polygon"),
               "First and last point in a polygon must be identical")
  
  # doesn't matter if geometry != polygon
  vecs <- list(c(100.0,0.0), c(101.0,0.0), c(101.0,1.0), c(100.0,1.0), c(100.0,1))
  expect_is(geojson_list(vecs), "geo_list")
})
