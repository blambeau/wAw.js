require File.expand_path('../test_helper.rb', __FILE__)
require 'test/unit'
require 'rack/test'
ENV['RACK_ENV'] = 'test'

class GalleryTest < Test::Unit::TestCase
  include Rack::Test::Methods

  def app
    Gallery
  end
  
  def test_public
    get "/index.html"
    assert last_response.ok?
  end

end
