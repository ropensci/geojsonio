## Test environments

* local OS X install, R 3.6.1 patched
* ubuntu 14.04 (on travis-ci), R 3.6.1
* win-builder (devel and release)

## R CMD check results

0 errors | 0 warnings | 0 notes

## Reverse dependencies

I have run R CMD check on the 9 reverse dependencies. Summary at <https://github.com/ropensci/rgbif/blob/master/revdep/README.md>. No problems were found related to this package. MazamaSpatialUtils package errors on check, but errors with both current CRAN version of this package and the version being submitted.

-------

This version adds a new method for reading geojson from a Postgres Postgis connection, makes some speed improvements to fxns, improves docs, and more. This version also cleans up a file left on disk as highlighted in some of the CRAN checks.

Thanks!
Scott Chamberlain
