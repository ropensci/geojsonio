tg_compact <- function(l) Filter(Negate(is.null), l)

to_json <- function(x, ...) {
  structure(jsonlite::toJSON(x, ..., digits = 22, auto_unbox = TRUE), 
            class = c('json','geo_json'))
}

list_to_geo_list <- function(x, lat, lon, geometry = "point", type = "FeatureCollection", unnamed = FALSE, group=NULL){
  nn <- switch(type, FeatureCollection = "features", GeometryCollection = "geometries")
  geom <- capwords(match.arg(geometry, c("point", "polygon")))
  if (geom == "Point") {
    z <- lapply(x, function(l) {
      if (!unnamed) {
        if (is.null(l[[lat]]) || is.null(l[[lon]])) {
          return(NULL)
        }
      }
      if (nn == "features") {
        list(type = "Feature",
             geometry = list(type = geom,
                             coordinates = get_vals(l, lat, lon)),
             properties = l[!(names(l) %in% c(lat, lon))])
      } else {
        list(type = geom,
             coordinates = get_vals(l, lat, lon))
      }
    })
    z <- setNames(Filter(function(x) !is.null(x), z), NULL)
    structure(list(type, z), .Names = c('type', nn))
  } else {
    if (!unnamed) {
      if (is.null(x[[lat]]) || is.null(x[[lon]])) {
        return(NULL)
      }
    }
    if (nn == "features") {
      if (is.null(group)) {
        z <- list(list(type = "Feature",
                  geometry = list(type = geom, coordinates = get_vals2(x, unnamed, lat, lon)),
                  properties = get_props(x, lat, lon)))
      } else {
        grps <- unique(pluck(x, group, ""))
        z <- lapply(grps, function(w) {
          use <- Filter(function(m) m$group == w, x)
          list(type = "Feature",
               geometry = list(type = geom, coordinates = list(unname(get_vals2(use, FALSE, lat, lon)))),
               properties = get_props(use[[1]], lat, lon))
        })
      }
    } else {
      z <- list(type = geom, coordinates = get_vals2(x, unnamed, lat, lon))
    }
    structure(list(type, z), .Names = c('type', nn))
  }
}

get_props <- function(x, lat, lon){
  x[!(names(x) %in% c(lat, lon))]
}

get_vals2 <- function(v, unnamed, lat, lon){
  if (unnamed) {
    list(v)
  } else {
    unname(lapply(v, function(g) as.numeric(gsub("^\\s+|\\s+$", "", unlist(unname(g[names(g) %in% c(lat, lon)]))))))
  }
}

get_vals <- function(v, lat, lon){
  tt <- tryCatch(v[[lon]], error = function(e) e)
  if (is(tt, "simpleError")) {
    as.numeric(v)
  } else {
    as.numeric(c(v[[lon]], v[[lat]]))
  }
}

df_to_geo_list <- function(x, lat, lon, geometry, type, group, ...){
  x <- apply(x, 1, as.list)
  list_to_geo_list(x = x, lat = lat, lon = lon, geometry = geometry, 
                   type = type, unnamed = TRUE, group = group, ...)
}

num_to_geo_list <- function(x, geometry = "point", type = "FeatureCollection"){
  geom <- capwords(match.arg(geometry, c("point", "polygon")))
  res <- tryCatch(as.numeric(x), warning = function(e) e)
  if (is(res, "simpleWarning")) {
    stop("Coordinates are not numeric", call. = FALSE)
  } else {
    switch(type,
           FeatureCollection = {
             list(type = 'FeatureCollection',
                  features = list(
                    list(type = "Feature",
                         geometry = list(type = geom, coordinates = makecoords(x, geom)),
                         properties = NULL)
                  )
             )
           },
           GeometryCollection = {
             list(type = 'GeometryCollection',
                  geometries = list(
                    list(type = geom, coordinates = makecoords(x, geom))
                  )
             )
           }
    )
  }
}

makecoords <- function(x, y) {
  switch(y,
         Point = x,
         Polygon = list( unname(split(x, ceiling(seq_along(x)/2))))
  )
}

list_to_geojson <- function(input, file = "myfile.geojson", geometry="point", lon, lat, ...){
  input <- rbind_fill(lapply(input$features, function(x){
    data.frame(geometry_type = x$geometry$type,
               longitude = x$geometry$coordinates[1],
               latitude = x$geometry$coordinates[2],
               x$properties,
               stringsAsFactors = FALSE)
  }))
  if (geometry == "point") {
    out <- df_to_SpatialPointsDataFrame(input, lon, lat)
  } else {
    out <- df_to_SpatialPolygonsDataFrame(input)
  }
  write_geojson(out, file, ...)
}

