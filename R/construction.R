#' Add together geo_list or json objects
#'
#' @name geojson-add
#' @param x1 An object of class \code{geo_list} or \code{json}
#' @param x2 A component to add to \code{x1}, of class \code{geo_list} or \code{json}
#' 
#' @details If the first object is an object of class \code{geo_list}, you can add
#' another object of class \code{geo_list} or of class \code{json}, and will result 
#' in a \code{geo_list} object. 
#' 
#' If the first object is an object of class \code{json}, you can add
#' another object of class \code{json} or of class \code{geo_list}, and will result 
#' in a \code{json} object.
#' 
#' @seealso \code{\link{geojson_list}}, \code{\link{geojson_json}}
#' @examples \dontrun{
#' # geo_list + geo_list
#' ## Note: geo_list is the output type from geojson_list, it's just a list with 
#' ## a class attached so we know it's geojson :)
#' vec <- c(-99.74,32.45)
#' a <- geojson_list(vec)
#' vecs <- list(c(100.0,0.0), c(101.0,0.0), c(101.0,1.0), c(100.0,1.0), c(100.0,0.0))
#' b <- geojson_list(vecs, geometry="polygon")
#' a + b
#' 
#' # json + json
#' c <- geojson_json(c(-99.74,32.45))
#' vecs <- list(c(100.0,0.0), c(101.0,0.0), c(101.0,1.0), c(100.0,1.0), c(100.0,0.0))
#' d <- geojson_json(vecs, geometry="polygon")
#' c + d
#' (c + d) %>% pretty
#' }

#' @export
#' @method + geo_list
#' @rdname geojson-add
`+.geo_list` <- function(x1, x2) {
  x2name <- deparse(substitute(x2))
  if (is(x1, "geo_list")) {
    add_geolist(x1, x2, x2name)
  } else {
    stop(x1name, " not of class geo_list", call. = FALSE)
  }
}

#' @export
#' @method + json
#' @rdname geojson-add
`+.json` <- function(x1, x2) {
  x2name <- deparse(substitute(x2))
  if (is(x1, "json")) {
    add_json(x1, x2, x2name)
  } else {
    stop(x1name, " not of class json", call. = FALSE)
  }
}

add_geolist <- function(t1, t2, t2name) {
  if (!xor(!is(t2, "geo_list"), !is(t2, "json"))) {
    stop("Don't know how to add ", t2name, " to a geo_list object", call. = FALSE)
  }
  if (is(t2, "geo_list")) { 
    t1$features <- c(t1$features, t2$features)
    att1 <- attr(t1, "from")
    att2 <- attr(t2, "from")
  } else {
    t1$features <- c(t1$features, geojson_list(t2)$features) 
    att1 <- attr(t1, "from")
    att2 <- "json"
  }
  structure(t1, from = c(att1, att2))
}

add_json <- function(t1, t2, t2name) {
  if (!xor(!is(t2, "json"), !is(t2, "geo_list"))) {
    stop("Don't know how to add ", t2name, " to a json object", call. = FALSE)
  }
  if (is(t2, "geo_list")) { 
    jsonlite::toJSON(list(type = "FeatureCollection", 
        features = c(geojson_list(t1)$features, geojson_list(t2)$features)
    ), auto_unbox = TRUE)
  } else {
    jsonlite::toJSON(list(type = "FeatureCollection", 
        features = c(geojson_list(t1)$features, geojson_list(t2)$features)
    ), auto_unbox = TRUE)
  }
}
