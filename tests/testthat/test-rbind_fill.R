test_that("rbind_fill works with built in datasets", {
  skip_on_cran()

  df1 <- data.frame(a = 1:4, b = 5:8)
  df2 <- data.frame(a = 1:4, c = 5:8)
  aa <- geojsonio:::rbind_fill(df1, df2)

  # classes
  expect_s3_class(df1, "data.frame")
  expect_s3_class(df2, "data.frame")
  expect_s3_class(aa, "data.frame")

  # values
  expect_named(df1, c("a", "b"))
  expect_named(df2, c("a", "c"))
  expect_named(aa, c("a", "b", "c"))
})
