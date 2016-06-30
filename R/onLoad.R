#' @importFrom V8 new_context
ext <- NULL
.onLoad <- function(libname, pkgname){
  ext <<- new_context();
  ext$source(system.file("js/turf_extent.js", package = pkgname))
}

# buf <- NULL
# .onLoad <- function(libname, pkgname){
#   buf <<- new_context();
#   buf$source(system.file("js/geobuf.js", package = pkgname))
# }
