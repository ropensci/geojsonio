detect_convert_crs <- function(x) {
  UseMethod("detect_convert_crs")
}

detect_convert_crs.sf <- function(x) {
  detect_conver_crs_sf_sfc(x)
}

detect_convert_crs.sfc <- function(x) {
  detect_conver_crs_sf_sfc(x)
}

detect_convert_crs.Spatial <- function(x) {
  if (!is_wgs84(x, warn = FALSE)) {
    message("Converting CRS from EPSG:", 
            epsg_from_proj4(proj4string(x)), " to WGS84.")
    x <- sp::spTransform(x, CRS("+init=epsg:4326"))
  }
  x
}

detect_conver_crs_sf_sfc <- function(x) {
  if (!is_wgs84(x, warn = FALSE)) {
    if (!requireNamespace("sf", quietly = TRUE)) {
      stop("Your input is not in a WGS84 and you don't have the 'sf' package installed. Please install and try again")
    } else {
      message("Converting CRS from EPSG:", st_crs(x), " to WGS84.")
      x <- sf::st_transform(x, 4326)
    }
  }
  x
}

is_wgs84 <- function(x, warn = TRUE) UseMethod("is_wgs84")

is_wgs84.sf <- function(x, warn = TRUE) {
  geom_col <- get_sf_column_name(x)
  crs_attr <- attr((x[[geom_col]]), "crs")
  is_wgs84_sf_attr(crs_attr, warn = warn)
}

is_wgs84.sfc <- function(x, warn = TRUE) {
  crs_attr <- attr(x, "crs")
  is_wgs84_sf_attr(crs_attr, warn = warn)
}

is_wgs84_sf_attr <- function(crs_attr, warn) {
  epsg <- crs_attr[["epsg"]]
  if (is.na(epsg)) {
    is_it <- is_wgs84_proj4(crs_attr[["proj4string"]])
  } else {
    is_it <- epsg == 4326
  }
  is_it <- is_it || is.na(is_it) # Give NA epsg the benefit of the doubt
  if (!is_it && warn) {
    warning("Input CRS is not WGS84 (epsg:4326), the standard for GeoJSON")
  }
  is_it
}

is_wgs84.Spatial <- function(x, warn = TRUE) {
  prj4 <- proj4string(x)
  epsg <- epsg_from_proj4(prj4)
  if (epsg == 4326) {
    is_it <- TRUE
  } else if (is.na(epsg)) {
    is_it <- is_wgs84_proj4(prj4)
    is_it <- is_it || is.na(is_it)
  } else {
    is_it <- FALSE
  }
  if (!is_it && warn) {
    warning("Input CRS is not WGS84 (epsg:4326), the standard for GeoJSON")
  }
  is_it
}

epsg_from_proj4 <- function(prj4) {
  if (grepl("init=epsg", prj4)) {
    ret <- as.integer(gsub("(.*\\init=epsg:)([0-9]{4,5})(.*$)", "\\2", prj4))
  } else {
    ret <- NA_integer_
  }
  ret
}

is_wgs84_proj4 <- function(prj4) {
  if (is.na(prj4)) return(NA_character_)
  grepl("datum=WGS84", prj4) && grepl("proj=longlat", prj4)
}
