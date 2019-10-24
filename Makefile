RSCRIPT = Rscript --no-init-file

install: doc build
	R CMD INSTALL . && rm *.tar.gz

build:
	R CMD build .

doc:
	${RSCRIPT} -e "devtools::document()"

eg:
	${RSCRIPT} -e "devtools::run_examples()"

check:
	${RSCRIPT} -e 'rcmdcheck::rcmdcheck(args = c("--as-cran"))'
		
test:
	${RSCRIPT} -e 'devtools::test()'
