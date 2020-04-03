## Test environments

* local OS X install, R 3.6.3 Patched
* ubuntu 16.04 (on travis-ci), R 3.6.2
* win-builder (devel and release)

## R CMD check results

0 errors | 0 warnings | 0 notes

## Reverse dependencies

I have run R CMD check on the 10 reverse dependencies. Summary at <https://github.com/ropensci/geojsonio/blob/master/revdep/README.md>. No problems were found related to this package.

-------

This is a resubmission of v0.9.2 of this package.

This version fixes stringsAsFactors behavior for the upcoming R ver 4.

There were failing tests in the test-crs_convert.R file. These have been commented out for now as per recommendation of Roger Bivand, suggesting that we skip these for now until sf stabilizes it's CRS tooling (I am guessing there's still some changes coming in the CRS usage in sf). 

I did test on a Fedora gcc-10 virtual machine and we still cannot replicate the error, so the function in that test has been made defunct for now until we can sort out what the problem is. 

I've fixed some other tests.

Thanks!
Scott Chamberlain
