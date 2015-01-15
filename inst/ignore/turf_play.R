turfminjs <- 'https://raw.githubusercontent.com/morganherlocker/turf/master/turf.min.js'
ct <- new_context()
ct$source(turfminjs)

ct$assign("point2", "{
  type: 'Feature',
  geometry: {
    type: 'Point',
    coordinates: [0, 0]
  },
  properties: {}
};
")
ct$get("point2")


ct$assign('polys', '[
  turf.polygon([[
    [ -93.515625, 25.64152637306577 ],
    [ -93.515625, 40.84706035607122 ],
    [ -76.640625, 40.84706035607122 ],
    [ -76.640625, 25.64152637306577 ],
    [ -93.515625, 25.64152637306577 ]]
    ], {
      "fill": "#6BC65F",
      "stroke": "#6BC65F",
      "stroke-width": 5,
      "title": "Avergae pressure of points in poly"
    }),
  turf.polygon([[
    [-123.74999999999999, 29.075375179558346],
    [-123.74999999999999, 42.81152174509788],
    [-96.328125, 42.81152174509788],
    [-96.328125, 29.075375179558346],
    [-123.74999999999999,29.075375179558346]]
    ], {
      "fill": "#25561F",
      "stroke": "#25561F",
      "stroke-width": 5,
      "title": "Avergae pressure of points in poly"
    })
  ];')
ct$assign('poly_fc', 'turf.featurecollection(polys);')
ct$assign('average', "turf.average(poly_fc);")
ct$call('average')

# ct$assign('map', "L.mapbox.map('map', 'morganherlocker.kgidd73k').setView([35.466453, -97.514914], 4);")
# ct$assign('points_layer', "L.mapbox.featureLayer().loadURL('{{site.baseurl}}/assets/js/pressure.json').addTo(map);")
  
