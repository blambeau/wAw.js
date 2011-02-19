################################################# SOME TOOLS
$LOAD_PATH.unshift File.expand_path('../server/lib', __FILE__)
$LOAD_PATH.unshift File.expand_path('../src', __FILE__)
require 'gallery'
require 'model'

# Root folder of the gallery example
EXAMPLE_ROOT = File.expand_path('..', __FILE__)
GALLERY_ROOT = File.join(EXAMPLE_ROOT, "albums")
GALLERY      = Gallery.open(GALLERY_ROOT)
MODEL        = Model.new(GALLERY)

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
set :public, _('public')

get '/' do
  puts `cd #{_('')} && rake build`
  send_file _('public/index.html')
end

# We force NO CACHE in headers to avoid a known bug in google Chrome 
# (http://www.google.com/support/forum/p/Chrome/thread?tid=4f4114448b03b409&hl=en&start=120)
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

# Returns uninstantiated templates to the client part
get %r{^/([\w]+)$} do
  send_file _("templates/#{params[:captures].first}.whtml")
end

# Returns uninstantiated templates to the client part
get %r{^/see/([\w]+)$} do
  send_file _("templates/see/#{params[:captures].first}.whtml")
end

post '/toggle-delete' do
  content_type :json
  GALLERY.toggle_delete_image!(params[:album], params[:image])
end

post '/rotate-right' do
  content_type :json
  GALLERY.rotate_image_right!(params[:album], params[:image])
end

post '/rotate-left' do
  content_type :json
  GALLERY.rotate_image_left!(params[:album], params[:image])
end

get '/model/:what' do
  content_type :json
  MODEL.send(params[:what], params[:albid]).to_json
end
