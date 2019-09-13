FROM rocker/verse:latest
MAINTAINER Scott Chamberlain <myrmecocystus@gmail.com>

ARG BUILD_DATE
ENV BUILD_DATE=2019-09-12
ENV MRAN https://mran.microsoft.com/snapshot/$BUILD_DATE

RUN apt-get update
RUN apt-get install -y software-properties-common
RUN apt-get upgrade -y
RUN add-apt-repository ppa:cran/jq
RUN add-apt-repository ppa:ubuntugis/ppa
RUN apt-get -y --no-install-recommends install \
  libv8-dev \
  libudunits2-dev \
  libv8-dev \
  libprotobuf-dev \
  libprotoc-dev \
  libproj-dev \
  libgeos-dev \
  libgdal-dev \
  protobuf-compiler \
  valgrind \
  libpq-dev \
  libjq-dev \
  netcdf-bin \
  && . /etc/environment

RUN  Rscript -e "install.packages(c('V8', 'rgdal', 'rgeos', 'devtools', 'Rcpp', 'mime', 'curl', 'jqr', 'sp', 'sf', 'httr', 'maptools', 'jsonlite', 'magrittr', 'readr', 'geojson', 'gistr', 'testthat', 'knitr', 'leaflet', 'DBI', 'RPostgres', 'remotes'), repos = Sys.getenv('MRAN'), Ncpus = 2); remotes::install_github('ropensci/geojsonio@geojson_read-postgis')"
