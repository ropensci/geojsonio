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
#' library("maps")
#' data(us.cities)
#' smalluscities <- 
#'    subset(us.cities, country.etc == 'OR' | country.etc == 'NY' | country.etc == 'CA')
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
#' style_geojson(mylist, var = 'state',
#'    color=brewer.pal(length(unique(sapply(mylist, '[[', 'state'))), "Blues"))
#' }

style_geojson <- function(input, var = NULL, var_col = NULL, var_sym = NULL,
                          var_size = NULL, color = NULL, symbol = NULL, size = NULL){
  UseMethod("style_geojson")
}

#' @method style_geojson data.frame
#' @export
#' @rdname style_geojson
style_geojson.data.frame <- function(input, var = NULL, var_col = NULL, var_sym = NULL,
    var_size = NULL, color = NULL, symbol = NULL, size = NULL) {
    if (!inherits(input, "data.frame"))
        stop("Your input object needs to be a data.frame")
    if (nrow(input) == 0)
        stop("Your data.frame has no rows...")
    if (is.null(var_col) & is.null(var_sym) & is.null(var_size))
        var_col <- var_sym <- var_size <- var
    if (!is.null(color)) {
        if (length(color) == 1) {
            color_vec <- rep(color, nrow(input))
        } else {
            mapping <- data.frame(var = unique(input[[var_col]]), col2 = color)
            stuff <- input[[var_col]]
            color_vec <- with(mapping, col2[match(stuff, var)])
        }
    } else {
        color_vec <- NULL
    }
    if (!is.null(symbol)) {
        if (length(symbol) == 1) {
            symbol_vec <- rep(symbol, nrow(input))
        } else {
            mapping <- data.frame(var = unique(input[[var_sym]]), symb = symbol)
            stuff <- input[[var_sym]]
            symbol_vec <- with(mapping, symb[match(stuff, var)])
        }
    } else {
        symbol_vec <- NULL
    }
    if (!is.null(size)) {
        if (length(size) == 1) {
            size_vec <- rep(size, nrow(input))
        } else {
            mapping <- data.frame(var = unique(input[[var_size]]), sz = size)
            stuff <- input[[var_size]]
            size_vec <- with(mapping, sz[match(stuff, var)])
        }
    } else {
        size_vec <- NULL
    }
    output <- do.call(cbind, tg_compact(list(input, `marker-color` = color_vec, `marker-symbol` = symbol_vec,
        `marker-size` = size_vec)))

    return(output)
}


#' @method style_geojson list
#' @export
#' @rdname style_geojson
style_geojson.list <- function(input, var = NULL, var_col = NULL, var_sym = NULL,
                                     var_size = NULL, color = NULL, symbol = NULL, size = NULL) {
  if (!inherits(input, "list"))
    stop("Your input object needs to be a data.frame")
  if (length(input) == 0)
    stop("Your data.frame has no rows...")
  if (is.null(var_col) & is.null(var_sym) & is.null(var_size))
    var_col <- var_sym <- var_size <- var
  if (!is.null(color)) {
    if (length(color) == 1) {
      color_vec <- rep(color, nrow(input))
    } else {
      mapping <- data.frame(var = unique(input[[var_col]]), col2 = color)
      stuff <- input[[var_col]]
      color_vec <- with(mapping, col2[match(stuff, var)])
    }
  } else {
    color_vec <- NULL
  }
  if (!is.null(symbol)) {
    if (length(symbol) == 1) {
      symbol_vec <- rep(symbol, nrow(input))
    } else {
      mapping <- data.frame(var = unique(input[[var_sym]]), symb = symbol)
      stuff <- input[[var_sym]]
      symbol_vec <- with(mapping, symb[match(stuff, var)])
    }
  } else {
    symbol_vec <- NULL
  }
  if (!is.null(size)) {
    if (length(size) == 1) {
      size_vec <- rep(size, nrow(input))
    } else {
      mapping <- data.frame(var = unique(input[[var_size]]), sz = size)
      stuff <- input[[var_size]]
      size_vec <- with(mapping, sz[match(stuff, var)])
    }
  } else {
    size_vec <- NULL
  }
  output <- do.call(cbind, tg_compact(list(input, `marker-color` = color_vec, `marker-symbol` = symbol_vec,
                                        `marker-size` = size_vec)))

  return(output)
}
