# ct <- new_context()
# ct$source("~/topojson_bundle.js")
# ct$get(I('Object.keys(global)'))

topojson <- 'http://d3js.org/topojson.v1.min.js'
ct <- new_context()
ct$source(topojson)
ct$get(I('Object.keys(global)'))

ct$assign('topojson', 'require("topojson");')
ct$assign('collection', '{"type":"Point","geometry":{"type":"Point","coordinates":[32.45,-99.74]},"properties":{}};')
ct$assign('topology', 'topojson.topology({collection: collection});')
ct$console()
ct$eval("console.log(topology.objects.collection)")
