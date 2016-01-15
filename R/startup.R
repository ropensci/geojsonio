.onAttach <- function(libname, pkgname) {
  packageStartupMessage("\nWe recommend using rgdal v1.1-1 or greater, but we don't require it\nrgdal::writeOGR in previous versions didn't write\nmultipolygon objects to geojson correctly.\nSee https://stat.ethz.ch/pipermail/r-sig-geo/2015-October/023609.html")
}
