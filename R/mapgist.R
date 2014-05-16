#' Publish an interactive map to view in the browser as a Github gist
#' 
#' @export
#' @param geojsonfile Path to a geojson file
#' @param description Description for the Github gist, or leave to default (=no description)
#' @param browse If TRUE (default) the map opens in your default browser.
#' @param ... Further arguments passed on to \code{togeojson_gist}
#' @description 
#' You will be asked ot enter you Github credentials (username, password) during
#' each session, but only once for each session. Alternatively, you could enter
#' your credentials into your .Rprofile file with the entries
#' 
#' \itemize{
#'  \item options(github.username = 'your_github_username')
#'  \item options(github.password = 'your_github_password')
#' }
#' 
#' then \code{map_gist} will simply read those options.
#' 
#' \code{map_gist} has modified code from the rCharts package by Ramnath Vaidyanathan 
#' @return Creates a gist on your Github account, and prints out where the geojson file was
#' written on your machinee, the url for the gist, and an embed script in the console.
#' 
#' @examples \dontrun{
#' map_gist(geojsonfile='~/zillow_mt.geojson')
#' }

map_gist <- function(geojsonfile, description = "", file = "gistmap", browse = TRUE, ...){
  tt <- togeojson_gist(geojsonfile, description = description, ...)
  if (browse) 
    browseURL(tt)
} 

#' Post a file as a Github gist
#' 
#' @import httr
#' @param gist An object
#' @param description brief description of gist (optional)
#' @param public whether gist is public (default: TRUE)
#' @description 
#' You will be asked ot enter you Github credentials (username, password) during
#' each session, but only once for each session. Alternatively, you could enter
#' your credentials into your .Rprofile file with the entries
#' 
#' \enumerate{
#'  \item options(github.username = 'your_github_username')
#'  \item options(github.password = 'your_github_password')
#' }
#' 
#' then \code{gist} will simply read those options.
#' 
#' \code{gist} was modified from code in the rCharts package by Ramnath Vaidyanathan 
#' @return Posts your file as a gist on your account, and prints out the url for the 
#' gist itself in the console.
#' @keywords internal
#' @examples \dontrun{
#' library(plyr)
#' splist <- c('Accipiter erythronemius', 'Junco hyemalis', 'Aix sponsa')
#' keys <- sapply(splist, function(x) gbif_lookup(name=x, kingdom='plants')$speciesKey, 
#'    USE.NAMES=FALSE)
#' out <- occ_search(keys, hasCoordinate=TRUE, limit=50, return='data')
#' dat <- ldply(out)
#' datgeojson <- spocc_stylegeojson(input=dat, var='name', 
#'    color=c('#976AAE','#6B944D','#BD5945'), size=c('small','medium','large'))
#' write.csv(datgeojson, '~/my.csv')
#' spocc_togeojson(input='~/my.csv', method='web', outfilename='my')
#' spocc_gist('~/my.geojson', description = 'Occurrences of three bird species mapped')
#' }

togeojson_gist <- function(gist, description = "", public = TRUE) {
  dat <- togeojson_create_gist(gist, description = description, public = public)
  credentials <- togeojson_get_credentials()
  response <- POST(url = "https://api.github.com/gists", 
                   body = dat, config = c(
          authenticate(getOption("github.username"), 
              getOption("github.password"), type = "basic"), add_headers(`User-Agent` = "Dummy")))
  stop_for_status(response)
  html_url <- content(response)$html_url
  message("Your gist has been published")
  message("View gist at ", paste("https://gist.github.com/", getOption("github.username"), 
                                 "/", basename(html_url), sep = ""))
  message("Embed gist with ", paste("<script src=\"https://gist.github.com/", getOption("github.username"), 
                                    "/", basename(html_url), ".js\"></script>", sep = ""))
  return(paste("https://gist.github.com/", getOption("github.username"), "/", basename(html_url), 
               sep = ""))
}

#' Function that takes a list of files and creates payload for API
#' @importFrom RJSONIO toJSON
#' @param filenames names of files to post
#' @param description brief description of gist (optional)
#' @param public whether gist is public (defaults to TRUE)
#' @keywords internal
togeojson_create_gist <- function(filenames, description = "", public = TRUE) {
  files <- lapply(filenames, function(file) {
    x <- list(content = paste(readLines(file, warn = F), collapse = "\n"))
  })
  names(files) <- basename(filenames)
  body <- list(description = description, public = public, files = files)
  RJSONIO::toJSON(body)
}
#' Get Github credentials from use in console
#' @keywords internal
togeojson_get_credentials <- function() {
  if (is.null(getOption("github.username"))) {
    username <- readline("Please enter your github username: ")
    options(github.username = username)
  }
  if (is.null(getOption("github.password"))) {
    password <- readline("Please enter your github password: ")
    options(github.password = password)
  }
}