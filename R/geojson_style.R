#' Style a data.frame or list prior to converting to geojson
#' 
#' This helps you add styling following the Simplestyle Spec. See Details
#'
#' @export
#' @param input A data.frame or a list
#' @param var (character) A single variable to map colors, symbols, and/or sizes to.
#' @param var_col (character) A single variable to map colors to.
#' @param var_sym (character) A single variable to map symbols to.
#' @param var_size (character) A single variable to map size to.
#' @param var_stroke (character) A single variable to map stroke to.
#' @param var_stroke_width (character) A single variable to map stroke width to.
#' @param var_stroke_opacity (character) A single variable to map stroke opacity to.
#' @param var_fill (character) A single variable to map fill to.
#' @param var_fill_opacity (character) A single variable to map fill opacity to.
#' @param color (character) Valid RGB hex color. Assigned to the variable \code{marker-color}
#' @param symbol (character) An icon ID from the Maki project \url{http://www.mapbox.com/maki/} 
#' or a single alphanumeric character (a-z or 0-9). Assigned to the variable \code{marker-symbol}
#' @param size (character) One of 'small', 'medium', or 'large'. Assigned to the 
#' variable \code{marker-size}
#' @param stroke (character) Color of a polygon edge or line (RGB). Assigned to the 
#' variable \code{stroke}
#' @param stroke_width (numeric) Width of a polygon edge or line (number > 0). Assigned 
#' to the variable \code{stroke-width}
#' @param stroke_opacity (numeric) Opacity of a polygon edge or line (0.0 - 1.0). Assigned 
#' to the variable \code{stroke-opacity}
#' @param fill (character) The color of the interior of a polygon (GRB). Assigned to the 
#' variable \code{fill}
#' @param fill_opacity (character) The opacity of the interior of a polygon (0.0-1.0). 
#' Assigned to the variable \code{fill-opacity}
#' 
#' @details The parameters color, symbol, size, stroke, stroke_width, stroke_opacity, 
#' fill, and fill_opacity expect a vector of size 1 (recycled), or exact length of vector 
#' being applied to in your input data. 
#' 
#' This function helps add styling data to a list or data.frame followingn the 
#' Simplestyle Spec (\url{https://github.com/mapbox/simplestyle-spec/tree/master/1.1.0}), 
#' used by MapBox and GitHub Gists (that renders geoJSON/topoJSON as interactive maps). 
#' 
#' There are a few other style variables, but deal with polygons
#' 
#' GitHub has a nice help article on geoJSON files 
#' \url{https://help.github.com/articles/mapping-geojson-files-on-github/}
#' 
#' Please do get in touch if you think anything should change in this function.
#' 
#' @examples \dontrun{
#' ## from data.frames - point data
#' library("RColorBrewer")
#' smalluscities <-
#'    subset(us_cities, country.etc == 'OR' | country.etc == 'NY' | country.etc == 'CA')
#'
#' ### Just color
#' geojson_style(smalluscities, var = 'country.etc',
#'    color=brewer.pal(length(unique(smalluscities$country.etc)), "Blues"))
#' ### Just size
#' geojson_style(smalluscities, var = 'country.etc', size=c('small','medium','large'))
#' ### Color and size
#' geojson_style(smalluscities, var = 'country.etc',
#'    color=brewer.pal(length(unique(smalluscities$country.etc)), "Blues"),
#'    size=c('small','medium','large'))
#'
#' ## from lists - point data
#' mylist <- list(list(latitude=30, longitude=120, state="US"),
#'                list(latitude=32, longitude=130, state="OR"),
#'                list(latitude=38, longitude=125, state="NY"),
#'                list(latitude=40, longitude=128, state="VT"))
#' # just color
#' geojson_style(mylist, var = 'state',
#'    color=brewer.pal(length(unique(sapply(mylist, '[[', 'state'))), "Blues"))
#' # color and size
#' geojson_style(mylist, var = 'state',
#'    color=brewer.pal(length(unique(sapply(mylist, '[[', 'state'))), "Blues"),
#'    size=c('small','medium','large','large'))
#' # color, size, and symbol
#' geojson_style(mylist, var = 'state',
#'    color=brewer.pal(length(unique(sapply(mylist, '[[', 'state'))), "Blues"),
#'    size=c('small','medium','large','large'),
#'    symbol="zoo")
#' # stroke, fill
#' geojson_style(mylist, var = 'state',
#'    stroke=brewer.pal(length(unique(sapply(mylist, '[[', 'state'))), "Blues"),
#'    fill=brewer.pal(length(unique(sapply(mylist, '[[', 'state'))), "Greens"))
#' 
#' # from data.frame - polygon data
#' smallstates <- states[states$group %in% 1:3, ]
#' head(smallstates)
#' geojson_style(smallstates, var = 'group',
#'    stroke = brewer.pal(length(unique(smallstates$group)), "Blues"),
#'    stroke_width = c(1, 2, 3),
#'    fill = brewer.pal(length(unique(smallstates$group)), "Greens"))
#' }

