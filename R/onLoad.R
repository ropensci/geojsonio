#' @importFrom V8 new_context
ct <- NULL
ext <- NULL
.onLoad <- function(libname, pkgname){
  ct <<- new_context();
  ct$source(system.file("js/geojsonhint.js", package = pkgname))
  
  ext <<- new_context();
  ext$source(system.file("js/turf_extent.js", package = pkgname))
}

# buf <- NULL
# .onLoad <- function(libname, pkgname){
#   buf <<- new_context();
#   buf$source(system.file("js/geobuf.js", package = pkgname))
# }
