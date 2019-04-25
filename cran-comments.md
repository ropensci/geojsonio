## Test environments

* local OS X install, R 3.5.3 patched
* ubuntu 14.04 (on travis-ci), R 3.5.3
* win-builder (devel and release)

## R CMD check results

0 errors | 0 warnings | 0 notes

-------

This version includes new parameters for two functions, fixes to 
some functions for changes in package sf, and two functions
are now defunct (one of which was causing errors in tests 
on cran checks, so that problem is gone).

Thanks!
Scott Chamberlain