df_to_SpatialPolygonsDataFrame <- function(x, lat, lon){
  x <- makecoords(x, "Polygon")[[1]]
  res <- Polygon(cbind(sapply(x, function(z) z[1]), sapply(x, function(z) z[2])))
  hh <- SpatialPolygons(list(Polygons(list(res), "polygons")))
  as(hh, "SpatialPolygonsDataFrame")
}

df_to_SpatialPolygonsDataFrame2 <- function(x, lat, lon, group) {
  xsplit <- split(x, x[group])
  polys <- lapply(xsplit, function(z){
    Polygon(cbind(z[lon], z[lat]))
  })
  bb <- SpatialPolygons(list(Polygons(polys, ID = "s1")))
  as(bb, "SpatialPolygonsDataFrame")
}

list_to_SpatialPolygonsDataFrame <- function(x, lat, lon) {
  res <- Polygon(cbind(sapply(x, function(z) z[1]), sapply(x, function(z) z[2])))
  hh <- SpatialPolygons(list(Polygons(list(res), "polygons")))
  as(hh, "SpatialPolygonsDataFrame")
}

list_to_SpatialPointsDataFrame <- function(x, lat, lon){
  df <- data.frame(cbind(sapply(x, function(z) z[1]), sapply(x, function(z) z[2])))
  res <- SpatialPoints(df)
  SpatialPointsDataFrame(res, df)
}

df_to_SpatialPointsDataFrame <- function(x, lon, lat) {
  if (is.null(lat)) lat <- "lat"
  if (is.null(lon)) lon <- "lon"
  x2 <- x
  coordinates(x2) <- c(lon, lat)
  SpatialPointsDataFrame(x2, x)
}

bbox2df <- function(x) c(x[1, 1], x[1, 2], x[2, 1], x[2, 2])

sppolytogeolist <- function(x){
  list(type = "Polygon",
       bbox = bbox2df(x@bbox),
       coordinates =
         lapply(x@polygons, function(l) {
           apply(l@Polygons[[1]]@coords, 1, as.list)
         }),
       properties = NULL
  )
}

lines_to_geo_list <- function(x, object="FeatureCollection"){
  nn <- switch(object, FeatureCollection = "features", GeometryCollection = "geometries")
  if ( length(x@lines) == 1 ) {
    list(type = "LineString",
         bbox = bbox2df(x@bbox),
         coordinates = apply(x@lines[[1]]@Lines[[1]]@coords, 1, as.list),
         properties = NULL
    )
  } else {
    z <- lapply(x@lines, function(l) {
      if (nn == "features") {
        list(type = "Feature",
             bbox = bbox2df(x@bbox),
             geometry = list(type = ifelse(length(l@Lines) == 1, "LineString", "MultiLineString"),
                             coordinates =
                             if (length(l@Lines) == 1) {
                               apply(l@Lines[[1]]@coords, 1, as.list)
                             } else {
                               lapply(l@Lines, function(w) {
                                 apply(w@coords, 1, as.list)
                               })
                             }
             ),
             properties = datdat(x, l) )
      } else {
        list(type = "LineString",
             bbox = bbox2df(x@bbox),
             coordinates = l,
             properties = datdat(x, l) )
      }
    })
    z <- setNames(Filter(function(x) !is.null(x), z), NULL)
    structure(list(object, z), .Names = c('type', nn))
  }
}

datdat <- function(x, l){
  tmp <- data.frame(x@data)[row.names(data.frame(x@data)) == l@ID , ]
  lapply(as.list(tmp), as.character)
}

splinestogeolist <- function(x, object){
  if (is(x, "SpatialLinesDataFrame")) {
    lines_to_geo_list(x, object)
  } else {
    if ( length(x@lines) == 1 ) {
      list(type = "LineString",
           bbox = bbox2df(x@bbox),
           coordinates = apply(x@lines[[1]]@Lines[[1]]@coords, 1, as.list),
           properties = NULL
      )
    } else {
      list(type = "MultiLineString",
           bbox = bbox2df(x@bbox),
           coordinates =
           lapply(x@lines, function(l) {
             apply(l@Lines[[1]]@coords, 1, as.list)
           }),
           properties = NULL
      )
    }
  }
}

