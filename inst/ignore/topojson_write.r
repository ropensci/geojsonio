#' Transform one or several SpatialPolygonsDataFrame into a TopoJSON file
#'
#' \code{toTopoJSON} takes one or several \code{SpatialPolygonsDataFrame} objects and creates a
#' topojson file, multi-layered if needed. This function needs \code{topojson}
#' \url{https://github.com/mbostock/topojson/wiki/Installation} to be installed.
#'
#' @import rgdal sp
#' @keywords internal
#' @param shppath a named list of \code{SpatialPolygonsDataFrame} objects. The names of the list
#' elements need to be the same as the names of the SPDF objects.
#' @param path the path where the topojson file should be registered. By default, the working
#' directory.
#' @param filename the name of the topojson file, without extension. By default, the name of the
#' first SPDF object.
#' @param simplification the geometry simplification factor. A numeric between 0 and 1, 0 being the
#' maximum simplification, 1 retaining all the subtleties of the geometries. See
#' \url{https://github.com/mbostock/topojson/wiki/Command-Line-Reference} for more details.
#' @param quantisation maximum number of differentiable points along either dimension.
#' @param width width of the desired output (in pixels)
#' @param height height of the desired output (in pixels)
#' @param properties the names of the properties of the SPDFs to be exported to the topojson file.
#' A vector of character strings. If NULL (the default), all columns of the SPDFs dataframes.
#' If "", no properties are included in the TopoJSON file.
#' @param id the name of the SPDF column used as ID. By default, no ID.
#' @param projection Map projection to use. See \code{topojson_properties} for possible values.
#' \url{https://github.com/mbostock/d3/wiki/Geo-Projections#raw-projections} are
#' not currently included. See the
#' \url{https://github.com/mbostock/d3/wiki/Geo-Projections} for help
#' on projections.
#' @param projargs Further extensions to projection. See \code{topojson_properties} for arguments,
#' and see examples below. For help on projection arguments see
#' \url{https://github.com/mbostock/d3/wiki/Geo-Projections#standard-abstract-projection}.
#' @param ignoreshp (logical) Ignore shapefile properties for faster performance (default: FALSE)
#'
#' @return Nothing. As a side effect, a topojson file is created with file extension \code{.json}.
#' @references \url{https://github.com/mbostock/topojson/wiki}
#' @examples \dontrun{
#' topojson_write(shppath='~/github/ropensci/shapefiles/ne_110m_admin_0_countries')
#' topojson_write(shppath='~/Downloads/abieconc')
#' topojson_write(shppath='~/Downloads/abieconc', projection="gnomonic")
#' topojson_write(shppath='~/Downloads/querwisl', filename = "querwisl")
#' topojson_write(shppath='~/Downloads/querwisl', projection='albers',
#'    projargs=list(rotate='[60, -35, 0]'))
#' topojson_write(shppath='~/Downloads/querwisl', ignoreshp=TRUE)
#' }

topojson_write <- function(shppath, path=getwd(), filename=NULL, simplification=0,
  quantisation="1e4", width=NULL, height=NULL, properties=NULL, id=NULL, projection=NULL,
  projargs=list(), ignoreshp=FALSE) {
  
  tmpdir <- tempdir()
  setCPLConfigOption("SHAPE_ENCODING", "UTF-8")

  fullpathtoshp <- path.expand(shppath)
  layer <- ogrListLayers(fullpathtoshp)
  if (is.null(filename)) filename <- layer
  sppolydf <- readOGR(dsn = fullpathtoshp, layer = layer)
  writeOGR(sppolydf, dsn=tmpdir, layer=layer, driver="ESRI Shapefile", overwrite_layer=TRUE)
  dcalc <- function(x, y="width"){
    if(is.null(x)){ "" } else { sprintf("--width %s", x) }
  }
  id2 <- ifelse(is.null(id), "", paste0(" --id-property ", id))
  prop <- ifelse(is.null(properties), "", ifelse(paste(properties, collapse="") %in% "", "",
                                          paste(" -p", properties, collapse="")))
  shp <- sprintf("-- %s/%s.shp", tmpdir, layer)
  if(is.null(projection)){ project <- NULL } else {
    project <- do.call(projections, c(proj=projection, projargs))
  }
  project <- if(is.null(project)){ "" } else { sprintf("--projection '%s'", project) }
  if(ignoreshp){ ignoreshp <- '--ignore-shapefile-properties true'} else{ ignoreshp <- "" }
  call <- sprintf("topojson -o %s/%s.json -q %s %s -s %s %s %s --shapefile-encoding utf8 %s %s %s %s",
    path, filename, quantisation, id2, simplification, dcalc(width), dcalc(height),
    prop, project, ignoreshp, shp)
  call <- gsub("\\s+", " ", call)
  message(call)
  cat("\n")
  system(call)
}
