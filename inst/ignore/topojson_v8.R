# ct <- new_context()
# ct$source("~/topojson_bundle.js")
# ct$get(I('Object.keys(global)'))

topojson <- 'http://d3js.org/topojson.v1.min.js'
tp <- new_context()
tp$source(topojson)
tp$get(I('Object.keys(global)'))

tp$assign('topojson', 'require("topojson");')
tp$assign('collection', '{"type":"Point","geometry":{"type":"Point","coordinates":[32.45,-99.74]},"properties":{}};')
tp$eval('topology = topojson.topology({collection: collection});')
tp$get("topology")
tp$console()
tp$eval("console.log(topology.objects.collection)")