geojson_style <- function(input, var = NULL, 
  var_col = NULL, var_sym = NULL, var_size = NULL, var_stroke = NULL, var_stroke_width = NULL,
  var_stroke_opacity = NULL, var_fill = NULL, var_fill_opacity = NULL, 
  color = NULL, symbol = NULL, size = NULL, stroke = NULL, stroke_width = NULL, 
  stroke_opacity = NULL, fill = NULL, fill_opacity = NULL) {
  
  UseMethod("geojson_style")
}

#' @export
geojson_style.data.frame <- function(input, var = NULL, 
  var_col = NULL, var_sym = NULL, var_size = NULL, var_stroke = NULL, var_stroke_width = NULL,
  var_stroke_opacity = NULL, var_fill = NULL, var_fill_opacity = NULL, 
  color = NULL, symbol = NULL, size = NULL, stroke = NULL, stroke_width = NULL, 
  stroke_opacity = NULL, fill = NULL, fill_opacity = NULL) {
  # check inputs
  if (NROW(input) == 0) {
    stop("Your data.frame must have at least one row", call. = FALSE)
  }
  if (is.null(var_col) & is.null(var_sym) & is.null(var_size) & is.null(var_stroke)
      & is.null(var_stroke_width) & is.null(var_stroke_opacity) & is.null(var_fill) & is.null(var_fill_opacity)) {
    var_col <- var_sym <- var_size <- var_stroke <- var_stroke_width <- var_stroke_opacity <- var_fill <- var_fill_opacity <- var
  }
  
  color_vec <- df_vec(input, color, var_col)
  symbol_vec <- df_vec(input, symbol, var_sym)
  size_vec <- df_vec(input, size, var_size)
  stroke_vec <- df_vec(input, stroke, var_stroke)
  stroke_width_vec <- df_vec(input, stroke_width, var_stroke_width)
  stroke_opacity_vec <- df_vec(input, stroke_opacity, var_stroke_opacity)
  fill_vec <- df_vec(input, fill, var_fill)
  fill_opacity_vec <- df_vec(input, fill_opacity, var_fill_opacity)
  
  # put together output
  props <- tg_compact(list(input, 
                           `marker-color` = color_vec, 
                           `marker-symbol` = symbol_vec, 
                           `marker-size` = size_vec,
                           stroke = stroke_vec,
                           `stroke-width` = stroke_width_vec,
                           `stroke-opacity` = stroke_opacity_vec,
                           fill = fill_vec,
                           `fill-opacity` = fill_opacity_vec,
                           stringsAsFactors = FALSE))
  
  output <- do.call(cbind, props)
  return(output)
}

#' @export
geojson_style.list <- function(input, var = NULL, 
  var_col = NULL, var_sym = NULL, var_size = NULL, var_stroke = NULL, var_stroke_width = NULL,
  var_stroke_opacity = NULL, var_fill = NULL, var_fill_opacity = NULL, 
  color = NULL, symbol = NULL, size = NULL, stroke = NULL, stroke_width = NULL, 
  stroke_opacity = NULL, fill = NULL, fill_opacity = NULL) {
  # check inputs
  if (length(input) == 0) {
    stop("Your input list has no rows...", call. = FALSE)
  }
  if (is.null(var_col) & is.null(var_sym) & is.null(var_size) & is.null(var_stroke)
      & is.null(var_stroke_width) & is.null(var_stroke_opacity) & is.null(var_fill) & is.null(var_fill_opacity)) {
    var_col <- var_sym <- var_size <- var_stroke <- var_stroke_width <- var_stroke_opacity <- var_fill <- var_fill_opacity <- var
  }
  
  color_vec <- list_vec(input, color, var_col)
  symbol_vec <- list_vec(input, symbol, var_sym)
  size_vec <- list_vec(input, size, var_size)
  stroke_vec <- list_vec(input, stroke, var_stroke)
  stroke_width_vec <- list_vec(input, stroke_width, var_stroke_width)
  stroke_opacity_vec <- list_vec(input, stroke_opacity, var_stroke_opacity)
  fill_vec <- list_vec(input, fill, var_fill)
  fill_opacity_vec <- list_vec(input, fill_opacity, var_fill_opacity)
  
  # put together output
  dat <- tg_compact(list(`marker-color` = color_vec, 
                         `marker-symbol` = symbol_vec, 
                         `marker-size` = size_vec,
                         `stroke` = stroke_vec,
                         `stroke-width` = stroke_width_vec,
                         `stroke-opacity` = stroke_opacity_vec,
                         `fill` = fill_vec,
                         `fill-opacity` = fill_opacity_vec))
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
      mapping <- data.frame(var = unique(input[[var_x]]), col2 = x, stringsAsFactors = FALSE)
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
