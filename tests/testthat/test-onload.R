context("onload")

obj_names <- c('eval', 'assign', 'validate', 'call',
               'reset', 'source', 'console', 'get')

test_that("onload for geojsonhint worked", {
  expect_is(ct, "V8")
  expect_true(all(obj_names %in% ls(ct)))
  expect_true(any(grepl("geojsonhint", ct$get(JS("Object.keys(global)")))))
  
  expect_equal(ct$eval("geojsonhint"), "[object Object]")
  expect_true(grepl("function hint\\(str\\)", ct$eval("geojsonhint.hint")))
})

test_that("onload for turf-extent worked", {
  expect_is(ext, "V8")
  expect_true(all(obj_names %in% ls(ext)))
  expect_true(any(grepl("extent", ext$get(JS("Object.keys(global)")))))
})
