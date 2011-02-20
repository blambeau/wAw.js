#!/usr/bin/env rackup
begin
  gem "bundler", "~> 1.0"
  require "bundler/setup"
rescue LoadError => ex
  puts ex.message
  abort "Bundler failed to load, (did you run 'gem install bundler' ?)"
end
require 'wawjs/dev'
require 'json'

$LOAD_PATH.unshift File.expand_path('../src', __FILE__)
require 'gallery'

GALLERY = IGallery.open(File.expand_path('../albums', __FILE__))

use WawJS::NoCache
map '/jsdev' do
  run WawJS::Dev.new __FILE__
end
map '/' do
  run Gallery.new(GALLERY)
end
map '/model' do
  run Model.new(GALLERY)
end
map '/see' do
  run See.new(GALLERY)
end