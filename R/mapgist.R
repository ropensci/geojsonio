#' Publish an interactive map as a GitHub gist
#' 
#' @export
#' @importFrom gistr gist_create
#' 
#' @param geojsonfile Path to a geojson file
#' @param description Description for the Github gist, or leave to default (=no description)
#' @param public (logical) Want gist to be public or not? Default: TRUE
#' @param browse If TRUE (default) the map opens in your default browser.
#' @param ... Further arguments passed on to \code{\link[httr]{POST}}
#' 
#' @description There are two ways to authorize to work with your GitHub account:
#' 
#' \itemize{
#'  \item PAT - Generate a personal access token (PAT) at 
#'  \url{https://help.github.com/articles/creating-an-access-token-for-command-line-use} and 
#'  record it in the GITHUB_PAT envar in your \code{.Renviron} file.
#'  \item Interactive - Interactively login into your GitHub account and authorise with OAuth.
#' }
#' 
#' Using the PAT method is recommended.
#' 
#' Using the gist_auth() function you can authenticate seperately first, or if you're not 
#' authenticated, this function will run internally with each functionn call. If you have a 
#' PAT, that will be used, if not, OAuth will be used.
#' 
#' @examples \donttest{
#' url <- 'http://www.zillow.com/static/shp/ZillowNeighborhoods-MT.zip'
#' file <- file_to_geojson(input=url, method='web', outfilename='zillow_mt')
#' map_gist(file)
#' }

map_gist <- function(geojsonfile, description = "", public = TRUE, browse = TRUE, ...){
  gist_create(files = geojsonfile, 
              description = description,
              public = public,
              browse = browse, ...)
}
