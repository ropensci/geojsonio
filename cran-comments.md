## Test environments

* local OS X install, R 3.3.2
* ubuntu 12.04 (on travis-ci), R 3.3.2
* win-builder (devel and release)

## R CMD check results

0 errors | 0 warnings | 1 note

   License components with restrictions and base license permitting such:
     MIT + file LICENSE
   File 'LICENSE':
     YEAR: 2017
     COPYRIGHT HOLDER: Scott Chamberlain

## Reverse dependencies

* I have run R CMD check on the 5 downstream dependencies.
  (Summary at <https://github.com/ropensci/geojsonio/blob/master/revdep/README.md>). 
  There was a problem in one downstream package, but the maintainer knows 
  about it.

-------

This version includes fixes to tests - conditionally run tests if package
sf is available, and not test proj4 strings, except that they are characters.

Thanks!
Scott Chamberlain
