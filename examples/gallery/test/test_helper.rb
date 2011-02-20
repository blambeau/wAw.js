require 'rubygems'
require 'test/unit'
require 'rack/test'
ENV['RACK_ENV'] = 'test'

$LOAD_PATH.unshift File.expand_path('../../../../lib', __FILE__)
require 'wawjs'

$LOAD_PATH.unshift File.expand_path('../../src', __FILE__)
require 'gallery'
