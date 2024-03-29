% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/topojson_list.R
\name{topojson_list}
\alias{topojson_list}
\title{Convert many input types with spatial data to TopoJSON
as a list}
\usage{
topojson_list(
  input,
  lat = NULL,
  lon = NULL,
  group = NULL,
  geometry = "point",
  type = "FeatureCollection",
  convert_wgs84 = FALSE,
  crs = NULL,
  object_name = "foo",
  quantization = 0,
  ...
)
}
\arguments{
\item{input}{Input list, data.frame, spatial class, or sf class. Inputs can
also be dplyr \code{tbl_df} class since it inherits from \code{data.frame}}

\item{lat}{(character) Latitude name. The default is \code{NULL}, and we
attempt to guess.}

\item{lon}{(character) Longitude name. The default is \code{NULL}, and we
attempt to guess.}

\item{group}{(character) A grouping variable to perform grouping for
polygons - doesn't apply for points}

\item{geometry}{(character) One of point (Default) or polygon.}

\item{type}{(character) The type of collection. One of FeatureCollection
(default) or GeometryCollection.}

\item{convert_wgs84}{Should the input be converted to the
standard CRS for GeoJSON (https://tools.ietf.org/html/rfc7946)
(geographic coordinate reference system, using the WGS84 datum, with
longitude and latitude units of decimal degrees; EPSG: 4326).
Default is \code{FALSE} though this may change in a future package version.
This will only work for \code{sf} or \code{Spatial} objects with a CRS
already defined. If one is not defined but you know what it is, you
may define it in the \code{crs} argument below.}

\item{crs}{The CRS of the input if it is not already defined. This can
be an epsg code as a four or five digit integer or a valid proj4 string.
This argument will be ignored if \code{convert_wgs84} is \code{FALSE}
or the object already has a CRS.}

\item{object_name}{(character) name to give to the TopoJSON object created.
Default: "foo"}

\item{quantization}{(numeric) quantization parameter, use this to
quantize geometry prior to computing topology. Typical values are powers of
ten (\code{1e4}, \code{1e5}, ...), default is \code{0} to not perform quantization.
For more information about quantization, see this by Mike Bostock
https://stackoverflow.com/questions/18900022/topojson-quantization-vs-simplification/18921214#18921214}

\item{...}{args passed down through \code{\link[=topojson_json]{topojson_json()}} to \code{\link[=geojson_json]{geojson_json()}};
see \code{\link[=geojson_json]{geojson_json()}} for help on what's supported here}
}
\value{
a list with TopoJSON
}
\description{
Convert many input types with spatial data to TopoJSON
as a list
}
\details{
Internally, we call \code{\link[=topojson_json]{topojson_json()}}, then use
an internal function to convert that JSON output to a list

The \code{type} parameter is automatically converted to
\code{type="auto"} if a sf, sfc, or sfg class is passed to \code{input}
}
\examples{
\dontrun{
# From a numeric vector of length 2 to a point
vec <- c(-99.74, 32.45)
topojson_list(vec)

# Lists
## From a list
mylist <- list(
  list(latitude = 30, longitude = 120, marker = "red"),
  list(latitude = 30, longitude = 130, marker = "blue")
)
topojson_list(mylist)

## From a list of numeric vectors to a polygon
vecs <- list(c(100.0, 0.0), c(101.0, 0.0), c(101.0, 1.0), c(100.0, 1.0), c(100.0, 0.0))
topojson_list(vecs, geometry = "polygon")

# from data.frame to points
(res <- topojson_list(us_cities[1:2, ], lat = "lat", lon = "long"))
as.json(res)
## guess lat/long columns
topojson_list(us_cities[1:2, ])
topojson_list(states[1:3, ])
topojson_list(states[1:351, ], geometry = "polygon", group = "group")
topojson_list(canada_cities[1:30, ])

# from data.frame to polygons
head(states)
topojson_list(states[1:351, ], lat = "lat", lon = "long", geometry = "polygon", group = "group")

# From SpatialPolygons class
library("sp")
poly1 <- Polygons(list(Polygon(cbind(
  c(-100, -90, -85, -100),
  c(40, 50, 45, 40)
))), "1")
poly2 <- Polygons(list(Polygon(cbind(
  c(-90, -80, -75, -90),
  c(30, 40, 35, 30)
))), "2")
sp_poly <- SpatialPolygons(list(poly1, poly2), 1:2)
topojson_list(sp_poly)

# From SpatialPolygonsDataFrame class
sp_polydf <- as(sp_poly, "SpatialPolygonsDataFrame")
topojson_list(input = sp_polydf)

# From SpatialPoints class
x <- c(1, 2, 3, 4, 5)
y <- c(3, 2, 5, 1, 4)
s <- SpatialPoints(cbind(x, y))
topojson_list(s)

# From SpatialPointsDataFrame class
s <- SpatialPointsDataFrame(cbind(x, y), mtcars[1:5, ])
topojson_list(s)

# From SpatialLines class
library("sp")
c1 <- cbind(c(1, 2, 3), c(3, 2, 2))
c2 <- cbind(c1[, 1] + .05, c1[, 2] + .05)
c3 <- cbind(c(1, 2, 3), c(1, 1.5, 1))
L1 <- Line(c1)
L2 <- Line(c2)
L3 <- Line(c3)
Ls1 <- Lines(list(L1), ID = "a")
Ls2 <- Lines(list(L2, L3), ID = "b")
sl1 <- SpatialLines(list(Ls1))
sl12 <- SpatialLines(list(Ls1, Ls2))
topojson_list(sl1)
topojson_list(sl12)
as.json(topojson_list(sl12))
as.json(topojson_list(sl12), pretty = TRUE)

# From SpatialLinesDataFrame class
dat <- data.frame(
  X = c("Blue", "Green"),
  Y = c("Train", "Plane"),
  Z = c("Road", "River"), row.names = c("a", "b")
)
sldf <- SpatialLinesDataFrame(sl12, dat)
topojson_list(sldf)
as.json(topojson_list(sldf))
as.json(topojson_list(sldf), pretty = TRUE)

# From SpatialGrid
x <- GridTopology(c(0, 0), c(1, 1), c(5, 5))
y <- SpatialGrid(x)
topojson_list(y)

# From SpatialGridDataFrame
sgdim <- c(3, 4)
sg <- SpatialGrid(GridTopology(rep(0, 2), rep(10, 2), sgdim))
sgdf <- SpatialGridDataFrame(sg, data.frame(val = 1:12))
topojson_list(sgdf)

# From SpatialPixels
library("sp")
pixels <- suppressWarnings(SpatialPixels(SpatialPoints(us_cities[c("long", "lat")])))
summary(pixels)
topojson_list(pixels)

# From SpatialPixelsDataFrame
library("sp")
pixelsdf <- suppressWarnings(
  SpatialPixelsDataFrame(points = canada_cities[c("long", "lat")], data = canada_cities)
)
topojson_list(pixelsdf)

}

# From sf classes:
if (require(sf)) {
  ## sfg (a single simple features geometry)
  p1 <- rbind(c(0, 0), c(1, 0), c(3, 2), c(2, 4), c(1, 4), c(0, 0))
  poly <- rbind(c(1, 1), c(1, 2), c(2, 2), c(1, 1))
  poly_sfg <- st_polygon(list(p1))
  topojson_list(poly_sfg)

  ## sfc (a collection of geometries)
  p1 <- rbind(c(0, 0), c(1, 0), c(3, 2), c(2, 4), c(1, 4), c(0, 0))
  p2 <- rbind(c(5, 5), c(5, 6), c(4, 5), c(5, 5))
  poly_sfc <- st_sfc(st_polygon(list(p1)), st_polygon(list(p2)))
  topojson_list(poly_sfc)

  ## sf (collection of geometries with attributes)
  p1 <- rbind(c(0, 0), c(1, 0), c(3, 2), c(2, 4), c(1, 4), c(0, 0))
  p2 <- rbind(c(5, 5), c(5, 6), c(4, 5), c(5, 5))
  poly_sfc <- st_sfc(st_polygon(list(p1)), st_polygon(list(p2)))
  poly_sf <- st_sf(foo = c("a", "b"), bar = 1:2, poly_sfc)
  topojson_list(poly_sf)
}

}
