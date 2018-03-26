context("test-geo_topo.R")

test_that("geo2topo works", {
  x <- '{"type": "LineString", "coordinates": [ [100.0, 0.0], [101.0, 1.0] ]}'
  z <- geo2topo(x)
  expect_s3_class(z, "json")
  expect_equal(unclass(z), 
               '{"type":"Topology","objects":{"foo":{"type":"LineString","arcs":[0]}},"arcs":[[[100,0],[101,1]]],"bbox":[100,0,101,1]}')
})

test_that("geo2topo works on a list", {
  x <- list(
    '{"type": "LineString", "coordinates": [ [100, 0], [101, 1] ]}',
    '{"type": "LineString", "coordinates": [ [110, 0], [110, 1] ]}',
    '{"type": "LineString", "coordinates": [ [120, 0], [121, 1] ]}'
  )
  z <- geo2topo(x)
  expect_is(z, "list")
  lapply(z, expect_s3_class, "json")
})

test_that("setting the object_name in geo2topo works", {
  x <- '{"type": "LineString", "coordinates": [ [100.0, 0.0], [101.0, 1.0] ]}'
  z <- geo2topo(x, object_name = "HelloWorld")
  expect_true(grepl("HelloWorld", z))
  
  y <- list(
    '{"type": "LineString", "coordinates": [ [100, 0], [101, 1] ]}',
    '{"type": "LineString", "coordinates": [ [110, 0], [110, 1] ]}',
    '{"type": "LineString", "coordinates": [ [120, 0], [121, 1] ]}'
  )
  nms <- c("A", "B", "C")
  a <- geo2topo(y, nms)
  lapply(seq_along(a), function(x) {
    expect_true(grepl(nms[x], a[[x]]))
  })
})

test_that("topo2geo works", {
  z <- '{"type":"Topology","objects":{"foo":{"type":"LineString","arcs":[0]}},"arcs":[[[100,0],[101,1]]],"bbox":[100,0,101,1]}'
  w <- topo2geo(z)
  expect_s3_class(w, "geofeaturecollection")
})

