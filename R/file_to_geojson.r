#' Convert spatial data files to GeoJSON from various formats.
#'
#' You can use a web interface called Ogre, or do conversions locally using the
#' rgdal package.
#'
#' @export
#' @param input The file being uploaded, path to the file on your machine.
#' @param output Destination for output geojson file. Defaults to current
#' working directory, and gives a random alphanumeric file name
#' @param encoding (character) The encoding passed to
#' \code{\link[rgdal]{readOGR}}.  Default: CP1250
#' @param verbose (logical) Printing of \code{\link[rgdal]{readOGR}} progress.
#' Default: \code{FALSE}
#' @template read
#' @examples \dontrun{
#' file <- system.file("examples", "norway_maple.kml", package = "geojsonio")
#'
#' # KML type file - using the web method
#' file_to_geojson(input=file, method='web', output='kml_web')
#' ## read into memory
#' file_to_geojson(input=file, method='web', output = ":memory:")
#' file_to_geojson(input=file, method='local', output = ":memory:")
#'
#' # KML type file - using the local method
#' file_to_geojson(input=file, method='local', output='kml_local')
#'
#' # Shp type file - using the web method - input is a zipped shp bundle
#' file <- system.file("examples", "bison.zip", package = "geojsonio")
#' file_to_geojson(file, method='web', output='shp_web')
#'
#' # Shp type file - using the local method - input is the actual .shp file
#' file <- system.file("examples", "bison.zip", package = "geojsonio")
#' dir <- tempdir()
#' unzip(file, exdir = dir)
#' list.files(dir)
#' shpfile <- file.path(dir, "bison-Bison_bison-20130704-120856.shp")
#' file_to_geojson(shpfile, method='local', output='shp_local')
#'
#' # Neighborhoods in the US
#' ## beware, this is a long running example
#' # url <- 'http://www.nws.noaa.gov/geodata/catalog/national/data/ci08au12.zip'
#' # out <- file_to_geojson(input=url, method='web', output='cities')
#'
#' # geojson with .json extension
#' ## this doesn't work anymore, hmmm
#' # x <- gsub("\n", "", paste0('https://gist.githubusercontent.com/hunterowens/
#' # 25ea24e198c80c9fbcc7/raw/7fd3efda9009f902b5a991a506cea52db19ba143/
#' # wards2014.json', collapse = ""))
#' # res <- file_to_geojson(x)
#' # jsonlite::fromJSON(res)
#' # res <- file_to_geojson(x, method = "local")
#' # jsonlite::fromJSON(res)
#' }

file_to_geojson <- function(input, method = "web", output = ".", parse = FALSE,
                            encoding = "CP1250", verbose = FALSE, ...) {

  method <- match.arg(method, choices = c("web", "local"))
  if (!inherits(parse, "logical")) stop("parse must be logical", call. = FALSE)

  input <- handle_remote(input)
  mem <- ifelse(output == ":memory:", TRUE, FALSE)

  if (method == "web") {
    url <- "http://ogre.adc4gis.com/convert"
    tt <- httr::POST(url, body = list(upload = httr::upload_file(input)))
    if (tt$status_code > 201) {
      res <- tryCatch(
        httr::content(tt, as = "text", encoding = "UTF-8"),
        error = function(e) e
      )
      if (inherits(res, "error")) httr::stop_for_status(tt)
      res2 <- tryCatch(
        jsonlite::fromJSON(res),
        error = function(e) e
      )
      if (inherits(res2, "error")) httr::stop_for_status(tt)
      stop(paste0(res2[[1]], collapse = "\n"), call. = FALSE)
    }
    out <- httr::content(tt, as = "text", encoding = "UTF-8")
    if (mem) {
      jsonlite::fromJSON(out, parse)
    } else {
      if (output == ".") {
        temp <- tempfile()
        on.exit(unlink(temp))
        output <- basename(temp)
      }
      fileConn <- file(paste0(output, ".geojson"))
      writeLines(out, fileConn)
      close(fileConn)
      file_at(output)
      file_ret(path.expand(output))
    }
  } else {
    fileext <- ftype(input)
    if (output == ":memory:") {
      temp <- tempfile()
      output <- temp
      on.exit(unlink(temp))
      on.exit(unlink(output), add = TRUE)
    } else if (output == ".") {
      temp <- tempfile()
      output <- basename(temp)
      on.exit(unlink(temp))
      on.exit(unlink(output), add = TRUE)
    }

    output <- path.expand(output)
    if (fileext == "kml") {
      my_layer <- rgdal::ogrListLayers(input)
      x <- rgdal::readOGR(input, layer = my_layer[1],
                          drop_unsupported_fields = TRUE,
                          verbose = FALSE, stringsAsFactors = FALSE,
                          encoding = encoding, ...)
      write_ogr2(x, output)
      if (mem) {
        from_json(output, parse)
      } else {
        file_at(output)
        file_ret(output)
      }
    } else if (fileext == "shp") {
      x <- rgdal::readOGR(input, rgdal::ogrListLayers(input),
                          verbose = FALSE, stringsAsFactors = FALSE,
                          encoding = encoding, ...)
      write_ogr2(x, output)
      if (mem) {
        from_json(output, parse)
      } else {
        file_at(output)
        file_ret(output)
      }
    } else if (fileext %in% c("geojson", "json")) {
      unlink(paste0(output, ".geojson"))
      x <- rgdal::readOGR(input, rgdal::ogrListLayers(input),
                          verbose = FALSE, stringsAsFactors = FALSE,
                          encoding = encoding, ...)

      write_ogr2(x, output)
      if (mem) {
        from_json(output, parse)
      } else {
        file_at(output)
        file_ret(output)
      }
    } else {
      stop("only .shp, .kml, .topojson, and url's are supported",
           call. = FALSE)
    }
  }
}

write_ogr2 <- function(x, y) {
  unlink(paste0(y, ".geojson"))
  rgdal::writeOGR(x, paste0(y, ".geojson"), basename(y), driver = "GeoJSON",
                  check_exists = FALSE)
}

file_at <- function(x) {
  message(paste0("Success! File is at ", x, ".geojson"))
}

file_ret <- function(x) {
  invisible(paste0(x, ".geojson"))
}

from_json <- function(x, parse) {
  on.exit(unlink(paste0(x, ".geojson")))
  jsonlite::fromJSON(paste0(x, ".geojson"), parse)
}

ftype <- function(z) {
  if (is.url(z)) {
    z <- httr::parse_url(z)$path
  }
  fileext <- strsplit(z, "\\.")[[1]]
  fileext[length(fileext)]
}

# If given a url for a zip file, download it give back a path to the temporary file
handle_remote <- function(x){
  if (!is.url(x)) {
    return(x)
  } else {
    tfile <- tempfile(fileext = paste0(".", ftype(x)))
    res <- httr::GET(x, httr::write_disk(tfile))
    httr::stop_for_status(res)
    res$request$output$path
  }
}
