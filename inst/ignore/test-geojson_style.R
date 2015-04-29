context("geojson_style")

test_that("geojson_style works with data.frame inputs", {
  require("RColorBrewer")
  smalluscities <- subset(us_cities, country.etc == 'OR' | country.etc == 'NY' | country.etc == 'CA')
  
  ### Just color
  a <- geojson_style(smalluscities, var = 'country.etc',
     color=RColorBrewer::brewer.pal(length(unique(smalluscities$country.etc)), "Blues"))
  ### Just size
  b <- geojson_style(smalluscities, var = 'country.etc', size=c('small','medium','large'))
  ### Color and size
  c <- geojson_style(smalluscities, var = 'country.etc',
     color=RColorBrewer::brewer.pal(length(unique(smalluscities$country.etc)), "Blues"),
     size=c('small','medium','large'))
  
  expect_is(a, "data.frame")
  expect_is(b, "data.frame")
  expect_is(c, "data.frame")
  expect_match(names(a)[length(names(a))], "marker-color")
  expect_match(names(b)[length(names(b))], "marker-size")
  expect_equal(names(c)[ c(length(names(c)) - 1, length(names(c))) ], c("marker-color", "marker-size"))
  expect_equal(unique(c$`marker-size`), c("small", "medium", "large"))
})

test_that("geojson_style works with list inputs", {
  mylist <- list(list(latitude=30, longitude=120, state="US"),
                 list(latitude=32, longitude=130, state="OR"),
                 list(latitude=38, longitude=125, state="NY"),
                 list(latitude=40, longitude=128, state="VT"))
  # just color
  d <- geojson_style(mylist, var = 'state',
                color=RColorBrewer::brewer.pal(length(unique(sapply(mylist, '[[', 'state'))), "Blues"))
  # color and size
  e <- geojson_style(mylist, var = 'state',
                color=RColorBrewer::brewer.pal(length(unique(sapply(mylist, '[[', 'state'))), "Blues"),
                size=c('small','medium','large','large'))
  # color, size, and symbol
  f <- geojson_style(mylist, var = 'state',
                color=RColorBrewer::brewer.pal(length(unique(sapply(mylist, '[[', 'state'))), "Blues"),
                size=c('small','medium','large','large'),
                symbol="zoo")
  
  expect_is(d, "list")
  expect_is(e, "list")
  expect_is(f, "list")
  expect_match(sapply(d, names)[4, 1], "marker-color")
  expect_match(sapply(e, names)[5, 1], "marker-size")
  expect_equal(sapply(f, names)[4:6, 1], c("marker-color", "marker-symbol", "marker-size"))
  expect_equal(unique(sapply(f, "[[", "marker-size")), c("small", "medium", "large"))
})
