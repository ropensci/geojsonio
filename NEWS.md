geojsonio 0.6.0
===============

## NEW FEATURES

* `topojson_write()` gains a new parameter `object_name`. With it you can set the name for the resulting TopoJSON object name created. As part of this `geo2topo()` also gains a new parameter, similarly called `object_name`, that does the same thing as for `topojson_write()`. (#129) (thanks @josiekre) PR (#131)
* As part of PR (#132) we added a new function `geojson_sf()` to convert output of `geojson_list()` or `geojson_json()` to `sf` package classes - as an analog to `geojson_sp()`

### MINOR IMPROVEMENTS

* `geojson_json()` gains option with the `type` parameter to skip a coercion to the `geojson` package class `geoclass`. Using `type = "skip"` you can skip the `geoclass` class coercion, which in some cases with large datasets should have performance improvements (#128) PR (#133)

### BUG FIXES

* A bug arose in `geojson_sp()` with the newest version of `rgdal`. This was resolved by using the `sf` package instead to read GeoJSON. This had a knock-on benefit of speeding up reading GeoJSON. In addition, `sf` is now in `Imports` instead of `Suggests`  (#130) PR (#132)


geojsonio 0.5.0
===============

### NEW FEATURES

* gains new function `geojson_atomize` to "atomize" a FeatureCollection
into its features, or a GeometryCollection into its geometries (#120)
via (#119) thx @SymbolixAU
* gains new functions `topojson_list` and `topojson_json` for converting
many input types with spatial data to TopoJSON, both as lists and
as JSON (#117)
* `geojson_json` uses brief output provided by the `geojson`
package - this makes it less frustrating when you have an especially
large geojson string that prints to console - this instead prints a
brief summary of the GeoJSON object (#86) (#124)

### MINOR IMPROVEMENTS

* doing a much more thorough job of cleaning up temp files that are
necessarily generated due to having to go to disk sometimes (#122)
* @ateucher made improvements to `geojson_json` to make `type`
parameter more flexible (#125)

### BUG FIXES

* Fixe bug in `topojson_write` - we were writing topojson file, but also
a geojson file - we now cleanup the geojson file (#127)


geojsonio 0.4.2
===============

### BUG FIXES

* Fix package so that we load `topojson-server.js` from within the
package instead of from the web. This makes it so that the
package doesn’t make any web requests on load, which prevented package
from loading when no internet connection available. (#118)


geojsonio 0.4.0
===============

### NEW FEATURES

* Gains new functions `geo2topo`, `topo2geo`, `topojson_write`, and `topojson_read` for working with TopoJSON data - associated with this, we
now import `geojson` package (#24) (#100)

### MINOR IMPROVEMENTS

* Updated vignette with details on the GeoJSON specification to the new
specification at <https://tools.ietf.org/html/rfc7946> (#114)



geojsonio 0.3.8
===============

### MINOR IMPROVEMENTS

* `geojson_write` and `geojson_json` now pass `...` argument through to
`rgdal::writeOGR` or `jsonlite::toJSON` depending on the class/method. For
those methods that use the latter, this now allows setting of the `na`
argument to control how `NA` values are represented in json, and the
`pretty` argument to control whether or the resulting json is
pretty-formated or compact (#109) (#111)
* Spelling/grammar fixes, thanks @patperu ! (#106)

### BUG FIXES

* `geojson_json` and `geojson_write` now convert unsupported classes to
their basic class before conversion and/or writing to geojson. This was most
commonly occurring with fields in `sf` objects calculated by `sf::st_area`
and `sf::st_length` which were of class `units`. (#107)
* Fixed a bug occurring with `GDAL` version >= 2.2.0 where the layer name in
a geojson file was not detected properly (#108)


geojsonio 0.3.2
==============

### BUG FIXES

* Fix to tests for internal fxn `convert_wgs84` to do minimal test of
output, and to conditionally test only if `sf` is available (#103)


geojsonio 0.3.0
==============

### NEW FEATURES

* `geojson_json`, `geojson_list`, and `geojson_write` gain new S3 methods:
`sf`, `sfc`, and `sfg` - the three classes in the `sf` package (#95)
* `geojson_json`, `geojson_list`, and `geojson_write` gain two new
parameters each: `convert_wgs84` (boolean) to convert to WGS84 or not (the
projection assumed for GeoJSON)  and `crs` to assign a CRS if known
(#101) (#102)

### MINOR IMPROVEMENTS

* `geojson_json()` for non-sp classes now only keeps seven decimal places
in the coordinates. This follows the default that GDAL uses.
* Now namespacing base package calls for `methods`/`stats`/`utils`
instead of importing them
* Improved documentation for `method` parameter in `geojson_read`
clarifying what the options are for (#93) thanks @bhaskarvk
* Internal fxn `to_json` now defaults to 7 digits, which is used in
`as.json` and `geojson_json` (#96)

### BUG FIXES

* Fix to `geojson_read` to read correctly from a URL - in addition
to file paths (#91) (#92) thanks @lecy
* Fix to `geojson_read` to read non-`.geojson` extensions (#93)
thanks @bhaskarvk


geojsonio 0.2.0
===============

### MINOR IMPROVEMENTS

* Major performance improvement for `geojson_json()` - moved to
reading in json with `readr::read_file()` (#85) thanks @javrucebo !
* Now requiring explicit versions of some package dependencies
* Removed the startup message

### BUG FIXES

* Changed `file_to_geojson()` to use `httr::write_disk()` instead of
`download.file()` (#83) thanks @patperu

### DEPRECATED AND DEFUNCT

* The two linting functions in this package, `lint()` and `validate()`
are now deprecated, and will be defunct in the next version of this
package. See the new package `geojsonlint` on CRAN for linting
geojson functionality (#82)

geojsonio 0.1.8
===============

### NEW FEATURES

* New method `geojson_sp.json()` added to `geojson_sp()` to handle json
class inputs

### MINOR IMPROVEMENTS

* Added `encodin="UTF-8"` to `httr::content()` calls

### BUG FIXES

* `geojson_write()` didn't overwrite existing files despite saying so.
New parameter added to the function `overwrite` to specify whether to
overwrite a function or not, which defaults to `TRUE` (#81)
thanks @Robinlovelace !

geojsonio 0.1.6
===============

### NEW FEATURES

* New function `geojson_sp()` to convert output of `geojson_list()` or
`geojson_json()` to spatial classes (e.g., `SpatialPointsDataFrame`) (#71)

### MINOR IMPROVEMENTS

* Startup message added to notify users to ideally update to `rgdal > v1.1-1`
given fix to make writing multipolygon objects to geojson correct (#69)
* Filled out test suite more (#46)

### BUG FIXES

* Fix to `lint()` function, due to bug in passing data to the Javascript
layer (#73)
* Fixes to `as.json()` (#76)

geojsonio 0.1.4
===============

### NEW FEATURES

* New function `map_leaf()` uses the `leaflet` package to make maps, with
S3 methods for most spatial classes as well as most R classes, including
data.frame's, lists, vectors, file inputs, and more (#48)
* `geojson_read()` now optionally can give back a spatial class object,
just a convenience in case you want to not get back geojson, but a
spatial class (#60)

### MINOR IMPROVEMENTS

* Now that `leaflet` R package is on CRAN, put back in examples using
it to make maps (#49)
* Added a linter for list inputs comined with `geometry="polygon"` to
all `geojson_*()` functions that have `.list` methods. This checks to
make sure inputs have the same first and last coordinate pairs to
close the polygon (#34)

### BUG FIXES

* Importing all non-base R funtions, including from `methods`, `stats` and `utils`
packages (#62)
* Fixed bug in `geojson_write()` in which geojson style names were altered
on accident (#56)

geojsonio 0.1.0
===============

### NEW FEATURES

* released to CRAN
