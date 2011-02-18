################################################# SOME TOOLS

# Root folder of the gallery example
GALLERY_ROOT = File.expand_path('../../..', __FILE__)

# Absolutizes a path from the gallery root (i.e. __DIR__)
def _(relative) 
  File.expand_path(relative, GALLERY_ROOT)
end

# Returns the contents of a file. If relativize is set to
# true, the _(f) method is used instead of f itself.
def fread(f, relativize = true)
  File.read(relativize ? _(f) : f)
end

# Instantiates a template using wlang
def wlang(tpl, context = {}) 
  require 'wlang'
  WLang.file_instantiate(_("templates/#{tpl}"), context)
end

################################################# MODEL

# Returns albums names
def albums 
  Dir[_('albums/*')].collect{|f| File.basename(f)}
end

# Returns image file names
def images(album = '') 
  Dir[_("albums/#{album}/*.jpg")].collect{|f| 
    File.basename(f)
  }
end

################################################# SINATRA RULES START HERE
require 'rubygems'
require 'sinatra'
require 'json'

NO_CACHE_HEADERS = {'Cache-control' => "no-store, no-cache, must-revalidate", 
                    'Pragma'        => "no-cache", 
                    'Expires'       => "Thu, 01 Dec 1994 16:00:00 GMT"}

# This serves the application
set :public, _('public')

get '/' do
  puts `cd #{_('')} && rake build`
  fread('public/index.html')
end

# We force NO CACHE in headers to avoid a known bug in google Chrome 
# (http://www.google.com/support/forum/p/Chrome/thread?tid=4f4114448b03b409&hl=en&start=120)
get '/image/:album/:image' do
  headers NO_CACHE_HEADERS
  send_file _("albums/#{params[:album]}/#{params[:image]}")
end
get '/thumb/:album/:image' do
  headers NO_CACHE_HEADERS
  send_file _("albums/#{params[:album]}/thumbs/#{params[:image]}")
end

# Returns uninstantiated templates to the client part
get %r{/([\w]+).whtml} do
  send_file _("templates/#{params[:captures].first}.whtml")
end

# Returns info about albums
get '/albums.json' do
  content_type :json
  albums.collect{|alb|
    { 'id'   => alb,
      'name' => alb }
  }.to_json
end

# Returns info about images
get '/images.json' do
  content_type :json
  album = params[:album]
  images(album).collect{|img|
    { 'album'    => album,
      'basename' => img, 
      'url'      => "/image/#{album}/#{img}",
      'thumb'    => "/thumb/#{album}/#{img}" }
  }.to_json
end
