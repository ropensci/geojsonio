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

9 packages

|package        |version | errors| warnings| notes|
|:--------------|:-------|------:|--------:|-----:|
|antaresViz     |0.11    |      0|        0|     0|
|jpmesh         |0.3.0   |      0|        0|     1|
|leaflet.esri   |0.2     |      0|        0|     0|
|leaflet.extras |0.2     |      0|        0|     0|
|mregions       |0.1.4   |      0|        0|     0|
|repijson       |0.1.0   |      0|        0|     0|
|rmapshaper     |0.3.0   |      0|        0|     0|
|rmapzen        |0.3.3   |      1|        0|     0|
|webglobe       |1.0.2   |      0|        0|     1|

## antaresViz (0.11)
Maintainer: Francois Guillem <francois.guillem@rte-france.com>  
Bug reports: https://github.com/rte-antares-rpackage/antaresViz/issues

0 errors | 0 warnings | 0 notes

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

## leaflet.esri (0.2)
Maintainer: Bhaskar Karambelkar <bhaskarvk@gmail.com>  
Bug reports: https://github.com/bhaskarvk/leaflet.esri/issues

0 errors | 0 warnings | 0 notes

## leaflet.extras (0.2)
Maintainer: Bhaskar Karambelkar <bhaskarvk@gmail.com>  
Bug reports: https://github.com/bhaskarvk/leaflet.extras/issues

0 errors | 0 warnings | 0 notes

## mregions (0.1.4)
Maintainer: Scott Chamberlain <myrmecocystus@gmail.com>  
Bug reports: https://github.com/ropenscilabs/mregions/issues

0 errors | 0 warnings | 0 notes

## repijson (0.1.0)
Maintainer: Andy South <southandy@gmail.com>

0 errors | 0 warnings | 0 notes

## rmapshaper (0.3.0)
Maintainer: Andy Teucher <andy.teucher@gmail.com>  
Bug reports: https://github.com/ateucher/rmapshaper/issues

0 errors | 0 warnings | 0 notes

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

## webglobe (1.0.2)
Maintainer: Richard Barnes <rbarnes@umn.edu>  
Bug reports: https://github.com/r-barnes/webglobe/

0 errors | 0 warnings | 1 note 

```
checking installed package size ... NOTE
  installed size is 10.5Mb
  sub-directories of 1Mb or more:
    client   9.4Mb
    doc      1.0Mb
```

