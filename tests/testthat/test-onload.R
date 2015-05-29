context("onload")

obj_names <- c('eval', 'assign', 'validate', 'call',
               'reset', 'source', 'console', 'get')

test_that("onload for geojsonhint worked", {
  expect_is(ct, "V8")
  expect_true(all(obj_names %in% ls(ct)))
  expect_true(grepl("function", ct$eval("geojsonhint.hint")))
})
