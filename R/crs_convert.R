convert_crs <- function(x, init_crs = NULL) {
  UseMethod("convert_crs")
}

convert_crs.sf <- function(x, init_crs = NULL) {
  convert_crs_sf_sfc(x, init_crs = init_crs)
}

convert_crs.sfc <- function(x, init_crs = NULL) {
  convert_crs_sf_sfc(x, init_crs = init_crs)
}

convert_crs.Spatial <- function(x, init_crs = NULL) {
  is_it <- is_wgs84(x, warn = FALSE)
  
  if (is.na(is_it)) {
    if (!is.null(init_crs)) {
      sp::proj4string(x) <- CRS(init_crs)
    }
  } else if (is_it) {
    return(x)
  }
  message("Converting CRS from '", proj4string(x), "' to WGS84.")
  sp::spTransform(x, CRS("+init=epsg:4326"))
}

convert_crs_sf_sfc <- function(x, init_crs) {
  is_it <- is_wgs84(x, warn = FALSE)
  
  if (is.na(is_it)) {
    if (!is.null(init_crs)) {
      sf::st_crs(x) <- init_crs
    }
  } else if (is_it) {
    return(x)
  }
  if (!requireNamespace("sf", quietly = TRUE)) {
    stop("You don't have the 'sf' package installed. Please install and try again")
  } else {
    message("Converting CRS from EPSG:", st_crs(x)[["epsg"]], " to WGS84.")
    x <- sf::st_transform(x, 4326)
  }
}

is_wgs84 <- function(x, warn = TRUE) UseMethod("is_wgs84")

is_wgs84.sf <- function(x, warn = TRUE) {
  geom_col <- get_sf_column_name(x)
  is_wgs84(x[[geom_col]], warn = warn)
}

is_wgs84.sfc <- function(x, warn = TRUE) {
  crs_attr <- attr(x, "crs")
  epsg <- crs_attr[["epsg"]]
  if (is.na(epsg)) {
    is_it <- is_wgs84_proj4(crs_attr[["proj4string"]])
  } else {
    is_it <- epsg == 4326
  }
  if (!is.na(is_it) && !is_it && warn) {
    warning("Input CRS is not WGS84 (epsg:4326), the standard for GeoJSON")
  }
  is_it
}

is_wgs84.Spatial <- function(x, warn = TRUE) {
  prj4 <- proj4string(x)
  is_it <- is_wgs84_proj4(prj4)
  if (!is.na(is_it) && !is_it && warn) {
    warning("Input CRS is not WGS84 (epsg:4326), the standard for GeoJSON")
  }
  is_it
}

is_wgs84_proj4 <- function(prj4) {
  if (is.na(prj4)) return(NA)
  if (grepl("init=epsg:4326", prj4)) return(TRUE)
  if (grepl("datum=WGS84", prj4) && grepl("proj=longlat", prj4)) return(TRUE)
  return(FALSE)
}
