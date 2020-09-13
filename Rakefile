require 'json'

GITHUB_URL = "https://optgeo.github.io/terrangkartan-vektor"

LAYERS = %w{
  my oh
}

desc 'create tiles'
task :tiles do
  cmd = []
  1.upto(30) {|i|
    d = sprintf('%02d', i)
    LAYERS.each {|layer|
      path = "src/terrang/#{d}/#{layer}_#{d}.shp"
      next unless File.exist?(path)
      cmd << "(ogr2ogr -oo ENCODING=ISO-8859-1 -f GeoJSONSeq /vsistdout/ #{path} | LAYER=#{layer} ruby filter.rb)"
    }
  }
  cmd = "(#{cmd.join('; ')})"
  cmd += " | tippecanoe --no-feature-limit --no-tile-size-limit --force --simplification=2 --maximum-zoom=14 --base-zoom=14 --hilbert --output=tiles.mbtiles"
  sh cmd
  sh "tile-join --force --no-tile-compression --output-to-directory=docs/zxy --no-tile-size-limit tiles.mbtiles"
end

desc 'create style'
task :style do
  sh "parse-hocon hocon/style.conf > docs/style.json"
  center = JSON.parse(File.read('docs/zxy/metadata.json'))['center'].split(',')
    .map{|v| v.to_f }.slice(0, 2)
  style = JSON.parse(File.read('docs/style.json'))
  style['center'] = center
  File.write('docs/style.json', JSON.pretty_generate(style))
  sh "gl-style-validate docs/style.json"
end

desc 'create style for GitHub pages'
task :pages do
  sh "SITE_ROOT=#{GITHUB_URL} parse-hocon hocon/style.conf > docs/style.json"
  center = JSON.parse(File.read('docs/zxy/metadata.json'))['center'].split(',')
    .map{|v| v.to_f }.slice(0, 2)
  style = JSON.parse(File.read('docs/style.json'))
  style['center'] = center
  File.write('docs/style.json', JSON.pretty_generate(style))
  sh "gl-style-validate docs/style.json"
end

desc 'host the site'
task :host do
  sh "budo -d docs"
end

desc 'run vt-optimizer'
task :optimize do
  sh "node ../vt-optimizer/index.js -m tiles.mbtiles"
end

