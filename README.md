togeojson
========

[![Build status](https://ci.appveyor.com/api/projects/status/j3nr7n8nvutit7vh/branch/master)](https://ci.appveyor.com/project/sckott/togeojson/branch/master)

Convert various data formats to geoJSON or topoJSON.

This R package aims to be a utility to only convert geographic data to geojson and topojson formats. Nothing else. We hope to do this one job very well, and handle all reasonable use cases.

## Quick start

### Install

Install `togeojson`

```coffee
install.packages("devtools")
library("devtools")
install_github("ropensci/togeojson")
library("togeojson")
```

### Convert to geoJSON

Convert file to geoJSON

Download a shape file. For example purposes, download this one -> [https://raw.githubusercontent.com/ropensci/datasets/master/poa_annua_dist/bison-Poa_annua-20140508-151800.kml](https://raw.githubusercontent.com/ropensci/datasets/master/poa_annua_dist/bison-Poa_annua-20140508-151800.kml)

Then:

Define path to file (change to your path)

```coffee
file = "~/Downloads/ne_110m_admin_0_countries/ne_110m_admin_0_countries.shp"
```

Use `file_to_geojson` to convert shp file to

```coffee
file_to_geojson(file, method='local', outfilename='shp_local')

## Success! File is at ~/shp_local.geojson
```

This outputs a `.geojson` file.

### Convert to topoJSON

For topojson you will need Mike Bostock's command line client. Install it by doing

```
npm install -g topojson
```

Download a zipped shape fileset, [this one](http://esp.cr.usgs.gov/data/little/querwisl.zip) for distribution of _Quercus wislizeni_. Unzip the zip file to a folder. Then do (changing the path to your path)

```coffee
to_topojson(shppath='~/Downloads/querwisl', projection='albers', projargs=list(rotate='[60, -35, 0]'))
```

Which prints progress on the conversion of the shape file. And prints the topojson CLI call, including the location of the output file, here `/Users/sacmac/querwisl.json`

```coffee
OGR data source with driver: ESRI Shapefile
Source: "/Users/sacmac/Downloads/querwisl", layer: "querwisl"
with 35 features and 5 fields
Feature type: wkbPolygon with 2 dimensions
topojson -o /Users/sacmac/querwisl.json -q 1e4 -s 0 --shapefile-encoding utf8 --projection 'd3.geo.albers().rotate([60, -35, 0])' -- /var/folders/gs/4khph0xs0436gmd2gdnwsg080000gn/T//Rtmp49APW7/querwisl.shp

bounds: -403.2554825867553 401.27189387582916 -295.798050380061 585.4214768677039 (cartesian)
pre-quantization: 0.010746817902459677 0.018416799979185387
topology: 35 arcs, 2492 points
prune: retained 35 / 35 arcs (100%)
```

You can then use this topojson file wherever. We'll add a function soon to automagically throw this file up as a Github gist to get an interactive map.

### Meta

Please report any issues or bugs](https://github.com/ropensci/togeojson/issues).

License: MIT

This package is part of the [rOpenSci](http://ropensci.org/packages) project.

To cite package `togeojson` in publications use:

```coffee
To cite package ‘togeojson’ in publications use:

  Scott Chamberlain, Joel Gombin, Ian Munoz and Edmund Hart (2014). togeojson: Convert data to geoJSON or topoJSON. R package version
  0.0.5.

A BibTeX entry for LaTeX users is

  @Manual{,
    title = {togeojson: Convert data to geoJSON or topoJSON},
    author = {Scott Chamberlain and Joel Gombin and Ian Munoz and Edmund Hart},
    year = {2014},
    note = {R package version 0.0.5},
  }

```

Get citation information for `togeojson` in R doing `citation(package = 'togeojson')`

[![](http://ropensci.org/public_images/github_footer.png)](http://ropensci.org)
