#' Convert spatial data files to GeoJSON from various formats.
#'
#' You can use a web interface called Ogre, or do conversions locally using the
#' sf package.
#'
#' @export
#' @param input The file being uploaded, path to the file on your machine.
#' @param output Destination for output geojson file. Defaults to current
#' working directory, and gives a random alphanumeric file name
#' @param encoding (character) The encoding passed to [sf::st_read()].
#' Default: CP1250
#' @param verbose (logical) Printing of [sf::st_read()] progress.
#' Default: `FALSE`
#' @template read
#' @section File size:
#' When using `method="web"`, be aware of file sizes.
#' https://ogre.adc4gis.com that we use for this option does not document 
#' what file size is too large, but you should get an error message like 
#' "maximum file length exceeded" when that happens. `method="local"`
#' shouldn't be sensitive to file sizes.
#' @return path for the geojson file
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
#' # US National Weather Service Hydrologic service area boundaries
#' url <- 'https://www.weather.gov/source/gis/Shapefiles/Misc/hs05jn19.zip'
#' out <- file_to_geojson(input=url, method='web', output='hsa')
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
    con <- crul::HttpClient$new("https://ogre.adc4gis.com/convert")
    tt <- con$post(body = list(upload = crul::upload(input)))
    if (tt$status_code > 201) {
      res <- tryCatch(
        tt$parse("UTF-8"),
        error = function(e) e
      )
      if (inherits(res, "error")) tt$raise_for_status()
      res2 <- tryCatch(
        jsonlite::fromJSON(res),
        error = function(e) e
      )
      if (inherits(res2, "error")) tt$raise_for_status()
      if ("msg" %in% names(res2))
        stop(paste0(res2$msg, collapse = "\n"), call. = FALSE)
      else 
        stop("something went wrong, ",
          "open an issue at https://github.com/ropensci/geojsonio",
          call. = FALSE)
    }
    out <- tt$parse("UTF-8")
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
      x <- tosf(input, stringsAsFactors = FALSE,
        options = paste0("ENCODING=", encoding), ...)
      x <- sf::st_transform(x, 4326)
      write_ogr2sf(x, output)
      if (mem) {
        from_json(output, parse)
      } else {
        file_at(output)
        file_ret(output)
      }
    } else if (fileext == "shp") {
      x <- tosf(input, stringsAsFactors = FALSE,
        options = paste0("ENCODING=", encoding), ...)
      x <- sf::st_transform(x, 4326)
      write_ogr2sf(x, output)
      if (mem) {
        from_json(output, parse)
      } else {
        file_at(output)
        file_ret(output)
      }
    } else if (fileext %in% c("geojson", "json")) {
      x <- tosf(input, stringsAsFactors = FALSE, ...)
      x <- sf::st_transform(x, 4326)
      write_ogr2sf(x, output)
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

write_ogr2sf <- function(x, y, ...) {
  unlink(paste0(y, ".geojson"))
  sf::st_write(x, paste0(y, ".geojson"), quiet = TRUE, delete_dsn = TRUE, ...)
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
    z <- crul::url_parse(z)$path
  }
  fileext <- strsplit(z, "\\.")[[1]]
  fileext[length(fileext)]
}

# If given a url for a zip file, download it give back a path to the
# temporary file
handle_remote <- function(x){
  if (!is.url(x)) {
    return(x)
  } else {
    tfile <- tempfile(fileext = paste0(".", ftype(x)))
    res <- crul::HttpClient$new(x)$get(disk = tfile)
    res$raise_for_status()
    res$content
  }
}
