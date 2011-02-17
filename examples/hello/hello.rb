NO_CACHE_HEADERS = {'Cache-control' => "no-store, no-cache, must-revalidate", 
                    'Pragma'        => "no-cache", 
                    'Expires'       => "Thu, 01 Dec 1994 16:00:00 GMT"}
Root  = File.expand_path('../../../', __FILE__)

require 'rubygems'
require 'sinatra'

def _ path
  File.expand_path("../#{path}", __FILE__)
end

get '/' do
  set :public, _("public")
  [ 200, 
    NO_CACHE_HEADERS.merge("Content-Type" => "text/html"),
    File.open(_ "public/index.html") ]
end

get '/waw.js' do
 puts `cd #{Root} && cake build`
  [ 200, 
    NO_CACHE_HEADERS.merge("Content-Type" => "text/javascript"),
    File.open(File.join(Root, 'dist/waw-1.0.0.js')) ]
end

get '/app.js' do
  puts `coffee -c #{_ 'public/js/hello.coffee'}`
  [ 200, 
    NO_CACHE_HEADERS.merge("Content-Type" => "text/javascript"),
    File.open(_ 'public/js/hello.js') ]
end