#' Style a data.frame prior to converting to geojson.
#'
#' @export
#' @param input A data.frame or a list
#' @param var A single variable to map colors, symbols, and/or sizes to.
#' @param var_col The variable to map colors to.
#' @param var_sym The variable to map symbols to.
#' @param var_size The variable to map size to.
#' @param color Valid RGB hex color
#' @param symbol An icon ID from the Maki project \url{http://www.mapbox.com/maki/} or
#'    a single alphanumeric character (a-z or 0-9).
#' @param size One of 'small', 'medium', or 'large'
#' @examples \dontrun{
#' ## Style geojson - from data.frames
#' library("RColorBrewer")
#' smalluscities <-
#'    subset(us_cities, country.etc == 'OR' | country.etc == 'NY' | country.etc == 'CA')
#'
#' ### Just color
#' style_geojson(smalluscities, var = 'country.etc',
#'    color=brewer.pal(length(unique(smalluscities$country.etc)), "Blues"))
#' ### Just size
#' style_geojson(smalluscities, var = 'country.etc', size=c('small','medium','large'))
#' ### Color and size
#' style_geojson(smalluscities, var = 'country.etc',
#'    color=brewer.pal(length(unique(smalluscities$country.etc)), "Blues"),
#'    size=c('small','medium','large'))
#'
#' ## From lists
#' mylist <- list(list(latitude=30, longitude=120, state="US"),
#'                list(latitude=32, longitude=130, state="OR"),
#'                list(latitude=38, longitude=125, state="NY"),
#'                list(latitude=40, longitude=128, state="VT"))
#' # just color
#' style_geojson(mylist, var = 'state',
#'    color=brewer.pal(length(unique(sapply(mylist, '[[', 'state'))), "Blues"))
#' # color and size
#' style_geojson(mylist, var = 'state',
#'    color=brewer.pal(length(unique(sapply(mylist, '[[', 'state'))), "Blues"),
#'    size=c('small','medium','large','large'))
#' # color, size, and symbol
#' style_geojson(mylist, var = 'state',
#'    color=brewer.pal(length(unique(sapply(mylist, '[[', 'state'))), "Blues"),
#'    size=c('small','medium','large','large'),
#'    symbol="zoo")
#' }

style_geojson <- function(input, var = NULL, var_col = NULL, var_sym = NULL,
                          var_size = NULL, color = NULL, symbol = NULL, size = NULL){
  UseMethod("style_geojson")
}

#' @export
style_geojson.data.frame <- function(input, var = NULL, var_col = NULL, var_sym = NULL,
                                     var_size = NULL, color = NULL, symbol = NULL, size = NULL) {
  # check inputs
  if (NROW(input) == 0) {
    stop("Your data.frame must have at least one row", call. = FALSE)
  }
  if (is.null(var_col) & is.null(var_sym) & is.null(var_size)) {
    var_col <- var_sym <- var_size <- var
  }
  
  color_vec <- df_vec(input, color, var_col)
  symbol_vec <- df_vec(input, symbol, var_sym)
  size_vec <- df_vec(input, size, var_size)
  
  # put together output
  output <- do.call(cbind, tg_compact(list(input, `marker-color` = color_vec, `marker-symbol` = symbol_vec,
                                           `marker-size` = size_vec)))
  return(output)
}

#' @export
style_geojson.list <- function(input, var = NULL, var_col = NULL, var_sym = NULL,
                               var_size = NULL, color = NULL, symbol = NULL, size = NULL) {
  # check inputs
  if (length(input) == 0) {
    stop("Your input list has no rows...", call. = FALSE)
  }
  if (is.null(var_col) & is.null(var_sym) & is.null(var_size)) {
    var_col <- var_sym <- var_size <- var
  }
  
  color_vec <- list_vec(input, color, var_col)
  symbol_vec <- list_vec(input, symbol, var_sym)
  size_vec <- list_vec(input, size, var_size)
  
  # put together output
  dat <- tg_compact(list(`marker-color` = color_vec, `marker-symbol` = symbol_vec, `marker-size` = size_vec))
  for (i in seq_along(dat)) {
    input <- Map(function(x, y, z) c(x, setNames(list(y), z)), input, dat[[i]], names(dat[i]))
  }
  
  return(input)
}

# helper to assign vectors appropriately
df_vec <- function(input, x, var_x) {
  if (!is.null(x)) {
    if (length(x) == 1) {
      rep(x, nrow(input))
    } else {
      mapping <- data.frame(var = unique(input[[var_x]]), col2 = x)
      stuff <- input[[var_x]]
      with(mapping, col2[match(stuff, var)])
    }
  } else {
    NULL
  } 
}

list_vec <- function(input, x, var_x) {
  if (!is.null(x)) {
    if (length(x) == 1) {
      rep(x, length(input))
    } else {
      mapping <- data.frame(var = unique(vapply(input, "[[", "", var_x)), col2 = x, stringsAsFactors = FALSE)
      stuff <- vapply(input, "[[", "", var_x)
      with(mapping, col2[match(stuff, var)])
    }
  } else {
    NULL
  } 
}
