# geojsonio 0.11.3

* Removed an unused V8 call to geojsonhint

* Removed all remaining references to rgeos

# geojsonio 0.11.2

* This is a tiny patch release with no user-facing changes.

* Added `\alias{geojsonio-package}` to `man/geojsonio.rd`.

# geojsonio 0.11.1

* Removed references to geojsonlint as that package nears retirement.

# geojsonio 0.11.0

## Breaking changes

* SpatialPolygonsDataFrame inputs are now cast to sf before being written out to
  fix ring ordering. This was previously handled by maptools, which is being 
  retired. Outputs are visually identical, but underlying representations may
  have changed.
* Functions relying on rgeos (such as those writing rgeos objects to file) are 
  defunct. PRs to replace these using the newer geos package are welcomed.
  
## New features

* `topojson_write()` has been restored, and now supports conversion to topoJSON
  formats. User reports indicate output files might be larger than anticipated;
  PRs to address this are welcomed. Huge thanks to @Shaunson26 for this PR!

## Other changes

* The rgeos and maptools packages have been removed from Imports. (Thanks to 
  Roger Bivand and Mike Sumner on Mastodon!)

# geojsonio 0.10.0

* Deprecated (with a warning) functions relying on rgeos. These will stop working in 2023.
* Tests have been updated to use testthat 3e, plus a number of other improvements around isolating tests and improving test quality. HUGE thanks to @czeildi for tackling this in two massive PRs (#187, #186, #183).

# geojsonio 0.9.5

geojsonio 0.9.4
===============

### BUG FIXES

* fix for `sprintf()` usage within the `projections()` function; only run sprintf on a particular string if it has length > 0 (#172)
* fix for `as.json()` when the input is the output of `topojson_list()` - we weren't constructing the TopoJSON arcs correctly (#160)
* fix to `geojson_read()`: now using package `geojsonsf` to read geojson (#163)

geojsonio 0.9.2
===============

### BUG FIXES

* fix a test for change in `stringsAsFactors` behavior in R v4 (#166) (#167)
* temporarily make `topojson_write()` defunct until we can sort out issues with new sf version (#168)

geojsonio 0.9.0
===============

### NEW FEATURES

* `geojson_sf()` and `geojson_sp()` now accept strings in addition to `json`, `geoson_list` and `geojson_json` types (#164)

### MINOR IMPROVEMENTS

* `topojson_json()` and `topojson_list()` gain params `object_name` and `quantization` to pass through to `geojson_json()` (#158)
* replace httr with crul (#105)
* rgdal replaced with sf throughout the package; all `writeOGR` replaced with `st_write` and `readOGR` with `st_read`; this should not create any user facing changes, but please let us know if you have problems with this version (#41) (#150) (#157)


geojsonio 0.8.0
===============

## NEW FEATURES

* `geojson_read()` gains new S3 method `geojson_read.PqConnection` for connecting to a PostgreSQL database set up with PostGIS. See also `?postgis` for notes on Postgis installation, and setting up some simple data in Postgis from this package (#61) (#155) thanks to @fxi

### MINOR IMPROVEMENTS

* `geojson_read()` instead of going through package `sp` now goes through package `sf` for a significant speed up, see https://github.com/ropensci/geojsonio/issues/136#issuecomment-546123078 (#136)
* `geojson_list()` gains parameter `precision` to adjust number of decimal places used. only applies to classes from packages sp and rgeos (#152) (related to #141) thanks to @ChrisJones687
* improve dependency installation notes in README (#149) (#151) thanks @setgree and @nickto
* move to using markdown docs
* `file_to_geojson()` now using https protocol instead of http for the online ogre service called when using `method = "web"`

### BUG FIXES

* fix `geojson_read()` to fail better when using `method="web"`; and update docs to note that `method="web"` can result if file size issues, but `method="local"` should not have such issues (#153)
* change name of `print.location` method to not conflict with `dplyr` (#154)


geojsonio 0.7.0
===============

## NEW FEATURES

* `geo2topo()` gains a new parameter `quantization` to quantize geometry prior to computing topology. because `topojson_write()` uses `geo2topo()` internally, `topojson_write()` also gains a `quantization` parameter that's passed to `geo2topo()` internally (#138) thanks @pvictor

### MINOR IMPROVEMENTS

* use package `sf` instead of `sp` in `topojson_read()`. note that the return object is now class sf instead of classes from the sp package (#144) (#145)
* the `type` parameter in `topojson_json()` now set to `type="auto"` if the input is an sf/sfc/sfg class object (#139) (#146)
* fix to `geojson_list.sfc()` for changes in sf >= v0.7, which names geometries, but that's not valid geojson (#142)

### DEPRECATED AND DEFUNCT

* The two linting functions in this package, `lint()` and `validate()`
are now defunct. They have been marked as deprecated since `v0.2`. See the package `geojsonlint` on CRAN for linting geojson functionality (#135) (#147)


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
specification at <https://www.rfc-editor.org/rfc/rfc7946> (#114)



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
