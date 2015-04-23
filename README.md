geojsonio
========



[![Build Status](https://api.travis-ci.org/ropensci/geojsonio.png)](https://travis-ci.org/ropensci/geojsonio)
[![Coverage Status](https://coveralls.io/repos/ropensci/geojsonio/badge.svg)](https://coveralls.io/r/ropensci/geojsonio)

__Convert various data formats to geoJSON or topoJSON__

This package is a utility to convert geographic data to geojson and topojson formats. Nothing else. We hope to do this one job very well, and handle all reasonable use cases.

Functions in this package are organized first around what you're working with or want to get, geojson or topojson, then convert to or read from various formats:

* `geojson_list()`/`topojson_list()` - convert to geojson/topojson as R list format
* `geojson_json()`/`topojson_json()` - convert to geojson/topojson as json
* `geojson_read()``topojson_read()` - read a geojson/topojson file from file path or URL
* `geojson_write()` - write a geojson file locally (topojson coming later)

Each of the above functions have methods for various objects/classes, including `numeric`, `data.frame`, `list`, `SpatialPolygons`, `SpatialLines`, `SpatialPoints`, etc.

Additional functions:

* `map_gist()` - push up a geojson or topojson file as a GitHub gist (renders as an interactive map)

## *json Info

* GeoJSON - [spec](http://geojson.org/geojson-spec.html)
* [GeoJSON lint](http://geojsonlint.com/)
* TopoJSON - [spec](https://github.com/topojson/topojson-specification/blob/master/README.md)
* TopoJSON node library - [on NMP](https://www.npmjs.org/package/topojson), [source](https://github.com/mbostock/topojson)

## Quick start

### Install

Install rgdal - in case you can't get it installed from binary , here's what works on a Mac (change to the version of `rgdal` and `GDAL` you have).


```r
install.packages("http://cran.r-project.org/src/contrib/rgdal_0.9-1.tar.gz", repos = NULL, type="source", configure.args = "--with-gdal-config=/Library/Frameworks/GDAL.framework/Versions/1.10/unix/bin/gdal-config --with-proj-include=/Library/Frameworks/PROJ.framework/unix/include --with-proj-lib=/Library/Frameworks/PROJ.framework/unix/lib")
```

Install `geojsonio`


```r
install.packages("devtools")
devtools::install_github("ropensci/geojsonio")
```


```r
library("geojsonio")
```

### GeoJSON

#### Convert various formats to geojson

From a `numeric` vector of length 2, as json or list


```r
geojson_json(c(32.45,-99.74))
#> {"type":"FeatureCollection","features":[{"type":"Feature","geometry":{"type":"Point","coordinates":[32.45,-99.74]},"properties":{}}]}
geojson_list(c(32.45,-99.74))
#> $type
#> [1] "FeatureCollection"
#> 
#> $features
#> $features[[1]]
#> $features[[1]]$type
#> [1] "Feature"
#> 
#> $features[[1]]$geometry
#> $features[[1]]$geometry$type
#> [1] "Point"
#> 
#> $features[[1]]$geometry$coordinates
#> [1]  32.45 -99.74
#> 
#> 
#> $features[[1]]$properties
#> NULL
#> 
#> 
#> 
#> attr(,"class")
#> [1] "geo_list"
#> attr(,"from")
#> [1] "numeric"
```

From a `data.frame`


```r
library('maps')
data(us.cities)
geojson_json(us.cities[1:2,], lat='lat', lon='long')
#> {"type":"FeatureCollection","features":[{"type":"Feature","geometry":{"type":"Point","coordinates":[-99.74,32.45]},"properties":{"name":"Abilene TX","country.etc":"TX","pop":"113888","capital":"0"}},{"type":"Feature","geometry":{"type":"Point","coordinates":[-81.52,41.08]},"properties":{"name":"Akron OH","country.etc":"OH","pop":"206634","capital":"0"}}]}
geojson_list(us.cities[1:2,], lat='lat', lon='long')
#> $type
#> [1] "FeatureCollection"
#> 
#> $features
#> $features[[1]]
#> $features[[1]]$type
#> [1] "Feature"
#> 
#> $features[[1]]$geometry
#> $features[[1]]$geometry$type
#> [1] "Point"
#> 
#> $features[[1]]$geometry$coordinates
#> [1] -99.74  32.45
#> 
#> 
#> $features[[1]]$properties
#> $features[[1]]$properties$name
#> [1] "Abilene TX"
#> 
#> $features[[1]]$properties$country.etc
#> [1] "TX"
#> 
#> $features[[1]]$properties$pop
#> [1] "113888"
#> 
#> $features[[1]]$properties$capital
#> [1] "0"
#> 
#> 
#> 
#> $features[[2]]
#> $features[[2]]$type
#> [1] "Feature"
#> 
#> $features[[2]]$geometry
#> $features[[2]]$geometry$type
#> [1] "Point"
#> 
#> $features[[2]]$geometry$coordinates
#> [1] -81.52  41.08
#> 
#> 
#> $features[[2]]$properties
#> $features[[2]]$properties$name
#> [1] "Akron OH"
#> 
#> $features[[2]]$properties$country.etc
#> [1] "OH"
#> 
#> $features[[2]]$properties$pop
#> [1] "206634"
#> 
#> $features[[2]]$properties$capital
#> [1] "0"
#> 
#> 
#> 
#> 
#> attr(,"class")
#> [1] "geo_list"
#> attr(,"from")
#> [1] "data.frame"
```

From `SpatialPolygons` class


```r
library('sp')
poly1 <- Polygons(list(Polygon(cbind(c(-100,-90,-85,-100),
  c(40,50,45,40)))), "1")
poly2 <- Polygons(list(Polygon(cbind(c(-90,-80,-75,-90),
  c(30,40,35,30)))), "2")
sp_poly <- SpatialPolygons(list(poly1, poly2), 1:2)
```

to json


```r
geojson_json(sp_poly)
#> {"type":"FeatureCollection","features":[{"type":"Feature","id":1,"properties":{"dummy":0},"geometry":{"type":"Polygon","coordinates":[[[-100,40],[-90,50],[-85,45],[-100,40]]]}},{"type":"Feature","id":2,"properties":{"dummy":0},"geometry":{"type":"Polygon","coordinates":[[[-90,30],[-80,40],[-75,35],[-90,30]]]}}]}
```

to list


```r
geojson_list(sp_poly)$features[[1]]
#> $type
#> [1] "Feature"
#> 
#> $id
#> [1] 1
#> 
#> $properties
#> $properties$dummy
#> [1] 0
#> 
#> 
#> $geometry
#> $geometry$type
#> [1] "Polygon"
#> 
#> $geometry$coordinates
#> $geometry$coordinates[[1]]
#> $geometry$coordinates[[1]][[1]]
#> [1] -100   40
#> 
#> $geometry$coordinates[[1]][[2]]
#> [1] -90  50
#> 
#> $geometry$coordinates[[1]][[3]]
#> [1] -85  45
#> 
#> $geometry$coordinates[[1]][[4]]
#> [1] -100   40
```

#### Write geojson


```r
library('maps')
data(us.cities)
geojson_write(us.cities[1:2,], lat='lat', lon='long')
#> [1] "myfile.geojson"
```

#### Read geojson


```r
file <- system.file("examples", "california.geojson", package = "geojsonio")
out <- geojson_read(file)
```

### TopoJSON

#### Read topojson

TopoJSON


```r
url <- "https://raw.githubusercontent.com/shawnbot/d3-cartogram/master/data/us-states.topojson"
out <- topojson_read(url)
#> OGR data source with driver: GeoJSON 
#> Source: "https://raw.githubusercontent.com/shawnbot/d3-cartogram/master/data/us-states.topojson", layer: "states"
#> with 51 features
#> It has 2 fields
plot(out)
```

![plot of chunk unnamed-chunk-12](inst/img/unnamed-chunk-12-1.png) 

### Use case: Make a map


```r
library('sp')
library('cartographer')
poly1 <- Polygons(list(Polygon(cbind(c(-100,-90,-85,-100),
   c(40,50,45,40)))), "1")
poly2 <- Polygons(list(Polygon(cbind(c(-90,-80,-75,-90),
   c(30,40,35,30)))), "2")
sp_poly <- SpatialPolygons(list(poly1, poly2), 1:2)
cartographer() %>%
 tile_layer() %>%
 geojson_layer(data = geojson_json(sp_poly))
```

![](inst/img/readme1.png)

## Meta

* [Please report any issues or bugs](https://github.com/ropensci/geojsonio/issues).
* License: MIT
* Get citation information for `geojsonio` in R doing `citation(package = 'geojsonio')`

[![rofooter](http://ropensci.org/public_images/github_footer.png)](http://ropensci.org)
