#' @param method (character) One of "web" (default) or "local". Matches on 
#' partial strings. This parameter determines how the data is 
#' read. "web" means we use the Ogre web service, and "local" means we use 
#' \pkg{rgdal}. See Details fore more.
#' @param parse (logical) To parse geojson to data.frame like structures if 
#' possible. Default: \code{FALSE}
#' @param ... Additional parameters passed to \code{\link[rgdal]{readOGR}}
#' 
#' @section Method parameter:
#' The web option uses the Ogre web API. Ogre currently has an output size 
#' limit of 15MB. See here \url{http://ogre.adc4gis.com/} for info on the 
#' Ogre web API. The local option uses the function \code{\link{writeOGR}} 
#' from the package rgdal.
#' 
#' @section Ogre:
#' Note that for Shapefiles, GML, MapInfo, and VRT, you need to send zip files
#' to Ogre. For other file types (.bna, .csv, .dgn, .dxf, .gxt, .txt, .json,
#' .geojson, .rss, .georss, .xml, .gmt, .kml, .kmz) you send the actual file 
#' with that file extension.
#'
#' @section Linting GeoJSON:
#' If you're having trouble rendering GeoJSON files, ensure you have a valid
#' GeoJSON file by running it through the package \pkg{geojsonlint}, which 
#' has a variety of different GeoJSON linters.
