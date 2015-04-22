#' @importFrom V8 new_context
ct <- NULL
geo <- NULL
.onLoad <- function(libname, pkgname){
  ct <<- new_context()
  ct$source(system.file("js/geojsonhint.js", package = pkgname))
  
  geo <<- new_context()
  geo$source(system.file("js/geojson2.js", package = pkgname))
}

# buf <- NULL
# .onLoad <- function(libname, pkgname){
#   buf <<- new_context();
#   buf$source(system.file("js/geobuf.js", package = pkgname))
# }
