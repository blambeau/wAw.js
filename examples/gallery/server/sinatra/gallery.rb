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

# Returns image file names
def images(prefix = 'images/') 
  Dir[_('public/images/*.jpg')].collect{|f| 
    prefix + File.basename(f)
  }
end

################################################# SINATRA RULES START HERE
require 'rubygems'
require 'sinatra'

NO_CACHE_HEADERS = {'Cache-control' => "no-store, no-cache, must-revalidate", 
                    'Pragma'        => "no-cache", 
                    'Expires'       => "Thu, 01 Dec 1994 16:00:00 GMT"}

# This serves the application
set :public, _('public')

get '/' do
  puts `cd #{_('')} && rake build`
  fread('public/index.html')
end

# Returns the main page
get '/main-page' do
  wlang "main-page.whtml", {:thumbs => images('')}
end

# Returns information about an image
get '/image-info/:image' do 
  wlang "image-info.whtml", params
end

# We force NO CACHE in headers to avoid a known bug in google Chrome 
# (http://www.google.com/support/forum/p/Chrome/thread?tid=4f4114448b03b409&hl=en&start=120)
get '/img/:image' do
  headers NO_CACHE_HEADERS
  send_file _("public/images/#{params[:image]}")
end