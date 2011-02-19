################################################# SOME TOOLS
# $LOAD_PATH.unshift File.expand_path('../../lib')
# require 'waw/brick'

$LOAD_PATH.unshift File.expand_path('../src', __FILE__)
require 'gallery'

# Root folder of the gallery example
EXAMPLE_ROOT = File.expand_path('..', __FILE__)
GALLERY_ROOT = File.join(EXAMPLE_ROOT, "albums")
GALLERY      = IGallery.open(GALLERY_ROOT)
MODEL        = Model.new(GALLERY)
SEE          = See.new(GALLERY)

# Absolutizes a path from the gallery root (i.e. __DIR__)
def _(relative) 
  File.expand_path(relative, EXAMPLE_ROOT)
end

################################################# SINATRA RULES START HERE
require 'rubygems'
require 'sinatra'
require 'less'
require 'json'

NO_CACHE_HEADERS = {'Cache-control' => "no-store, no-cache, must-revalidate", 
                    'Pragma'        => "no-cache", 
                    'Expires'       => "Thu, 01 Dec 1994 16:00:00 GMT"}

# This serves the application
set :public, _('src/public')

### Main /
get '/' do
  puts `cd #{_('')} && rake build`
  send_file _('src/public/index.html')
end
get '/image/:album/:image' do
  headers NO_CACHE_HEADERS
  image = GALLERY.image(params[:album], params[:image])
  send_file GALLERY._(image[:path])
end
get '/thumb/:album/:image' do
  headers NO_CACHE_HEADERS
  image = GALLERY.image(params[:album], params[:image])
  send_file GALLERY._(image[:thumb])
end

### MODEL
get '/model/:what' do
  content_type :json
  MODEL.send(params[:what], params[:albid]).to_json
end

### SEE
get '/see/:what' do
  send_file _("src/see/public/#{params[:what]}")
end
post '/see/:what' do
  content_type :json
  SEE.send(params[:what], params[:albid], params[:imgid]).to_json
end
