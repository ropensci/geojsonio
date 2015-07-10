all: move rmd2md

move:
		cp inst/vign/geojsonio_vignette.md vignettes/;\
		cp inst/vign/geojson_spec.md vignettes/;\
		cp inst/vign/maps.md vignettes/;\
		cp -rf inst/vign/figure/* vignettes/figure/

rmd2md:
		cd vignettes;\
		mv geojsonio_vignette.md geojsonio_vignette.Rmd;\
		mv geojson_spec.md geojson_spec.Rmd;\
		mv maps.md maps.Rmd