spdftogeolist <- function(x){
  if (is(x, "SpatialPointsDataFrame") || is(x, "SpatialGridDataFrame")) {
    #nms <- dimnames(x)[[2]]
    nms <- suppressMessages(guess_latlon(names(data.frame(x))))
    temp <- apply(data.frame(x), 1, as.list)
    list_to_geo_list(temp, nms$lat, nms$lon, NULL, type = "FeatureCollection")
  } else if (is(x, "SpatialPolygonsDataFrame")) {
    geojson_list(x)
  } else {
    list(type = "MultiPoint",
         bbox = bbox2df(x@bbox),
         coordinates = unname(apply(coordinates(x), 1, function(x) unname(as.list(x)))),
         properties = NULL
    )
  }
}

write_geojson <- function(input, file = "myfile.geojson", precision = NULL, overwrite = TRUE, ...){
  if (!grepl("\\.geojson$", file)) {
    file <- paste0(file, ".geojson")
  }
  file <- path.expand(file)
  destpath <- dirname(file)
  if (!file.exists(destpath)) dir.create(destpath)
  write_ogr(input, tempfile(), file, precision, overwrite, ...)
}

write_ogr <- function(input, dir, file, precision = NULL, overwrite, ...){
  input@data <- convert_ordered(input@data)
  dots <- list(...)
  if (!is.null(precision)) {
    ## add precision to vector of layer_options in '...'
    dots$layer_options <- c(dots$layer_options, paste0("COORDINATE_PRECISION=", precision))
  }
  args <- c(list(obj = input, dsn = dir, layer = "", driver = "GeoJSON"), dots)
  do.call(writeOGR, args)
  res <- file.copy(dir, file, overwrite = overwrite)
  if (res) {
    message("Success! File is at ", file)
  } else {
    stop(file, " already exists and overwrite = FALSE", call. = FALSE)
  }
}

convert_ordered <- function(df) {
  df[] <- lapply(df, function(x) {
    if (is(x, "ordered")) x <- as.character(x)
    x
  })
  return(df)
}

geojson_rw <- function(input, ...){
  if (is(input, "SpatialCollections")) {
    tmp <- tempfile(fileext = ".geojson")
    tmp2 <- suppressMessages(geojson_write(input, file = tmp))
    paths <- vapply(tg_compact(tmp2), "[[", "", "path")
    lapply(paths, jsonlite::fromJSON, simplifyDataFrame = FALSE, simplifyMatrix = FALSE, ...)
  } else {
    tmp <- tempfile(fileext = ".geojson")
    suppressMessages(geojson_write(input, file = tmp))
    jsonlite::fromJSON(tmp, simplifyDataFrame = FALSE, simplifyMatrix = FALSE, ...)
  }
}

capwords <- function(s, strict = FALSE, onlyfirst = FALSE) {
  cap <- function(s) paste(toupper(substring(s, 1, 1)),
                           {s <- substring(s, 2); if (strict) tolower(s) else s}, sep = "", collapse = " " )
  if (!onlyfirst) {
    sapply(strsplit(s, split = " "), cap, USE.NAMES = !is.null(names(s)))
  } else {
    sapply(s, function(x)
      paste(toupper(substring(x, 1, 1)),
            tolower(substring(x, 2)),
            sep = "", collapse = " "), USE.NAMES = FALSE)
  }
}


pluck <- function(x, name, type) {
  if (missing(type)) {
    lapply(x, "[[", name)
  } else {
    vapply(x, "[[", name, FUN.VALUE = type)
  }
}

###### code adapted from the leaflet package - source at github.com/rstudio/leaflet
guess_latlon <- function(x, lat=NULL, lon=NULL) {
  if (is.null(lat) && is.null(lon)) {
    lats <- x[grep("^(lat|latitude)$", x, ignore.case = TRUE)]
    lngs <- x[grep("^(lon|lng|long|longitude)$", x, ignore.case = TRUE)]

    if (length(lats) == 1 && length(lngs) == 1) {
      if (length(x) > 2) {
        message("Assuming '", lngs, "' and '", lats,
                "' are longitude and latitude, respectively")
      }
      return(list(lon = lngs, lat = lats))
    } else {
      stop("Couldn't infer longitude/latitude columns, please specify with 'lat'/'lon' parameters", call. = FALSE)
    }
  } else {
    return(list(lon = lon, lat = lat))
  }
}

is.named <- function(x) {
  is.character(names(x[[1]]))
}

