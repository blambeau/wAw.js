require File.expand_path('../test_helper.rb', __FILE__)
require 'wawjs/dev'
module WawJS
  class DevTest < Test::Unit::TestCase
    include Rack::Test::Methods
    
    FIXTURE = File.expand_path('../fixture', __FILE__)
    VENDOR_JS = File.join(FIXTURE, 'vendor', 'js')

    def app
      Dev.new FIXTURE
    end
    
    def test_exists_in
      assert app.exists_in('wawjs', VENDOR_JS) =~ /min.js$/
      assert_nil app.exists_in('none', VENDOR_JS)
    end
    
    def test_look_for
      assert app.look_for('wawjs') =~ /min.js$/
      assert app.look_for('third') =~ /dev.js$/
      assert_not_nil app.look_for('less')
      assert_not_nil app.look_for('coffee-script')
      assert_nil app.look_for('none')
    end
  
    def test_service_ok_on_existing
      [ 'wawjs', 'third', 'coffee-script' ].each{|which|
        get "/#{which}.js"
        assert last_response.ok?
        assert last_response.content_type =~ /javascript/
      }
    end

    def test_service_ok_on_non_existing
      get '/none.js'
      assert last_response.not_found?
    end
    
    def test_service_ok_on_application_name
      get '/fixture.js'
      assert last_response.ok?
      assert last_response.content_type =~ /javascript/
      assert last_response.include?("Cache-control")
      assert_equal last_response.headers["Pragma"], "no-cache"
    end

  end
end