#!/usr/bin/env rackup
require 'less'
require 'json'

$LOAD_PATH.unshift File.expand_path('../../lib')
require 'wawjs'

$LOAD_PATH.unshift File.expand_path('../src', __FILE__)
require 'gallery'

GALLERY = IGallery.open(File.expand_path('../albums', __FILE__))

map '/' do
  run Gallery.new(GALLERY)
end
map '/model' do
  run Model.new(GALLERY)
end
map '/see' do
  run See.new(GALLERY)
end