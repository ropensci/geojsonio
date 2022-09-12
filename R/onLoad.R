#' @importFrom V8 new_context
ct <- NULL
ext <- NULL
topo <- NULL
.onLoad <- function(libname, pkgname) {
  ct <<- V8::v8()
  ct$source(system.file("js/geojsonhint.js", package = pkgname))

  ext <<- V8::v8()
  ext$source(system.file("js/turf_extent.js", package = pkgname))

  topo <<- V8::v8()
  topo$source(system.file("js/topojson-server.js", package = pkgname))
}
