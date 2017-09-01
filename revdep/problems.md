# Setup

## Platform

|setting  |value                                       |
|:--------|:-------------------------------------------|
|version  |R version 3.4.1 Patched (2017-07-04 r72893) |
|system   |x86_64, darwin15.6.0                        |
|ui       |RStudio (1.1.331)                           |
|language |(EN)                                        |
|collate  |en_US.UTF-8                                 |
|tz       |America/Vancouver                           |
|date     |2017-09-01                                  |

## Packages

|package   |*  |version |date       |source                        |
|:---------|:--|:-------|:----------|:-----------------------------|
|geojsonio |   |0.4.2   |2017-09-01 |local (ropensci/geojsonio@NA) |

# Check results

1 packages with problems

|package |version | errors| warnings| notes|
|:-------|:-------|------:|--------:|-----:|
|rmapzen |0.3.3   |      1|        0|     0|

## rmapzen (0.3.3)
Maintainer: Tarak Shah <tarak_shah@berkeley.edu>  
Bug reports: https://github.com/tarakc02/rmapzen/issues

1 error  | 0 warnings | 0 notes

```
checking tests ... ERROR
  Running ‘testthat.R’ [12s/13s]
Running the tests in ‘tests/testthat.R’ failed.
Complete output:
  > library(testthat)
  > library(rmapzen)
  > 
  > test_check("rmapzen")
  Assertion failed: (!"should never be reached"), function itemsTree, file ../../../../src/geos-3.6.1/src/index/strtree/AbstractSTRtree.cpp, line 373.
```

