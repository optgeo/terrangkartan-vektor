require 'json'
MINZOOM = 7
MAXZOOM = 14

# filters applied after adding default tippecanoe properties
FILTERS = {
  'al' => -> (f) { # administrative boundaries (ls)
    f['tippecanoe']['minzoom'] = MINZOOM
  },
  'as' => -> (f) { # administrataive divisions (pt)
    f['tippecanoe']['minzoom'] = MAXZOOM
  },
  'at' => -> (f) { # administrative text (pt)
    f['tippecanoe']['minzoom'] = MAXZOOM
  },
  'bl' => -> (f) { # buildings, built-up aeras and other facilities and areas (ls)
    f['tippecanoe']['minzoom'] = MAXZOOM
  },
  'bs' => -> (f) { # buildings (pt)
    f['tippecanoe']['minzoom'] = MAXZOOM
  },
  'by' => -> (f) { # buildings (pg)
    f['tippecanoe']['minzoom'] = MAXZOOM
  },
  'fl' => -> (f) { # ancient sites and monuments (ls)
    f['tippecanoe']['minzoom'] = MAXZOOM
  },
  'fs' => -> (f) { # ancient sites and monuments (pt)
    f['tippecanoe']['minzoom'] = MAXZOOM
  },
  'gl' => -> (f) { # the earth's shape and form (ls)
    f['tippecanoe']['minzoom'] = MAXZOOM
  },
  'gs' => -> (f) { # the earth's shape and form (pt)
    f['tippecanoe']['minzoom'] = MAXZOOM
  },
  'hl' => -> (f) { # hydrography (ls)
    f['tippecanoe']['minzoom'] = MAXZOOM
  },
  'hs' => -> (f) { # hydrography (pt)
    f['tippecanoe']['minzoom'] = MAXZOOM
  },
  'jl' => -> (f) { # railways (ls)
    f['tippecanoe']['minzoom'] = MAXZOOM
  },
  'js' => -> (f) { # railways (pt)
    f['tippecanoe']['minzoom'] = MAXZOOM
  },
  'kl' => -> (f) { # electricity power transmission lines (ls)
    f['tippecanoe']['minzoom'] = MAXZOOM
  },
  'ks' => -> (f) { # transformer (pt)
    f['tippecanoe']['minzoom'] = MAXZOOM
  },
  'ma' => -> (f) { # cultivated land (pg)
    f['tippecanoe']['minzoom'] = MAXZOOM
  },
  'mb' => -> (f) { # buildings and built-up areas (pg)
    f['tippecanoe']['minzoom'] = MAXZOOM
  },
  'ml' => -> (f) { # land and vegetation cover data (ls; limiting lines for land types)
    f['tippecanoe']['minzoom'] = MAXZOOM
  },
  'mo' => -> (f) { # open land and forest (pg)
    f['tippecanoe']['minzoom'] = MAXZOOM
  },
  'ms' => -> (f) { # marshland and rock outcrops (pg)
    f['tippecanoe']['minzoom'] = MAXZOOM
  },
  'mv' => -> (f) { # water (pg)
    f['tippecanoe']['minzoom'] = MAXZOOM
  },
  'mx' => -> (f) { # terrain with large stone blocks and boulders (pg)
    f['tippecanoe']['minzoom'] = MAXZOOM
  },
  'my' => -> (f) { # land areas (pg)
    if (f['properties']['KKOD'] == 1)
      f['tippecanoe']['minzoom'] = MINZOOM
    else 
      f['tippecanoe']['minzoom'] = 11
    end
  },
  'nl' => -> (f) { # nature conservancy (ls)
    f['tippecanoe']['minzoom'] = MAXZOOM
  },
  'ns' => -> (f) { # nature conservance (pt)
    f['tippecanoe']['minzoom'] = MAXZOOM
  },
  'oh' => -> (f) { # contours (ls)
    if (f['properties']['KKOD'] == 571)
      f['tippecanoe']['minzoom'] = 11
    else
      f['tippecanoe']['minzoom'] = 13
    end
  },
  'os' => -> (f) { # height information (pt)
    f['tippecanoe']['minzoom'] = MAXZOOM
  },
  'ot' => -> (f) { # height text (pt)
    f['tippecanoe']['minzoom'] = MAXZOOM
  },
  'ql' => -> (f) { # military areas (ls)
    f['tippecanoe']['minzoom'] = MAXZOOM
  },
  'sl' => -> (f) { # vegetation cover (ls; belts of forest and windbreaks)
    f['tippecanoe']['minzoom'] = MAXZOOM
  },
  'ss' => -> (f) { # vegetation cover (pt)
    f['tippecanoe']['minzoom'] = MAXZOOM
  },
  'tl' => -> (f) { # place-names (ls)
    f['tippecanoe']['minzoom'] = MAXZOOM - 2
  },
  'tx' => -> (f) { # place-names (pt)
    f['tippecanoe']['minzoom'] = MAXZOOM - 2
  },
  'vl' => -> (f) { # pulbic and private roads (ls)
    f['tippecanoe']['minzoom'] = MAXZOOM - 2
  },
  'vo' => -> (f) { # other roads (ls)
    f['tippecanoe']['minzoom'] = MAXZOOM - 1
  },
  'vs' => -> (f) { # roads (pt)
    f['tippecanoe']['minzoom'] = MAXZOOM - 1
  }
}

if $0 == __FILE__
  $stderr.print "Filtering #{ENV['LAYER']} now.\n"
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
