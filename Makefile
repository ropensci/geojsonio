all: move rmd2md

move:
		cp inst/vign/geojsonio_vignette.md vignettes/
		cp -rf inst/vign/figure/* vignettes/figure/

rmd2md:
		cd vignettes;\
		mv geojsonio_vignette.md geojsonio_vignette.Rmd
