library("RPostgres")
library("rgdal")

dbGetSp <- function(dbInfo, query) {
  # if(!require('rgdal')|!require(RPostgreSQL))stop('missing rgdal or RPostgreSQL')
  d <- dbInfo
  tmpTbl <- sprintf('tmp_table_%s',round(runif(1)*1e5))
  dsn <- sprintf("PG:dbname='%s' host='%s' port='%s'",
                 d$dbname, "localhost", 5432
  )
#   dsn <- sprintf("PG:dbname='%s' host='%s' port='%s' user='%s' password='%s'",
#                  d$dbname,d$host,d$port,d$user,d$password
#   )
  # drv <- dbDriver("PostgreSQL")
  # con <- dbConnect(drv, dbname=d$dbname, host='localhost', port=5432)
  tryCatch({
    sql <- sprintf("CREATE UNLOGGED TABLE %s AS %s", tmpTbl, query)
    res <- dbSendQuery(con, sql)
    nr <- dbGetInfo(res)$rowsAffected
    if(nr<1){
      warning('There is no feature returned.');
      return()
    }
    sql <- sprintf("SELECT f_geometry_column from geometry_columns WHERE f_table_name='%s'",tmpTbl)
    geo <- dbGetQuery(con,sql)
    if(length(geo)>1){
      tname <- sprintf("%s(%s)",tmpTbl,geo$f_geometry_column[1])
    }else{
      tname <- tmpTbl;
    }
    out <- readOGR(dsn,tname)
    return(out)
  },finally={
    sql <- sprintf("DROP TABLE %s",tmpTbl)
    dbSendQuery(con,sql)
    dbClearResult(dbListResults(con)[[1]])
    dbDisconnect(con)
  })
}

library("DBI")
con <- dbConnect(RPostgres::Postgres(), dbname="spatial_db", host='localhost', port=5432)
DBI::dbSendQuery(con, "CREATE TABLE spatial_table;")
d <- list(host='localhost', dbname='spatial_db')
dbGetSp(dbInfo=d, query="SELECT * FROM spatial_table")
