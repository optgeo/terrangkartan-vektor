require 'json'
require './filter.rb'

MBTILES_DIR = '/mnt/ssd'
MBTILES = '/mnt/ssd/tiles.mbtiles'
TEMPORARY_DIRECTORY = '/tmp'
SRC = '/mnt/ssd/src/terrang'

GITHUB_URL = "https://optgeo.github.io/terrangkartan-vektor"
LAN_URL = "http://#{`hostname`.strip}:9966"

LAYERS = FILTERS.keys

desc 'create tiles'
task :tiles do
  cmd = []
  dsts = []
  %w{middle north south riks}.each {|area|
    LAYERS.each {|layer|
      path = "#{SRC}/#{area}/#{layer}_#{area}.shp"
      next unless File.exist?(path)
      dst = "#{MBTILES_DIR}/#{layer}_#{area}.mbtiles"
      dsts << dst
      cmd << "(ogr2ogr -oo ENCODING=ISO-8859-1 -f GeoJSONSeq /vsistdout/ #{path} | LAYER=#{layer} ruby filter.rb | tippecanoe --no-progress-indicator --no-feature-limit --no-tile-size-limit --force --simplification=2 --minimum-zoom=#{MINZOOM} --maximum-zoom=#{MAXZOOM} --base-zoom=#{MAXZOOM} --hilbert --output=#{dst} --temporary-directory=#{TEMPORARY_DIRECTORY})"
    }
  }
  cmd = "(#{cmd.join('; ')})"
  cmd += "; tile-join -o #{MBTILES} #{dsts.join(' ')}"
  if ENV['DRY_RUN']
    p cmd
  else
    sh cmd
    sh "tile-join --force --no-tile-compression --output-to-directory=docs/zxy --no-tile-size-limit #{MBTILES}"
  end
end

def style(site_root)
  if site_root
    sh "SITE_ROOT=#{site_root} parse-hocon hocon/style.conf > docs/style.json"
  else
    sh "parse-hocon hocon/style.conf > docs/style.json"
  end
  center = JSON.parse(File.read('docs/zxy/metadata.json'))['center'].split(',')
    .map{|v| v.to_f }.slice(0, 2)
  style = JSON.parse(File.read('docs/style.json'))
  style['center'] = center
  File.write('docs/style.json', JSON.pretty_generate(style))
  sh "gl-style-validate docs/style.json"
end

desc 'create style'
task :style do
  style(nil)
end

desc 'create style for GitHub pages'
task :pages do
  style(GITHUB_URL)
end

desc 'create style for LAN'
task :lan do
  style(LAN_URL)
end

desc 'host the site'
task :host do
  sh "budo -d docs"
end

desc 'run vt-optimizer'
task :optimize do
  sh "node ../vt-optimizer/index.js -m #{MBTILES}"
end
