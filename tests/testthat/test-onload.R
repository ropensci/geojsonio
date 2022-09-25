skip_on_cran()

obj_names <- c(
  "eval", "assign", "validate", "call",
  "reset", "source", "console", "get"
)

test_that("onload for turf-extent worked", {
  expect_s3_class(ext, "V8")
  expect_true(all(obj_names %in% ls(ext)))
  expect_true(any(grepl("extent", ext$get(leaflet::JS("Object.keys(global)")))))
})
