# MazamaSpatialUtils

<details>

* Version: 0.6.4
* Source code: https://github.com/cran/MazamaSpatialUtils
* URL: https://github.com/MazamaScience/MazamaSpatialUtils
* BugReports: https://github.com/MazamaScience/MazamaSpatialUtils/issues
* Date/Publication: 2019-09-28 19:40:03 UTC
* Number of recursive dependencies: 88

Run `revdep_details(,"MazamaSpatialUtils")` for more info

</details>

## Newly broken

*   checking installed package size ... NOTE
    ```
      installed size is  5.1Mb
      sub-directories of 1Mb or more:
        data   4.4Mb
    ```

## In both

*   checking tests ...
    ```
     ERROR
    Running the tests in ‘tests/testthat.R’ failed.
    Last 13 lines of output:
      1: testthat::expect_match(getCountryName(2, 47, countryCodes = c("FR")), "France") at testthat/test-getCountryName.R:20
      2: quasi_label(enquo(object), label, arg = "object")
      3: eval_bare(get_expr(quo), get_env(quo))
      4: getCountryName(2, 47, countryCodes = c("FR"))
      5: SPDF[SPDF$countryCode %in% countryCodes, ]
      6: SPDF[SPDF$countryCode %in% countryCodes, ]
      
      ══ testthat results  ═══════════════════════════════════════════════════════════
      [ OK: 90 | SKIPPED: 26 | WARNINGS: 0 | FAILED: 3 ]
      1. Error: subsetting with countryCodes works (@test-getCountry.R#20) 
      2. Error: subsetting with countryCodes works (@test-getCountryCode.R#20) 
      3. Error: subsetting with countryCodes works (@test-getCountryName.R#20) 
      
      Error: testthat unit tests failed
      Execution halted
    ```

