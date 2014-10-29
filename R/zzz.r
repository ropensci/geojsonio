tg_compact <- function(l) Filter(Negate(is.null), l)

to_json <- function(x, ...) structure(jsonlite::toJSON(x, ..., auto_unbox = TRUE), class=c('json','geo_json'))

list_to_geo_list <- function(x, lat, lon, polygon, object){
  nn <- switch(object, FeatureCollection="features", GeometryCollection="geometries")
  z <- lapply(x, function(l) {
    if (is.null(l[[lat]]) || is.null(l[[lon]])) {
      return(NULL)
    }
    type <- ifelse(is.null(polygon), "Point", "Polygon")
    if(nn == "features"){
    list(type = "Feature",
         geometry = list(type = type,
                         coordinates = as.numeric(c(l[[lon]], l[[lat]]))),
         properties = l[!(names(l) %in% c(lat, lon))])
    } else {
      list(type = type,
          coordinates = as.numeric(c(l[[lon]], l[[lat]])))
    }
  })
  z <- setNames(Filter(function(x) !is.null(x), z), NULL)
  structure(list(object, z), .Names = c('type',nn))
}

df_to_geo_list <- function(x, lat, lon, polygon, object){
  x <- apply(x, 1, as.list)
  list_to_geo_list(x, lat, lon, polygon, object)
}

num_to_geo_list <- function(x, polygon){
  type <- ifelse(is.null(polygon), "Point", "Polygon")
  res <- tryCatch(as.numeric(x), warning = function(e) e)
  if(is(res, "simpleWarning")) stop("Coordinates are not numeric", call. = FALSE) else {
    list(type = type,
         geometry = list(type = "Point", coordinates = x),
         properties = NULL)
  }
}

list_to_geojson <- function(input, file = "myfile.geojson", polygon=NULL, lon, lat, ...){
  input <- data.frame(rbind_all(lapply(input, function(x){
    tmp <- data.frame(type=x$type,
                      geometry_type=x$geometry$type,
                      longitude=x$geometry$coordinates[1],
                      latitude=x$geometry$coordinates[2],
                      x$properties,
                      stringsAsFactors = FALSE)
    #     names(tmp)[5:8] <- paste('properties_', names(tmp)[5:8], sep = "")
    tmp
  })))
  if(is.null(polygon)){
    out <- df_to_SpatialPointsDataFrame(input, lon=lon, lat=lat)
  } else {
    out <- df_to_SpatialPolygonsDataFrame(input)
  }
  write_geojson(out, file, ...)
}

df_to_SpatialPolygonsDataFrame <- function(x){
  x_split <- split(x, f = x$group)
  res <- lapply(x_split, function(y){
    coordinates(y) <- c("long","lat")
    Polygon(y)
  })
  res <- Polygons(res, "polygons")
  hh <- SpatialPolygons(list(res))
  as(hh, "SpatialPolygonsDataFrame")
}

df_to_SpatialPointsDataFrame <- function(x, lon, lat) { coordinates(x) <- c(lon,lat); x }

bbox2df <- function(x) c(x[1,1], x[1,2], x[2,1], x[2,2])

sppolytogeolist <- function(x){
  list(type = "Polygon",
       bbox = bbox2df(x@bbox),
       coordinates =
         lapply(x@polygons, function(l) {
           apply(l@Polygons[[1]]@coords, 1, as.list)
         }),
       properties = NULL
  )
  # setNames(Filter(function(x) !is.null(x), x), NULL)
}

spdftogeolist <- function(x){
  list(type = "MultiPoint",
       bbox = bbox2df(x@bbox),
       coordinates = apply(x@coords,  1, as.list),
       properties = NULL
  )
}

write_geojson <- function(input, file = "myfile.geojson", ...){
  if (!grepl("\\.geojson$", file)) {
    file <- paste0(file, ".geojson")
  }
  file <- path.expand(file)
  unlink(file)
  destpath <- dirname(file)
  if (!file.exists(destpath)) dir.create(destpath)
  write_ogr(input, tempfile(), file, ...)
}

write_ogr <- function(input, dir, file, ...){
  input@data <- convert_ordered(input@data)
  writeOGR(input, dir, "", "GeoJSON", ...)
  file.rename(dir, file)
  message("Success! File is at ", file)
}

convert_ordered <- function(df) {
  data.frame(lapply(df, function(x) {
    if ("ordered" %in% class(x)) x <- as.character(x)
    x
  }),
  stringsAsFactors = FALSE)
}

#' Pipe operator
#'
#' @name %>%
#' @rdname pipe
#' @keywords internal
#' @export
#' @importFrom magrittr %>%
#' @usage lhs \%>\% rhs
NULL
