# helper fxn
# x <- "{\"type\":\"FeatureCollection\",\"features\":[{\"type\":\"Feature\",\"geometry\":{\"type\":\"Point\",\"coordinates\":[-99.74,32.45]},\"properties\":{}}]}"
geobuf <- function(x) {
  buf$eval(sprintf("var buffer = geobuf.encode(%s, new geobuf.Pbf());", minify(x)))
  buf$get("buffer")
  
  tmp <- as.list()
  if(identical(tmp, list())){
    return("valid")
  } else {
    tmp
  }
}
