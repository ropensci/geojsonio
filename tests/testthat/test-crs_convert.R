library(sf)
sfc <-  st_sfc(st_point(c(0,0)), st_point(c(1,1)))
sf <-  st_sf(a = 1:2, geom = sfc)
st_crs(sf) <-  4326
detect_convert_crs(sf)

st_crs(sf) <- 3005
detect_convert_crs(sf)

st_crs(sfc) <- 4326
detect_convert_crs(sfc)

st_crs(sfc) <- 3005
detect_convert_crs(sfc)

library(sp)
pts = cbind(1:5, 1:5)
df = data.frame(a = 1:5)

spdf <- SpatialPointsDataFrame(pts, df)
proj4string(spdf) <- CRS("+init=epsg:4326")
detect_convert_crs(spdf)

proj4string(spdf) <- CRS("+init=epsg:3005")
detect_convert_crs(spdf)
