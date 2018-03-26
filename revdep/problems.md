# leaflet.esri

Version: 0.2

## In both

*   checking dependencies in R code ... NOTE
    ```
    Namespaces in Imports field not imported from:
      ‘htmlwidgets’ ‘shiny’
      All declared Imports should be used.
    ```

# leaflet.extras

Version: 0.2

## In both

*   checking dependencies in R code ... NOTE
    ```
    Namespace in Imports field not imported from: ‘shiny’
      All declared Imports should be used.
    ```

# rmapshaper

Version: 0.3.0

## Newly broken

*   checking tests ...
    ```
     ERROR
    Running the tests in ‘tests/testthat.R’ failed.
    Last 13 lines of output:
      Attributes: < Component "lines": Component 3: Attributes: < Component 1: 1 string mismatch > >
      Attributes: < Component "lines": Component 4: Attributes: < Component 1: 1 string mismatch > >
      
      ══ testthat results  ═══════════════════════════════════════════════════════════
      OK: 301 SKIPPED: 0 FAILED: 7
      1. Failure: ms_filter_fields works with polygons (@test-filter_fields.R#32) 
      2. Failure: ms_filter_fields works with lines (@test-filter_fields.R#52) 
      3. Failure: ms_innerlines works with all classes (@test-innerlines.R#45) 
      4. Failure: ms_innerlines works with all classes (@test-innerlines.R#46) 
      5. Failure: ms_lines works with all classes (@test-lines.R#42) 
      6. Failure: ms_lines works with all classes (@test-lines.R#43) 
      7. Failure: ms_lines works with fields specified (@test-lines.R#62) 
      
      Error: testthat unit tests failed
      Execution halted
    ```

## In both

*   checking re-building of vignette outputs ... WARNING
    ```
    Error in re-building vignettes:
      ...
    Quitting from lines 58-60 (rmapshaper.Rmd) 
    Error: processing vignette 'rmapshaper.Rmd' failed with diagnostics:
    Cannot open data source
    Execution halted
    ```

# rmapzen

Version: 0.3.3

## In both

*   checking data for non-ASCII characters ... NOTE
    ```
      Note: found 31 marked UTF-8 strings
    ```

# webglobe

Version: 1.0.2

## In both

*   checking installed package size ... NOTE
    ```
      installed size is 10.5Mb
      sub-directories of 1Mb or more:
        client   9.4Mb
        doc      1.0Mb
    ```

