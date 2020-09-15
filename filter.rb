require 'json'
MAXZOOM = 14

# default tippecanoe properties
TIPPECANOE = {
  "al" => {
    "layer" => "al",
    "minzoom" => 10,
    "maxzoom" => MAXZOOM
  },
  "my" => {
    "layer" => "my",
    "minzoom" => 11,
    "maxzoom" => MAXZOOM
  },
  "oh" => {
    "layer" => "oh",
    "minzoom" => 13,
    "maxzoom" => MAXZOOM
  }
}

# filters applied after adding default tippecanoe properties
FILTERS = {
  "al" => -> (f) {
    f
  },
  "my" => -> (f) { 
    f
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
