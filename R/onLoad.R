#' @importFrom V8 new_context
ext <- NULL
topo <- NULL
.onLoad <- function(libname, pkgname) {
  ext <<- V8::v8()
  ext$source(system.file("js/turf_extent.js", package = pkgname))

  topo <<- V8::v8()
  topo$source(system.file("js/topojson-server.js", package = pkgname))
}
