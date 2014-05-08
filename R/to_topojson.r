#' Transform one or several SpatialPolygonsDataFrame into a TopoJSON file
#'
#' \code{toTopoJSON} takes one or several \code{SpatialPolygonsDataFrame} objects and creates a 
#' topojson file, multi-layered if needed. This functions needs the \code{topojson} CLI utility 
#' to be installed (see \link{https://github.com/mbostock/topojson/wiki/Installation}).
#' 
#' @import rgdal sp
#' @export
#' @param shppath a named list of \code{SpatialPolygonsDataFrame} objects. The names of the list 
#' elements need to be the same as the names of the SPDF objects.
#' @param path the path where the topojson file should be registered. By default, the working 
#' directory.
#' @param filename the name of the topojson file, without extension. By default, the name of the 
#' first SPDF object.
#' @param simplification the geometry simplification factor. A numeric between 0 and 1, 0 being the 
#' maximum simplification, 1 retaining all the subtleties of the geometries. See 
#' \link{https://github.com/mbostock/topojson/wiki/Command-Line-Reference} for more details.
#' @param quantisation maximum number of differentiable points along either dimension.
#' @param width width of the desired output (in pixels)
#' @param height height of the desired output (in pixels)
#' @param properties the names of the properties of the SPDFs to be exported to the topojson file. 
#' A vector of character strings. If NULL (the default), all columns of the SPDFs dataframes. 
#' If "", no properties are included in the TopoJSON file.
#' @param id the name of the SPDF column used as ID. By default, no ID.
#' @param projection Map projection to use. See \code{topojson_properties} for possible values. 
#' Raw projections \url{https://github.com/mbostock/d3/wiki/Geo-Projections#raw-projections} are 
#' not currently included. See \url{https://github.com/mbostock/d3/wiki/Geo-Projections} for help
#' on projections.
#' @param projargs Further extensions to projection. See \code{topojson_properties} for arguments, 
#' and see examples below. For help on projection arguments see 
#' \url{https://github.com/mbostock/d3/wiki/Geo-Projections#standard-abstract-projection}.
#' @param ignoreshp (logical) Ignore shapefile properties for faster performance (default: FALSE)
#'
#' @return Nothing. As a side effect, a topojson file is created with file extension \code{.json}.
#' @references Mike Bostock's wiki: \link{https://github.com/mbostock/topojson/wiki}.
#' @examples
#' to_topojson(shppath='~/Downloads/ne_110m_admin_0_countries', simplification=0)
#' to_topojson(shppath='~/Downloads/abieconc', simplification = 0)
#' to_topojson(shppath='~/Downloads/abieconc', simplification = 0, projection="gnomonic")
#' to_topojson(shppath='~/Downloads/querwisl', filename = "querwisl", simplification = 0)
#' 
#' to_topojson(shppath='~/Downloads/querwisl', projection='albers', projargs=list(rotate='[60, -35, 0]'))
#' 
#' to_topojson(shppath='~/Downloads/querwisl', ignoreshp=TRUE)

to_topojson <- function(shppath, path=getwd(), filename=NULL, simplification=0, quantisation="1e4", 
                        width=NULL, height=NULL, properties=NULL, id=NULL, projection=NULL, 
                        projargs=list(), ignoreshp=FALSE) 
{
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

#' topojson projections
#' 
#' @export
#' @param proj Map projection name
#' @param rotate
#' @param center
#' @param translate
#' @param scale
#' @param clipAngle
#' @param precision
#' @param parallels
#' @param clipExtent
#' @param invert
#' @examples
#' projections(proj="albers")
#' projections(proj="albers", rotate='[98 + 00 / 60, -35 - 00 / 60]', scale=5700)
#' projections(proj="albers", scale=5700)
#' projections(proj="albers", translate='[55 * width / 100, 52 * height / 100]')
#' projections(proj="albers", clipAngle=90)
#' projections(proj="albers", precision=0.1)
#' projections(proj="albers", parallels='[30, 62]')
#' projections(proj="albers", clipExtent='[[105 - 87, 40], [105 + 87 + 1e-6, 82 + 1e-6]]')
#' projections(proj="albers", invert=60)
#' projections("orthographic")
#' projections("alber")
projections <- function(proj, rotate=NULL, center=NULL, translate=NULL, scale=NULL, 
                        clipAngle=NULL, precision=NULL, parallels=NULL, clipExtent=NULL, invert=NULL){
  vals <- list(
    albers = 'd3.geo.albers()%s',
    albersUsa = 'd3.geo.albersUsa()',
    azimuthalEqualArea = 'd3.geo.azimuthalEqualArea()',
    azimuthalEquidistant = 'd3.geo.azimuthalEquidistant()',
    conicEqualArea = 'd3.geo.conicEqualArea()',
    conicConformal = 'd3.geo.conicConformal()',
    conicEquidistant = 'd3.geo.conicEquidistant()',
    equirectangular = 'd3.geo.equirectangular()',
    gnomonic = 'd3.geo.gnomonic()',
    mercator = 'd3.geo.mercator()',
    orthographic = 'd3.geo.orthographic()',
    stereographic = 'd3.geo.stereographic()',
    transverseMercator = 'd3.geo.transverseMercator()'
  )
  got <- vals[[proj]]
  args <- togeo_compact(list(rotate=rotate, center=center, translate=translate, scale=scale, 
                             clipAngle=clipAngle, precision=precision, parallels=parallels, 
                             clipExtent=clipExtent, invert=invert))
  out <- list()
  for(i in seq_along(args)){
    out[i] <- sprintf(".%s(%s)", names(args[i]), args[[i]])
  }
  argstogo <- paste(out, collapse = "")
  gotgo <- sprintf(got, argstogo)
  if(is.null(gotgo)){
    "That projection doesn't exist, check your spelling"
  } else { gotgo }
}