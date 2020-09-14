require 'json'

# default tippecanoe properties
TIPPECANOE = {
  "my" => {
    "layer" => "my",
    "minzoom" => 11,
    "maxzoom" => 14
  },
  "oh" => {
    "layer" => "oh",
    "minzoom" => 13,
    "maxzoom" => 14
  }
}

# filters applied after adding default tippecanoe properties
FILTERS = {
  "my" => -> (f) { 
  },
  "oh" => -> (f) {
    if (f['properties']['KKOD'] == 571)
      f['tippecanoe']['minzoom'] = 11
    end
    f
  }
}

while gets
  f = JSON.parse($_)
  f["tippecanoe"] = TIPPECANOE[ENV["LAYER"]]
  f["properties"].delete("KATEGORI")
  f = FILTERS[ENV["LAYER"]].call(f)
  print "\x1e#{JSON.dump(f)}\n"
end
  
