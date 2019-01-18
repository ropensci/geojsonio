#include <Rcpp.h>

#include <mapnik/map.hpp>
#include <mapnik/unicode.hpp>
// #include <mapnik/json/topojson_utils.hpp>
#include <mapnik/util/geometry_to_geojson.hpp>
#include <mapnik/util/geometry_to_geojson.hpp>
#include <mapnik/util/fs.hpp>

#include <mapnik/geometry.hpp>
// #include <mapnik/geometry/geometry_type.hpp>

#include <mapnik/json/geometry_parser.hpp>

#include <iostream>

using namespace mapnik;

// [[Rcpp::export]]
std::string mk_convert(std::string x) {
  std::string json(x);
  mapnik::geometry::geometry<double> geom;
  mapnik::json::from_geojson(json, geom);
  std::string json_out;
  mapnik::util::to_geojson(json_out, geom);
  return json_out;
};
