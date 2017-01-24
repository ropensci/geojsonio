# Setup

## Platform

|setting  |value                        |
|:--------|:----------------------------|
|version  |R version 3.3.2 (2016-10-31) |
|system   |x86_64, darwin13.4.0         |
|ui       |RStudio (1.1.48)             |
|language |(EN)                         |
|collate  |en_US.UTF-8                  |
|tz       |Europe/Stockholm             |
|date     |2017-01-24                   |

## Packages

|package   |*  |version    |date       |source                           |
|:---------|:--|:----------|:----------|:--------------------------------|
|geojsonio |   |0.3.0      |2017-01-24 |local (ropensci/geojsonio@NA)    |
|leaflet   |   |1.0.2.9010 |2017-01-24 |Github (rstudio/leaflet@cbb3495) |

# Check results
5 packages

## jpmesh (0.3.0)
Maintainer: Shinya Uryu <suika1127@gmail.com>  
Bug reports: https://github.com/uribo/jpmesh/issues

0 errors | 0 warnings | 1 note 

```
checking installed package size ... NOTE
  installed size is 205.9Mb
  sub-directories of 1Mb or more:
    extdata  205.2Mb
```

## jpndistrict (0.1.0)
Maintainer: Shinya Uryu <suika1127@gmail.com>  
Bug reports: https://github.com/uribo/jpndistrict/issues

0 errors | 0 warnings | 0 notes

## mregions (0.1.4)
Maintainer: Scott Chamberlain <myrmecocystus@gmail.com>  
Bug reports: https://github.com/ropenscilabs/mregions/issues

0 errors | 0 warnings | 0 notes

## repijson (0.1.0)
Maintainer: Andy South <southandy@gmail.com>

0 errors | 0 warnings | 0 notes

## rmapshaper (0.1.0)
Maintainer: Andy Teucher <andy.teucher@gmail.com>  
Bug reports: http://www.github.com/ateucher/rmapshaper/issues

1 error  | 0 warnings | 0 notes

```
checking tests ... ERROR
Running the tests in ‘tests/testthat.R’ failed.
Last 13 lines of output:
  > 
  > test_check("rmapshaper")
  1. Failure: ms_simplify works with lines (@test-simplify.R#442) ----------------
  ms_simplify(line_list) not equal to geojson_list(expected_json).
  Component "features": Component 1: Component 2: Component 2: Component 2: Component 2: Mean relative difference: 1.985531e-08
  
  
  testthat results ================================================================
  OK: 252 SKIPPED: 0 FAILED: 1
  1. Failure: ms_simplify works with lines (@test-simplify.R#442) 
  
  Error: testthat unit tests failed
  Execution halted
```

