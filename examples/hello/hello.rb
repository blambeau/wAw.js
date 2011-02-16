NO_CACHE_HEADERS = {'Cache-control' => "no-store, no-cache, must-revalidate", 
                    'Pragma'        => "no-cache", 
                    'Expires'       => "Thu, 01 Dec 1994 16:00:00 GMT"}
Root  = File.expand_path('../../../', __FILE__)

require 'rubygems'
require 'sinatra'

def compile_waw
  sources = File.readlines(File.join(Root, 'src', 'dependencies')).
                 collect{|x| File.join(Root, 'src', x.strip) }
  cmd = "coffee -j -c -o #{File.join(Root, 'lib')} #{sources.join(' ')}"
  puts cmd
  puts `#{cmd}`
  [ "var exports = this;\n",
    "function require(x) {\n   return exports; \n};\n",
    File.read(File.join(Root, 'lib/concatenation.js')) ]
#  [ File.read(File.join(Root, 'lib/concatenation.js')) ]
end

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
  [ 200, 
    NO_CACHE_HEADERS.merge("Content-Type" => "text/javascript"),
    compile_waw ]
end

get '/app.js' do
  puts `coffee -c #{_ 'public/js/hello.coffee'}`
  [ 200, 
    NO_CACHE_HEADERS.merge("Content-Type" => "text/javascript"),
    File.open(_ 'public/js/hello.js') ]
end