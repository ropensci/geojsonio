#' Make an interactive map using the cartographer package
#' 
#' @export
#' @importFrom cartographer cartographer tile_layer geojson_layer
#' 
#' @param data Input, one of class SpatialPolygons, SpatialPolygonsDataFrame, or file path
#' @param tile (logical) Whether to plot tile layer or not. Default: TRUE
#' @param region The region to which the map should be centered. This region can be one of 
#' several types. Passing a two-letter ISO country code will center the map on that country. 
#' The string "United States" will center the map on the continental United States of America. 
#' You can also use the names of continents. The region is case insensitive.
#' @param bbox (list) Instead of a region, you can center the map on a bounding box. The bounding 
#' box be specified in decimal degrees of latitude and longitude and should have the 
#' following format:  \code{list(c(long1, lat1), c(long2, lat2))}
#' @param width The width of the map in pixels.
#' @param height The height of the map in pixels.
#' @param provider (character) map provider Default: stamen 
#' @param path (character) Default: toner-lite
#' @param tile_label (character) Tile label Default: Tiles
#' @param geojson_label (character) Geojson label Default: GeoJSON
#' @param tile_visible (logical) Should tile layer be visible on initial load Default: TRUE
#' @param geojson_visible (logical) Should geojson layer be visible on initial load Default: TRUE
#' @param clickable (logical) Whether should be clickable or not Default: FALSE
#' @param fill (character) Fill color Default: lightblue
#' @param stroke (character) Stroke color Default: black
#' @param opacity (character) Opacity Default: 0.5 
#' @param ... Further args. Ignored.
#' 
#' @examples \donttest{
#' # From SpatialPolygons class
#' library('sp')
#' poly1 <- Polygons(list(Polygon(cbind(c(-100,-90,-85,-100),
#'    c(40,50,45,40)))), "1")
#' poly2 <- Polygons(list(Polygon(cbind(c(-90,-80,-75,-90),
#'    c(30,40,35,30)))), "2")
#' sp_poly <- SpatialPolygons(list(poly1, poly2), 1:2)
#' map(sp_poly)
#' 
#' # From SpatialPolygonsDataFrame class
#' sp_polydf <- as(sp_poly, "SpatialPolygonsDataFrame")
#' map(sp_polydf)
#' 
#' # From a file
#' land <- system.file("extdata", "land.geojson", package = "cartographer")
#' map(land, tile=FALSE, geojson_label = "land")
#' map(as.location(land), tile=FALSE, geojson_label = "land")
#' 
#' # Historical usa boundaries
#' library("USAboundaries")
#' us_sp <- us_boundaries(as.Date("1800-01-01"))
#' map(us_sp, region = "United States", geojson_label = "US 1800", clickable = TRUE)
#' 
#' # NaturalEarth layers
#' library("curl")
#' bs <- "https://github.com/nvkelso/natural-earth-vector/blob/master/110m_physical/%s?raw=true"
#' files <- paste0("ne_110m_glaciated_areas.", c("shx","shp", "dbf", "prj"))
#' for(i in seq_along(files)){
#'    curl_download(sprintf(bs, files[i]), destfile=files[i])
#' }
#' out <- geojson_read(files[2]) 
#' map(out, tile=FALSE)
#' }

map <- function(...) UseMethod("map")

#' @export
#' @rdname map
map.character <- function(data, ...) map(as.location(data), ...)

#' @export
#' @rdname map
map.location <- function(data, tile = TRUE, region = NULL, bbox = NULL, 
  width = NULL, height = NULL, provider = "stamen", path = "toner-lite", 
  tile_label = "Tiles", geojson_label = "GeoJSON", tile_visible = TRUE, 
  geojson_visible = tile_visible, clickable = FALSE, 
  fill = "lightblue", stroke = "black", opacity = 0.5, ...)
{
  cart <- cartographer(region = region, bbox = bbox, width = width, height = height)
  if(tile) {
    cart %>% 
      tile_layer(provider = provider, path = path, label = tile_label, visible = tile_visible) %>%
      geojson_layer(file = data[[1]], label = geojson_label, 
                    fill = fill, stroke = stroke, opacity = opacity, visible = geojson_visible, 
                    clickable = clickable)
  } else {
    cart %>% 
      geojson_layer(file = data[[1]], label = geojson_label, 
                    fill = fill, stroke = stroke, opacity = opacity, visible = geojson_visible, 
                    clickable = clickable)
  }
}

#' @export
#' @rdname map
map.SpatialPolygons <- function(data, tile = TRUE, region = NULL, bbox = NULL, 
  width = NULL, height = NULL, provider = "stamen", path = "toner-lite", 
  tile_label = "Tiles", geojson_label = "GeoJSON", tile_visible = TRUE, 
  geojson_visible = tile_visible, clickable = FALSE, 
  fill = "lightblue", stroke = "black", opacity = 0.5, ...)
{
  cartographer(region = region, bbox = bbox, width = width, height = height) %>%
    tile_layer(provider = provider, path = path, label = tile_label, visible = tile_visible) %>%
    geojson_layer(data = geojson_json(data), label = geojson_label, 
                  fill = fill, stroke = stroke, opacity = opacity, visible = geojson_visible, 
                  clickable = clickable)
}

#' @export
#' @rdname map
map.SpatialPolygonsDataFrame <- function(data, tile = TRUE, region = NULL, bbox = NULL, 
  width = NULL, height = NULL, provider = "stamen", path = "toner-lite", 
  tile_label = "Tiles", geojson_label = "GeoJSON", tile_visible = TRUE, 
  geojson_visible = tile_visible, clickable = FALSE, 
  fill = "lightblue", stroke = "black", opacity = 0.5, ...)
{
  cartographer(region = region, bbox = bbox, width = width, height = height) %>%
    tile_layer(provider = provider, path = path, label = tile_label, visible = tile_visible) %>%
    geojson_layer(data = geojson_json(data), label = geojson_label, 
                  fill = fill, stroke = stroke, opacity = opacity, visible = geojson_visible, 
                  clickable = clickable)
}
