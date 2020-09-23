require 'json'
MINZOOM = 7
MAXZOOM = 14

# filters applied after adding default tippecanoe properties
FILTERS = {
  'al' => -> (f) { # administrative boundaries (ls)
    f['tippecanoe']['minzoom'] = 10
  },
  'as' => -> (f) { # administrataive divisions (pt)
    f['tippecanoe']['minzoom'] = MAXZOOM
  },
  'at' => -> (f) { # administrative text (pt)
    f['tippecanoe']['minzoom'] = MAXZOOM
  },
  'by' => -> (f) { # buildings (pg)
    f['tippecanoe']['minzoom'] = MAXZOOM
  },
  'hl' => -> (f) { # hydrography (ls)
    f['tippecanoe']['minzoom'] = MAXZOOM
  },
  'hs' => -> (f) { # hydrography (pt)
    f['tippecanoe']['minzoom'] = MAXZOOM
  },
  'js' => -> (f) { # railways (pt)
    f['tippecanoe']['minzoom'] = MAXZOOM
  },
  'mv' => -> (f) { # water (pg)
    f['tippecanoe']['minzoom'] = MAXZOOM
  },
  'my' => -> (f) { # land areas (pg)
    f['tippecanoe']['minzoom'] = 11
  },
  'oh' => -> (f) { # contours (ls)
    if (f['properties']['KKOD'] == 571)
      f['tippecanoe']['minzoom'] = 11
    else
      f['tippecanoe']['minzoom'] = 13
    end
  }
}

if $0 == __FILE__
  while gets
    f = JSON.parse($_)
    f["tippecanoe"] = {
      'layer' => ENV['LAYER'],
      'maxzoom' => MAXZOOM
    }
    f["properties"].delete("KATEGORI")
    FILTERS[ENV["LAYER"]].call(f)
    print "\x1e#{JSON.dump(f)}\n"
  end
end
