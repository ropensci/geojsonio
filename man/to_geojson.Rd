\name{to_geojson}
\alias{to_geojson}
\alias{to_geojson.data.frame}
\alias{to_geojson.list}
\title{Get palette actual name from longer names}
\usage{
to_geojson(...)

\method{to_geojson}{data.frame}(input, lat = "latitude", lon = "longitude",
  polygon = NULL, output = "list", ...)

\method{to_geojson}{list}(input, lat = "latitude", lon = "longitude",
  output = "list", ...)
}
\arguments{
  \item{input}{Input list, data.frame, or spatial class}

  \item{lat}{Latitude name}

  \item{lon}{Longitude name}

  \item{polygon}{If a polygon is defined in a data.frame,
  this is the column that defines the grouping of the
  polygons in the data.frame}

  \item{output}{One of 'list' or 'geojson'}

  \item{...}{Further args}
}
\description{
Get palette actual name from longer names
}
\examples{
library(maps)
data(us.cities)
head(us.cities)
to_geojson(input=us.cities, lat='lat', lon='long')

# polygons
library(ggplot2)
states <- map_data("state")
head(states)
## make list for input to e.g., rMaps
res <- to_geojson(input=states, lat='lat', lon='long', group='group')
## make geojson from the list
list_to_geojson.SpatialPolygonsDataFrame(res)

## From a list
mylist <- list(list(latitude=30, longitude=120, marker="red"), list(latitude=30, longitude=130, marker="blue"))
to_geojson(mylist)
}

