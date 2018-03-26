## Test environments

* local OS X install, R 3.4.4 patched
* ubuntu 12.04 (on travis-ci), R 3.4.4
* win-builder (devel and release)

## R CMD check results

0 errors | 0 warnings | 1 note

   License components with restrictions and base license permitting such:
     MIT + file LICENSE
   File 'LICENSE':
     YEAR: 2018
     COPYRIGHT HOLDER: Scott Chamberlain

## Reverse dependencies

* I have run R CMD check on the 7 downstream dependencies. (Summary at <https://github.com/ropensci/geojsonio/blob/master/revdep/README.md>). One package errored on check but I know the maintainer of that package is nearly ready to submit a new version.

-------

This version includes a number of bug fixes, some minor improvements, and 
some performance improvements. Fixes herein should fix the CRAN check errors.

Thanks!
Scott Chamberlain
