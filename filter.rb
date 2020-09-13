require 'json'

TIPPECANOE = {
  "my" => {
    "layer" => "my",
    "minzoom" => 11,
    "maxzoom" => 14
  },
  "oh" => {
    "layer" => "oh",
    "minzoom" => 11,
    "maxzoom" => 14
  }
}

FILTERS = {
  "my" => -> (f) { 
    if (f["properties"]["KKOD"] == 1)
      f["tippecanoe"]["minzoom"] = 11
    end
    f
  },
  "oh" => -> (f) {
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
  
