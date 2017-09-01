## Test environments

* local OS X install, R 3.4.1 patched
* ubuntu 12.04 (on travis-ci), R 3.4.1
* win-builder (devel and release)

## R CMD check results

0 errors | 0 warnings | 1 note

   License components with restrictions and base license permitting such:
     MIT + file LICENSE
   File 'LICENSE':
     YEAR: 2017
     COPYRIGHT HOLDER: Scott Chamberlain

## Reverse dependencies

* I have run R CMD check on the 9 downstream dependencies.
  (Summary at <https://github.com/ropensci/geojsonio/blob/master/revdep/README.md>).
  One package errored on check but was unrelated to this package.

-------

This version includes a bug fix - javascript code from within 
package instead of from the internet.

Thanks!
Scott Chamberlain
