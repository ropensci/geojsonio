This version of geojsonio moves off rgeos and maptools as part of the R-spatial
retirement project. Additionally, functions for writing topojson were restored.

## Resubmission

This is a resubmission. The previous submission broke rmapzen, as functions
in maptools behaved differently depending on if rgeos was installed. As this
release removed the dependency on rgeos for geojsonio and rmapzen only depended
upon maptools, not rgeos, rmapzen tests produced new errors with this version
of geojsonio. The author of rmapzen has fixed their package, and I believe this
version impacts no reverse dependencies.

## R CMD check results

0 errors | 0 warnings | 0 notes

## revdepcheck results

We checked 16 reverse dependencies, comparing R CMD check results across CRAN and dev versions of this package.

 * We saw 0 new problems
 * We failed to check 0 packages


-------

Thanks,
Mike Mahoney
