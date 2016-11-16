library(sf)
## MULTIPOINT
p <- rbind(c(3.2,4), c(3,4.6), c(3.8,4.4), c(3.5,3.8), c(3.4,3.6), c(3.9,4.5))
mp <- st_multipoint(p)
## LINESTRING
s1 <- rbind(c(0,3),c(0,4),c(1,5),c(2,5))
ls <- st_linestring(s1)
## MULTILINESTRING
s2 <- rbind(c(0.2,3), c(0.2,4), c(1,4.8), c(2,4.8))
s3 <- rbind(c(0,4.4), c(0.6,5))
mls <- st_multilinestring(list(s1,s2,s3))
## POLYGON
p1 <- rbind(c(0,0), c(1,0), c(3,2), c(2,4), c(1,4), c(0,0))
p2 <- rbind(c(1,1), c(1,2), c(2,2), c(1,1))
pol <-st_polygon(list(p1,p2))
## MULTIPOLYGON
p3 <- rbind(c(3,0), c(4,0), c(4,1), c(3,1), c(3,0))
p4 <- rbind(c(3.3,0.3), c(3.8,0.3), c(3.8,0.8), c(3.3,0.8), c(3.3,0.3))[5:1,]
p5 <- rbind(c(3,3), c(4,2), c(4,3), c(3,3))
mpol <- st_multipolygon(list(list(p1,p2), list(p3,p4), list(p5)))
## GEOMETRYCOLLECTION
gc <- st_geometrycollection(list(mp, mpol, ls))

mpol_sfc <- st_sfc(mpol)
mpol_sf <- st_sf(id = "a", mpol_sfc)
geojson_list(mpol)
geojson_list(mpol_sfc)
geojson_list(mpol_sf)

geojson_json(mpol)
geojson_json(mpol_sfc)
geojson_json(mpol_sf)

gc_sfc <- st_sfc(gc)
gc_sf <- st_sf(id = "a", gc_sfc)
geojson_list(gc)
geojson_list(gc_sfc)
geojson_list(gc_sf)

geojson_json(gc)
geojson_json(gc_sfc)
geojson_json(gc_sf)

## Big test
library(bcmaps)
st_as_sf(ecoprovinces)
eco_sf <- st_as_sf(ecoprovinces)
eco_sf <- st_transform(eco_sf, 4326)
eco_geojson <- geojson_json(eco_sf)
writeLines(eco_geojson, "eco.geojson")
