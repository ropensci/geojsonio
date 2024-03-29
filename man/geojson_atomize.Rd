% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/geojson_atomize.R
\name{geojson_atomize}
\alias{geojson_atomize}
\title{Atomize}
\usage{
geojson_atomize(x, combine = TRUE)
}
\arguments{
\item{x}{(geo_list/geo_json/json/character) input object, either
\code{geo_json}, \code{geo_list}, \code{json}, or \code{character} class.
If \code{character}, must be valid JSON}

\item{combine}{(logical) only applies to \code{geo_json/json} type inputs.
combine valid JSON objects into a single valid JSON object. Default:
\code{TRUE}}
}
\value{
same class as input object, but modified
}
\description{
Atomize
}
\details{
A FeatureCollection is split into many Feature's, and
a GeometryCollection is split into many geometries

Internally we use \pkg{jqr} for JSON parsing
}
\examples{
################# lists
# featurecollection -> features
mylist <- list(
  list(latitude = 30, longitude = 120, marker = "red"),
  list(latitude = 30, longitude = 130, marker = "blue")
)
(x <- geojson_list(mylist))
geojson_atomize(x)

# geometrycollection -> geometries
mylist <- list(
  list(latitude = 30, longitude = 120, marker = "red"),
  list(latitude = 30, longitude = 130, marker = "blue")
)
(x <- geojson_list(mylist, type = "GeometryCollection"))
geojson_atomize(x)

# sf class
library(sf)
p1 <- rbind(c(0, 0), c(1, 0), c(3, 2), c(2, 4), c(1, 4), c(0, 0))
poly <- rbind(c(1, 1), c(1, 2), c(2, 2), c(1, 1))
poly_sfg <- st_polygon(list(p1))
(x <- geojson_list(poly_sfg))
geojson_atomize(x)

################# json
# featurecollection -> features
mylist <- list(
  list(latitude = 30, longitude = 120, marker = "red"),
  list(latitude = 30, longitude = 130, marker = "blue")
)
(x <- geojson_json(mylist))
geojson_atomize(x)
geojson_atomize(x, FALSE)

# geometrycollection -> geometries
mylist <- list(
  list(latitude = 30, longitude = 120, marker = "red"),
  list(latitude = 30, longitude = 130, marker = "blue")
)
(x <- geojson_json(mylist, type = "GeometryCollection"))
geojson_atomize(x)
geojson_atomize(x, FALSE)

# sf class
library(sf)
nc <- st_read(system.file("shape/nc.shp", package = "sf"), quiet = TRUE)
(x <- geojson_json(nc))
geojson_atomize(x)
geojson_atomize(x, FALSE)

################# character
# featurecollection -> features
mylist <- list(
  list(latitude = 30, longitude = 120, marker = "red"),
  list(latitude = 30, longitude = 130, marker = "blue")
)
(x <- geojson_json(mylist))
geojson_atomize(unclass(x))
}
