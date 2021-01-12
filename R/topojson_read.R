#' Read topojson from a local file or a URL
#'
#' @export
#'
#' @param x Path to a local file or a URL.
#' @param ... Further args passed on to [sf::st_read()]. Can use any args
#' from `sf::st_read()` except `quiet`, which we have set as `quiet = TRUE`
#' internally already
#' 
#' @return an object of class `sf`/`data.frame`
#' 
#' @details Returns a `sf` class, but you can easily and quickly get 
#' this to geojson, see examples. 
#' 
#' Note that this does not give you Topojson, but gives you a `sf`
#' class - which you can use then to turn it into geojson as a list or json
#' @seealso [geojson_read()], [topojson_write()]
#'
#' @examples \dontrun{
#' # From a file
#' file <- system.file("examples", "us_states.topojson", package = "geojsonio")
#' topojson_read(file)
#'
#' # From a URL
#' url <- "https://raw.githubusercontent.com/shawnbot/d3-cartogram/master/data/us-states.topojson"
#' topojson_read(url)
#'
#' # Use as.location first if you want
#' topojson_read(as.location(file))
#' 
#' # quickly convert to geojson as a list
#' file <- system.file("examples", "us_states.topojson", package = "geojsonio")
#' tmp <- topojson_read(file)
#' geojson_list(tmp)
#' geojson_json(tmp)
#' 
#' # pass on args
#' topojson_read(file, quiet = TRUE)
#' topojson_read(file, stringsAsFactors = FALSE)
#' }

topojson_read <- function(x, ...) {
  UseMethod("topojson_read")
}

#' @export
topojson_read.default <- function(x, ...) {
  stop("no 'topojson_read' method for ", class(x)[1L])
}

#' @export
topojson_read.character <- function(x, ...) {
  read_topojson(x, ...)
}

#' @export
topojson_read.location_ <- function(x, ...) {
  read_topojson(x, ...)
}

# helpers -------------------------
read_topojson <- function(x, ...) {
  if (is_file(x)) x <- normalizePath(x)
  stopifnot(ftype(x) %in% c("json", "topojson", "url"))
  sf::st_read(x, quiet = TRUE, ...)
}

is_file <- function(x) {
  !is.na(file.info(x)$isdir) && !file.info(x)$isdir
}
