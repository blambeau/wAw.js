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
