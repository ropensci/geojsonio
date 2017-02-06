# Setup

## Platform

|setting  |value                        |
|:--------|:----------------------------|
|version  |R version 3.3.2 (2016-10-31) |
|system   |x86_64, darwin13.4.0         |
|ui       |X11                          |
|language |(EN)                         |
|collate  |en_US.UTF-8                  |
|tz       |Europe/Berlin                |
|date     |2017-02-06                   |

## Packages

|package   |*  |version    |date       |source                           |
|:---------|:--|:----------|:----------|:--------------------------------|
|geojsonio |   |0.3.2      |2017-02-06 |local (ropensci/geojsonio@NA)    |
|leaflet   |   |1.0.2.9010 |2017-02-06 |Github (rstudio/leaflet@b9736ec) |

# Check results
1 packages with problems

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

